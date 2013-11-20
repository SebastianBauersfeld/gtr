Attribute VB_Name = "m_022_SPECIALEFFECTS_01"
Option Explicit


'===Enums===
Public Enum EColorTransform
    ONLY_START_COLOR = 1
    START_AND_INV_COLOR
    ALL_COLORS
End Enum

Private Enum EAlphaEffect
    A_OFF = 1
    A_ADD
    A_MULTIPLY
    A_SUBTRACT
    A_INVERT
End Enum


'===Typendefinitionen===
Private Type TEffectParticle
    VX                                  As Single
    VY                                  As Single
    MX                                  As Single
    MY                                  As Single
    RAD                                 As Single
    RS                                  As Single
    Attenuation                         As Single
    Radius                              As Single
End Type

Public Type TEffect
    Draw                        As Boolean
    
    InfiniteSpread              As Boolean
    CurrentParticle             As Long
    CurAddParticle              As Single
    
    ParticleCount               As Long
   
    X                           As Single
    Y                           As Single
    VelX                        As Single
    VelY                        As Single
    AccX                        As Single
    AccY                        As Single
    
    StartMinRadius              As Single
    StartMaxRadius              As Single
    EndRadius                   As Single
    
    SpreadRangeOffset           As Single
    SpreadRange                 As Single
        
    VMaxIncreasing              As Single
    VMinIncreasing              As Single
    VDivIncreasing              As Boolean
    
    VDecelThreshold             As Single
    VDeceleration               As Single
    
    ColorMode                   As EColorTransform
    StartColor                  As D3DCOLORVALUE
    InvColor                    As D3DCOLORVALUE
    EndColor                    As D3DCOLORVALUE
    
    MinParticleRadius           As Single
    MaxParticleRadius           As Single
    
    MinParticleRot              As Single
    MaxParticleRot              As Single
    
    AttenuationStartRange       As Single
    AttenuationSpeed            As Single
    AttenuationExpMode          As Boolean

    Particle()                  As TEffectParticle
End Type

Public Type TLight
    Draw                        As Boolean
    X                           As Single
    Y                           As Single
    VelX                        As Single
    VelY                        As Single
    AccX                        As Single
    AccY                        As Single
    
    Radius                      As Single
    iRadius                     As Single
    
    Color                       As D3DCOLORVALUE
    Intensity                   As Single
    
    AttenuationSpeed            As Single
    Attenuation                 As Single
    
    VDecelThreshold             As Single
    VDeceleration               As Single
End Type

Private Type TWaveNetParticle
    Vertex(1 To 4)              As D3DVERTEX
    Height                      As Single
    Draw                        As Boolean
End Type

Public Type T3DWave
    Draw                        As Boolean

    Amplitude                   As Single
    AmpAttenuation              As Single
    WaveLength                  As Single
    WaveCount                   As Single
    MaxRad                      As Single
    RAD                         As Single
    
    c                           As Single
    cAttenuation                As Single
    
    X                           As Single
    Y                           As Single
    SrcX                        As Long
    SrcY                        As Long
End Type

Private Type TBlurNetParticle
    Vertex(1 To 4)              As D3DVERTEX
End Type

'===interne Variablen===
Private FXVertex(1 To 4)                    As D3DVERTEX

'ShockWave
Private Const ELEMENT_WIDTH                 As Long = 16
Private Const ELEMENT_HEIGHT                As Long = 16
Private Const TEXTURE_WIDTH                 As Long = 256
Private Const TEXTURE_HEIGHT                As Long = 256

Private Const HNET_ELEMENTS                 As Long = 1024 / ELEMENT_WIDTH
Private Const VNET_ELEMENTS                 As Long = 768 / ELEMENT_HEIGHT
Private Const HT_ELEMENTS                   As Long = 1024 / TEXTURE_WIDTH
Private Const VT_ELEMENTS                   As Long = 768 / TEXTURE_HEIGHT

Private WaveNetV(1 To HNET_ELEMENTS, 1 To VNET_ELEMENTS)        As TWaveNetParticle
Private WaveNetT(1 To HT_ELEMENTS, 1 To VT_ELEMENTS)            As DirectDrawSurface7

Private ScreenRadius                        As Single

'MotionBlur
Private BlurNetV(1 To HNET_ELEMENTS, 1 To VNET_ELEMENTS)        As TBlurNetParticle
Private BlurNetT(1 To HT_ELEMENTS, 1 To VT_ELEMENTS)            As DirectDrawSurface7

Public Sub InitEffects()
    Dim n As Long

    g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, FXVertex(1)
    g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0, FXVertex(2)
    g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, FXVertex(3)
    g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 1, FXVertex(4)
    
End Sub

Public Sub SetCam()

    'BildschirmPosition setzen
    g_DX.IdentityMatrix g_matView
                              
    g_DX.ViewMatrix g_matView, SetVector(0, 0, -30), SetVector(0, 0, 0), SetVector(0, 1, 0), 0
    
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, g_matView
      
    'Projektion der 3D-Welt festlegen
    g_DX.IdentityMatrix g_matProj
        
    g_DX.ProjectionMatrix g_matProj, 1, 100, PI / 3
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_PROJECTION, g_matProj
        
End Sub

Public Function IsEffectInRect(iRect As TRectSng, ByRef iEffect As TEffect, X As Single, Y As Single) As Boolean
    Dim r As Single
    
    IsEffectInRect = False
    
    With iEffect
        r = .StartMaxRadius
        If r < .StartMinRadius Then r = .StartMinRadius
        If r < .EndRadius Then r = .EndRadius
        
        If IsInRectR(iRect, X, Y, r) Then
           
            IsEffectInRect = True
           
        End If
    End With
    
End Function

Private Sub PrepareEffectMaterial(iEffect As TEffect, ByRef T As Single)
    
    With iEffect
        Select Case .ColorMode
        Case ONLY_START_COLOR
                SetMaterialE .StartColor.r - T, .StartColor.g - T, .StartColor.b - T
        Case ALL_COLORS
            If T < 0.333 Then
                SetMaterialE .StartColor.r - T, .StartColor.g - T, .StartColor.b - T
            ElseIf T < 0.666 Then
                SetMaterialE T - .InvColor.b, T - .InvColor.r, T - .InvColor.g
            Else
                SetMaterialE .EndColor.r - T, .EndColor.g - T, .EndColor.b - T
            End If
        Case START_AND_INV_COLOR
            If T < 0.4 Then
                SetMaterialE T - .StartColor.b, T - .StartColor.r, T - .StartColor.g
            Else
                SetMaterialE .InvColor.r - T, .InvColor.g - T, .InvColor.b - T
            End If
        End Select
    End With
    
End Sub


Private Sub SetMaterialE(ByRef r As Single, ByRef g As Single, ByRef b As Single)

    g_Material.emissive.r = r
    g_Material.emissive.g = g
    g_Material.emissive.b = b

    g_D3DDev.SetMaterial g_Material

End Sub
    

Private Sub SetAlpha(ByRef Alpha As Long, ByRef Effect As EAlphaEffect, ByRef Textured As Boolean)
    Dim Src As Long
    Dim Dest As Long
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, Alpha
        
    If InStr(1, g_DDI.GetDescription, "Voodoo", vbBinaryCompare) > 0 Then
        Select Case Effect
        Case A_OFF
            Src = 1
            Dest = 1
        Case A_ADD
            Src = 2
            Dest = 2
        Case A_MULTIPLY
            Src = 3
            Dest = 5
        Case A_SUBTRACT
            Src = 3
            Dest = 7
        Case A_INVERT
            Src = 10
            Dest = 4
        End Select
    Else
        If Textured Then
            Select Case Effect
            Case A_OFF
                Src = 2
                Dest = 1
            Case A_ADD
                Src = 2
                Dest = 2
            Case A_MULTIPLY
                Src = 9
                Dest = 5
            Case A_SUBTRACT
                Src = 6
                Dest = 3
            Case A_INVERT
                Src = 10
                Dest = 4
            End Select
        Else
            Select Case Effect
            Case A_OFF
                Src = 2
                Dest = 1
            Case A_ADD
                Src = 2
                Dest = 2
            Case A_MULTIPLY
                Src = 9
                Dest = 6
            Case A_SUBTRACT
                Src = 9
                Dest = 5
            Case A_INVERT
                Src = 10
                Dest = 4
            End Select
        End If
    End If
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, Src
    g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, Dest

End Sub
Private Function IsInRectR(iRect As TRectSng, X As Single, Y As Single, r As Single) As Boolean

    IsInRectR = False

    If X + r > iRect.Left And X - r < iRect.Right And Y + r > iRect.Top And Y - r < iRect.Bottom Then
        IsInRectR = True
    End If

End Function


Public Function SetColor(r As Single, g As Single, b As Single) As D3DCOLORVALUE

    SetColor.r = r / 255
    SetColor.g = g / 255
    SetColor.b = b / 255

End Function

'definiert einen D3D-Vector
Private Function SetVector(ByVal a As Single, ByVal b As Single, ByVal c As Single) As D3DVECTOR
    
    With SetVector
        .X = a
        .Y = b
        .Z = c
    End With
    
End Function


'Pythagoras (Addition)
Private Function Pyth(ByVal a As Single, ByVal b As Single) As Single

    Pyth = Sqr(a * a + b * b)

End Function

'#########################################################################################################
'#########################################################################################################
'#########################################################################################################
'ParticleEffects

Public Sub SetEffect(ByRef iEffect As TEffect, ByRef X As Single, ByRef Y As Single)
    Dim k As Long
    
    With iEffect
            
        .Draw = True
        
        .X = X
        .Y = Y
        
         If .InfiniteSpread Then
            
                .CurrentParticle = 0
                
                SetParticle .Particle(1), iEffect
            
        Else
        
            For k = 1 To .ParticleCount
            
                SetParticle .Particle(k), iEffect
                
            Next k
        
        End If
        
    End With

End Sub

Public Sub DrawEffect(ByRef iEffect As TEffect, ByRef Texture As DirectDrawSurface7)
    Dim n                   As Long
    Dim k                   As Long
    Dim RX                  As Single
    Dim RY                  As Single
    Dim CSlow               As Single
        
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, 2
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, 2
        
    SetAlpha 1, A_ADD, True
    
    g_D3DDev.BeginScene
    
        g_D3DDev.SetTexture 0, Texture
    
        With iEffect
            
            If .InfiniteSpread Then
            
                If .CurAddParticle >= 1 Then .CurAddParticle = 0
                
                .CurAddParticle = .CurAddParticle + .ParticleCount * .AttenuationSpeed * g_App.AVFGS
                
                If .CurAddParticle > 1 Then .CurAddParticle = Int(.CurAddParticle)
                
                If .CurAddParticle > .ParticleCount Then .CurAddParticle = .ParticleCount
            
                .CurrentParticle = .CurrentParticle + .CurAddParticle
                If .CurrentParticle > .ParticleCount - .CurAddParticle Then .CurrentParticle = 0
                
                For k = .CurrentParticle + 1 To .CurrentParticle + .CurAddParticle
                
                    SetParticle iEffect.Particle(k), iEffect
                                    
                Next k
            Else
            
                If .Particle(5).Attenuation > 1.1 Then
                    If .ParticleCount > 0 And .CurrentParticle = 0 Then
                        If .Particle(.ParticleCount - 4).Attenuation > 1.1 Then .Draw = False
                    End If
                End If

            End If
    
        End With
        
        If iEffect.Draw Then
            For n = 1 To iEffect.ParticleCount
                With iEffect.Particle(n)
            
                    If .Attenuation > iEffect.VDecelThreshold And iEffect.VDeceleration <> 1 Then
                        .MX = .MX * iEffect.VDeceleration * CSlow
                        .MY = .MY * iEffect.VDeceleration * CSlow
                    End If
                        
                    .MX = .MX + iEffect.AccX * g_App.AVFGS
                    .MY = .MY + iEffect.AccY * g_App.AVFGS
            
                    .VX = .VX + .MX * g_App.AVFGS
                    .VY = .VY + .MY * g_App.AVFGS
                    
                    .RAD = .RAD + .RS * g_App.AVFGS
                    
                    If iEffect.AttenuationExpMode Then
                        .Attenuation = (.Attenuation ^ 2 + iEffect.AttenuationSpeed * g_App.AVFGS) / (.Attenuation + 0.0001)
                    Else
                        .Attenuation = .Attenuation + iEffect.AttenuationSpeed * g_App.AVFGS
                    End If
                    
                    If IsInRectR(g_Map.Wnd, iEffect.X + .VX, iEffect.Y + .VY, iEffect.MaxParticleRadius * 15) Then
                                            
                        RX = (iEffect.X + .VX - g_Map.Wnd.Left) / g_D3DDivX + g_D3DSubX
                        RY = -(iEffect.Y + .VY - g_Map.Wnd.Top) / g_D3DDivY + g_D3DSubY
    
                        If .RS = 0 Then
                            FXVertex(1).X = RX - .Radius
                            FXVertex(1).Y = RY + .Radius
        
                            FXVertex(2).X = RX + .Radius
                            FXVertex(2).Y = RY + .Radius
        
                            FXVertex(3).X = RX - .Radius
                            FXVertex(3).Y = RY - .Radius
        
                            FXVertex(4).X = RX + .Radius
                            FXVertex(4).Y = RY - .Radius
                        Else
                            FXVertex(1).X = RX + Cos(.RAD) * .Radius
                            FXVertex(1).Y = RY + Sin(.RAD) * .Radius
        
                            FXVertex(2).X = RX + Cos(.RAD + HPI) * .Radius
                            FXVertex(2).Y = RY + Sin(.RAD + HPI) * .Radius
        
                            FXVertex(3).X = RX + Cos(.RAD + HPI + PI) * .Radius
                            FXVertex(3).Y = RY + Sin(.RAD + HPI + PI) * .Radius
        
                            FXVertex(4).X = RX + Cos(.RAD + PI) * .Radius
                            FXVertex(4).Y = RY + Sin(.RAD + PI) * .Radius
                        End If
                        
                        PrepareEffectMaterial iEffect, .Attenuation
                        
                        g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_LVERTEX, FXVertex(1), 4, D3DDP_DEFAULT
                                                    
                    End If
                                    
                End With
            Next n
        End If
           
    g_D3DDev.EndScene
    
End Sub

Private Sub SetParticle(ByRef Particle As TEffectParticle, ByRef iEffect As TEffect)
    Dim r As Single
    Dim RAD As Single
    Dim inc As Single
    Dim V As Single
    Dim a As Single
    
    With Particle
        RAD = Rnd * iEffect.SpreadRange + iEffect.SpreadRangeOffset
        inc = Rnd * (iEffect.VMaxIncreasing - iEffect.VMinIncreasing) + iEffect.VMinIncreasing
        
        V = ((iEffect.EndRadius - iEffect.StartMinRadius) * iEffect.AttenuationSpeed)
         
        If (iEffect.VMaxIncreasing = 0 And iEffect.VMinIncreasing = 0) Then inc = 1
        
        If iEffect.VDivIncreasing Then
            .MX = (Cos(RAD)) * V / inc + iEffect.VelX
            .MY = (Sin(RAD)) * V / inc + iEffect.VelY
        Else
            .MX = (Cos(RAD)) * V * inc + iEffect.VelX
            .MY = (Sin(RAD)) * V * inc + iEffect.VelY
        End If
        
        r = Rnd * (iEffect.StartMaxRadius - iEffect.StartMinRadius) + iEffect.StartMinRadius
        
        .VX = Cos(RAD) * r
        .VY = Sin(RAD) * r

        .RS = Rnd * (iEffect.MaxParticleRot - iEffect.MinParticleRot) + iEffect.MinParticleRot

        .Attenuation = Rnd * iEffect.AttenuationStartRange

        .Radius = Rnd * (iEffect.MaxParticleRadius - iEffect.MinParticleRadius) + iEffect.MinParticleRadius
        
    End With

End Sub

'#########################################################################################################
'#########################################################################################################
'#########################################################################################################
'Lights

Public Sub SetLight(ByRef iLight As TLight, ByRef Attenuation As Single, ByRef X As Single, ByRef Y As Single)
    
    With iLight
        
        .Draw = True
        
        .Attenuation = Attenuation
        
        .X = X
        .Y = Y
        
         .iRadius = (.Radius / g_D3DDivX)
        
    End With

End Sub

Public Sub DrawLight(ByRef iLight As TLight, ByRef Texture As DirectDrawSurface7)
    Dim n                   As Long
    Dim RX                  As Single
    Dim RY                  As Single
    Dim f                   As Single
    Dim CSlow               As Single
    
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, 2
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, 2
    
    CSlow = 1 - 0.01 * g_App.AVFGS
    
    SetAlpha 1, A_MULTIPLY, True
    
    g_D3DDev.BeginScene
    
        g_D3DDev.SetTexture 0, Texture
    
        With iLight
                       
            If .Attenuation > 1 Then .Draw = False
              
            If .Draw Then
                
                If .Attenuation > .VDecelThreshold Then
                    .VelX = .VelX * .VDeceleration * CSlow
                    .VelY = .VelY * .VDeceleration * CSlow
                End If
                    
                .VelX = .VelX + .AccX * g_App.AVFGS
                .VelY = .VelY + .AccY * g_App.AVFGS
        
                .X = .X + .VelX * g_App.AVFGS
                .Y = .Y + .VelY * g_App.AVFGS
                
                .Attenuation = .Attenuation + .AttenuationSpeed * g_App.AVFGS
                
                If IsInRectR(g_Map.Wnd, .X, .Y, .Radius) Then
                                        
                    RX = (.X - g_Map.Wnd.Left) / g_D3DDivX + g_D3DSubX
                    RY = -(.Y - g_Map.Wnd.Top) / g_D3DDivY + g_D3DSubY
        
                    FXVertex(1).X = RX - .iRadius
                    FXVertex(1).Y = RY + .iRadius * 1.3
    
                    FXVertex(2).X = RX + .iRadius
                    FXVertex(2).Y = RY + .iRadius * 1.3
    
                    FXVertex(3).X = RX - .iRadius
                    FXVertex(3).Y = RY - .iRadius * 1.3
    
                    FXVertex(4).X = RX + .iRadius
                    FXVertex(4).Y = RY - .iRadius * 1.3
                
                    SetMaterialE .Color.r - .Attenuation, .Color.g - .Attenuation, .Color.b - .Attenuation
                    
                    For n = 1 To CLng(.Intensity)
                        g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_LVERTEX, FXVertex(1), 4, D3DDP_DEFAULT
                    Next
                    
                    f = .Intensity - CLng(.Intensity)
                    If f > 0 Then
                        SetMaterialE (.Color.r - .Attenuation) * f, (.Color.g - .Attenuation) * f, (.Color.b - .Attenuation) * f
                        g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_LVERTEX, FXVertex(1), 4, D3DDP_DEFAULT
                    End If
                    
                End If
                
            End If
                                                    
        End With
               
    g_D3DDev.EndScene
    
End Sub

'#########################################################################################################
'#########################################################################################################
'#########################################################################################################
'ShockWaves

Public Sub InitWaveNet(ByRef Tex256x256 As String)
    Dim n As Long
    Dim m As Long
    Dim ddsd3 As DDSURFACEDESC2
    Dim TextureEnum As Direct3DEnumPixelFormats
    Dim dx As Long
    Dim dy As Long
    Dim tu1 As Single
    Dim tu2 As Single
    Dim tv1 As Single
    Dim tv2 As Single
       
    ScreenRadius = Pyth(HNET_ELEMENTS / 2, VNET_ELEMENTS / 2)
 
    'Texturen erstellen (laden)
    Set TextureEnum = g_D3DDev.GetTextureFormatsEnum()
    TextureEnum.GetItem 1, ddsd3.ddpfPixelFormat
    ddsd3.ddsCaps.lCaps = DDSCAPS_TEXTURE

    For n = 1 To HT_ELEMENTS
       For m = 1 To VT_ELEMENTS
    
            Set WaveNetT(n, m) = g_DD.CreateSurfaceFromFile(Tex256x256, ddsd3)
    
        Next m
    Next n
    
    'Texturkoordinaten einstellen
    dx = TEXTURE_WIDTH / ELEMENT_WIDTH
    dy = TEXTURE_HEIGHT / ELEMENT_HEIGHT
    
    For n = 0 To HNET_ELEMENTS - 1
        For m = 0 To VNET_ELEMENTS - 1
            
            tu1 = (n Mod dx) / dx
            tv1 = (m Mod dy) / dy
            tu2 = (n Mod dx + 1) / dx
            tv2 = (m Mod dy + 1) / dy
    
            With WaveNetV(n + 1, m + 1)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu1, tv1, .Vertex(1)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu2, tv1, .Vertex(2)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu1, tv2, .Vertex(3)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu2, tv2, .Vertex(4)
            End With
            
        Next m
        
    Next n
    
    'Vertices als Netz aufbauen
    Dim hf As Single
    Dim vf As Single
    
    Dim realHNET_ELEMENTS As Single
    Dim realVNET_ELEMENTS As Single
    
    hf = ELEMENT_WIDTH / g_D3DDivX
    vf = ELEMENT_HEIGHT / g_D3DDivY
    
    realHNET_ELEMENTS = g_App.ResX / ELEMENT_WIDTH
    realVNET_ELEMENTS = g_App.ResY / ELEMENT_HEIGHT
    
    For n = 1 To HNET_ELEMENTS
        For m = 1 To VNET_ELEMENTS
            With WaveNetV(n, m)
            
                .Vertex(1).X = (n - 1 - realHNET_ELEMENTS / 2) * hf
                .Vertex(1).Y = (-m + 1 + realVNET_ELEMENTS / 2) * vf
    
                .Vertex(2).X = (n - realHNET_ELEMENTS / 2) * hf
                .Vertex(2).Y = (-m + 1 + realVNET_ELEMENTS / 2) * vf
    
                .Vertex(3).X = (n - 1 - realHNET_ELEMENTS / 2) * hf
                .Vertex(3).Y = (-m + realVNET_ELEMENTS / 2) * vf
    
                .Vertex(4).X = (n - realHNET_ELEMENTS / 2) * hf
                .Vertex(4).Y = (-m + realVNET_ELEMENTS / 2) * vf
                                
            End With
        Next m
    Next n
    
End Sub

Public Sub SetWaveNet(ByRef iWave As T3DWave, ByRef X As Single, ByRef Y As Single)
    
    With iWave
        .Draw = True
        
        .MaxRad = .WaveCount * TPI
        .RAD = 0
        
        .X = X - g_Map.Wnd.Left
        .Y = Y - g_Map.Wnd.Top
        
    End With
    
End Sub

Public Sub DrawWaveNet()
    Dim n As Long
    Dim m As Long
    Dim Material As D3DMATERIAL7
    Dim dx As Long
    Dim dy As Long
    
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, 1
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, 1
    
    RefreshWaveTextures
        
    dx = TEXTURE_WIDTH / ELEMENT_WIDTH
    dy = TEXTURE_HEIGHT / ELEMENT_HEIGHT
    
    g_D3DDev.BeginScene
        
        SetAlpha 0, A_OFF, True
    
        SetMaterialE 1, 1, 1
        
        For n = 1 To HNET_ELEMENTS
            For m = 1 To VNET_ELEMENTS
            
                If WaveNetV(n, m).Draw Then
                
                    g_D3DDev.SetTexture 0, WaveNetT((n - 1) \ dx + 1, (m - 1) \ dy + 1)
                
                    g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, WaveNetV(n, m).Vertex(1), 4, D3DDP_DEFAULT
                    
                End If
                    
            Next m
        Next n
        
    g_D3DDev.EndScene

End Sub

Public Sub MoveWaves(ByRef iWave() As T3DWave, ByRef iBegin As Long, ByRef iEnd As Long)
    Dim n As Long
    Dim m As Long
    Dim k As Long
    
    Dim MinOneWave As Boolean
    
    Dim H As Single
    Dim d As Single
    
    Dim dx As Long
    Dim dy As Long
    
    MinOneWave = False
    
    'Verarbeitung der WaveProperties
    For k = iBegin To iEnd
        With iWave(k)

            If .c > 0 Then
                .c = .c - .cAttenuation * g_App.AVFGS
            Else
                .c = 0
            End If
            .RAD = .RAD - .c * g_App.AVFGS
        
            If .Amplitude > 0 Then
                .Amplitude = .Amplitude - .AmpAttenuation * g_App.AVFGS
            Else
                .Amplitude = 0
                .Draw = False
            End If
        
            .SrcX = .X \ ELEMENT_WIDTH
            .SrcY = .Y \ ELEMENT_HEIGHT
            
            dx = (g_App.ResX / 2) / ELEMENT_WIDTH
            dy = (g_App.ResY / 2) / ELEMENT_HEIGHT
            
            If RadiusCollision(.X \ ELEMENT_WIDTH, .Y \ ELEMENT_HEIGHT, -(.RAD), dx, dy, ScreenRadius) And _
               Not CircleInCircle(.X \ ELEMENT_WIDTH, .Y \ ELEMENT_HEIGHT, -(.RAD + .WaveCount * .WaveLength * TPI), dx, dy, ScreenRadius) Then
                .Draw = True
            Else
                .Draw = False
            End If
            
            If .Draw Then MinOneWave = True

        End With
    Next k
    
    If MinOneWave Then              'wenn mindestens eine gezeichnet werden muss
    
        'Höhen werden errechnet
        For n = 1 To HNET_ELEMENTS
            For m = 1 To VNET_ELEMENTS
                    
                WaveNetV(n, m).Height = 0
                
                For k = iBegin To iEnd
                    With iWave(k)
                        If .Draw Then
                    
                            H = .Amplitude
                            d = (Pyth(.SrcX - n, .SrcY - m) + .RAD) / .WaveLength
                            
                            If d > 0 Then H = 0
                            
                            If d < -.MaxRad Then H = 0
                            
                            If H Then
                            
                                WaveNetV(n, m).Height = WaveNetV(n, m).Height + Cos(d) * H - H
                                    
                            End If
                            
                        End If
                    End With
                Next k
                    
            Next m
        Next n
        
        'Vertices werden Angeglichen
        Dim n1 As Long
        Dim m1 As Long
        Dim tmph As Single
        For n = 1 To HNET_ELEMENTS
            For m = 1 To VNET_ELEMENTS
                With WaveNetV(n, m)
                    
                        n1 = n + 1
                        m1 = m + 1
                        
                        If n1 > HNET_ELEMENTS Then n1 = n
                        If m1 > VNET_ELEMENTS Then m1 = m
                    
                        .Vertex(1).Z = .Height
                        .Vertex(2).Z = WaveNetV(n1, m).Height
                        .Vertex(3).Z = WaveNetV(n, m1).Height
                        .Vertex(4).Z = WaveNetV(n1, m1).Height
                        
                            
                        tmph = 0
                        tmph = .Vertex(1).Z + .Vertex(2).Z + .Vertex(3).Z + .Vertex(4).Z
                        
                        If tmph Then
                            .Draw = True
                        Else
                            .Draw = False
                        End If
                        
                
                End With
            Next m
        Next n

    End If
    
End Sub

Private Sub RefreshWaveTextures()
    Dim n As Long
    Dim m As Long
    Dim tmpRect As RECT
    
    For n = 0 To HT_ELEMENTS - 1
        For m = 0 To VT_ELEMENTS - 1
            tmpRect.Left = n * TEXTURE_WIDTH
            tmpRect.Top = m * TEXTURE_HEIGHT
            tmpRect.Right = (n + 1) * TEXTURE_WIDTH
            tmpRect.Bottom = (m + 1) * TEXTURE_HEIGHT
            
            If tmpRect.Right > g_App.ResX Then tmpRect.Right = g_App.ResX
            If tmpRect.Bottom > g_App.ResY Then tmpRect.Bottom = g_App.ResY
        
            WaveNetT(n + 1, m + 1).BltFast 0, 0, g_BackBuf, tmpRect, DDBLTFAST_WAIT
        Next m
    Next n
    
End Sub

Public Function AreWavesVisible(ByRef iWave() As T3DWave, ByRef iBegin As Long, ByRef iEnd As Long) As Boolean
    Dim k As Long
    
    AreWavesVisible = False
    
    For k = iBegin To iEnd
        With iWave(k)
            
            If .Draw Then
                AreWavesVisible = True
                Exit For
            End If
            
        End With
    Next k

End Function


'Radius Kollision
Private Function RadiusCollision(ByRef MidX1 As Long, ByRef MidY1 As Long, ByRef r1 As Single, ByRef MidX2 As Long, ByRef MidY2 As Long, ByRef r2 As Single) As Boolean
    
    Dim a As Long
    Dim b As Long
    
    a = MidX2 - MidX1
    b = MidY2 - MidY1
    RadiusCollision = (Sqr(a * a + b * b) <= r1 + r2)
        
End Function

'Test ob Kreis in Kreis ist
Private Function CircleInCircle(ByRef MidX1 As Long, ByRef MidY1 As Long, ByRef r1 As Single, ByRef MidX2 As Long, ByRef MidY2 As Long, ByRef r2 As Single) As Boolean
    
    Dim a As Long
    Dim b As Long
    
    a = MidX2 - MidX1
    b = MidY2 - MidY1
    
    
    CircleInCircle = (r2 <= r1)
    
    If CircleInCircle Then CircleInCircle = (Sqr(a * a + b * b) + r2 < r1)
    
        
End Function

'#########################################################################################################
'#########################################################################################################
'#########################################################################################################
'MotionBlur

Public Sub InitBlurNet(ByRef Tex256x256 As String)
    Dim n As Long
    Dim m As Long
    Dim ddsd3 As DDSURFACEDESC2
    Dim TextureEnum As Direct3DEnumPixelFormats
    Dim dx As Long
    Dim dy As Long
    Dim tu1 As Single
    Dim tu2 As Single
    Dim tv1 As Single
    Dim tv2 As Single

    'Texturen erstellen (laden)
    Set TextureEnum = g_D3DDev.GetTextureFormatsEnum()
    TextureEnum.GetItem 1, ddsd3.ddpfPixelFormat
    ddsd3.ddsCaps.lCaps = DDSCAPS_TEXTURE

    For n = 1 To HT_ELEMENTS
       For m = 1 To VT_ELEMENTS
    
            Set BlurNetT(n, m) = g_DD.CreateSurfaceFromFile(Tex256x256, ddsd3)
    
        Next m
    Next n
    
    'Texturkoordinaten einstellen
    dx = TEXTURE_WIDTH / ELEMENT_WIDTH
    dy = TEXTURE_HEIGHT / ELEMENT_HEIGHT
    
    For n = 0 To HNET_ELEMENTS - 1
        For m = 0 To VNET_ELEMENTS - 1
            
            tu1 = (n Mod dx) / dx
            tv1 = (m Mod dy) / dy
            tu2 = (n Mod dx + 1) / dx
            tv2 = (m Mod dy + 1) / dy
    
            With BlurNetV(n + 1, m + 1)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu1, tv1, .Vertex(1)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu2, tv1, .Vertex(2)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu1, tv2, .Vertex(3)
                g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, tu2, tv2, .Vertex(4)
            End With
            
        Next m
        
    Next n
    
    'Vertices als Netz aufbauen
    Dim hf As Single
    Dim vf As Single
    
    Dim realHNET_ELEMENTS As Single
    Dim realVNET_ELEMENTS As Single
    
    hf = ELEMENT_WIDTH / g_D3DDivX
    vf = (ELEMENT_HEIGHT) / g_D3DDivY
    
    realHNET_ELEMENTS = g_App.ResX / ELEMENT_WIDTH
    realVNET_ELEMENTS = g_App.ResY / ELEMENT_HEIGHT
    
    For n = 1 To HNET_ELEMENTS
        For m = 1 To VNET_ELEMENTS
            With BlurNetV(n, m)
            
                .Vertex(1).X = (n - 1 - realHNET_ELEMENTS / 2) * hf
                .Vertex(1).Y = (-m + 1 + realVNET_ELEMENTS / 2) * vf
    
                .Vertex(2).X = (n - realHNET_ELEMENTS / 2) * hf
                .Vertex(2).Y = (-m + 1 + realVNET_ELEMENTS / 2) * vf
    
                .Vertex(3).X = (n - 1 - realHNET_ELEMENTS / 2) * hf
                .Vertex(3).Y = (-m + realVNET_ELEMENTS / 2) * vf
    
                .Vertex(4).X = (n - realHNET_ELEMENTS / 2) * hf
                .Vertex(4).Y = (-m + realVNET_ELEMENTS / 2) * vf
                                
            End With
        Next m
    Next n
    
End Sub


Public Sub DrawBlurNet(ByRef BlurFactor As Single)
    Dim n As Long
    Dim m As Long
    Dim Material As D3DMATERIAL7
    Dim dx As Long
    Dim dy As Long
    
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, 1
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, 1
        
    dx = TEXTURE_WIDTH / ELEMENT_WIDTH
    dy = TEXTURE_HEIGHT / ELEMENT_HEIGHT
    
    g_D3DDev.BeginScene
        
        SetAlpha 1, A_ADD, True

        SetMaterialE BlurFactor, BlurFactor, BlurFactor
        
        For n = 1 To HNET_ELEMENTS
            For m = 1 To VNET_ELEMENTS
                
                    g_D3DDev.SetTexture 0, BlurNetT((n - 1) \ dx + 1, (m - 1) \ dy + 1)
                
                    g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, BlurNetV(n, m).Vertex(1), 4, D3DDP_DEFAULT
                    
            Next m
        Next n
        
    g_D3DDev.EndScene

End Sub

Public Sub RefreshBlurTextures()
    Dim n As Long
    Dim m As Long
    Dim tmpRect As RECT
    
    For n = 0 To HT_ELEMENTS - 1
        For m = 0 To VT_ELEMENTS - 1
            tmpRect.Left = n * TEXTURE_WIDTH
            tmpRect.Top = m * TEXTURE_HEIGHT
            tmpRect.Right = (n + 1) * TEXTURE_WIDTH
            tmpRect.Bottom = (m + 1) * TEXTURE_HEIGHT
            
            If tmpRect.Right > g_App.ResX Then tmpRect.Right = g_App.ResX
            If tmpRect.Bottom > g_App.ResY Then tmpRect.Bottom = g_App.ResY
        
            BlurNetT(n + 1, m + 1).BltFast 0, 0, g_BackBuf, tmpRect, DDBLTFAST_WAIT
            
        Next m
    Next n
    
End Sub


