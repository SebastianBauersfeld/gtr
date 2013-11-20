Attribute VB_Name = "otr_06_Ship"
Option Explicit

Public Sub subLoadCreditsShipFromFile()
    Dim File As Integer
    Dim n As Long

    File = FreeFile

    Open FontPath & "ship.vtx" For Binary As #File
        For n = 1 To MAX_SHIP_VERTICES
            With Credits3DShipVertex(n)
                Get #File, , .X
                Get #File, , .Y
                Get #File, , .Z
                Get #File, , .tu
                Get #File, , .tv
            End With
        Next
    Close #File

    Credits3DShip.X = 199.5
    Credits3DShip.Y = 0.6
    Credits3DShip.Z = -401.1

End Sub

Public Sub subAnimateCreditsShip()
    Dim n As Long
    
'    For n = 991 To 1291
'        Credits3DShipVertex(n).tv = Credits3DShipVertex(n).tv + 0.002 * ConstSpeed
'        Credits3DShipVertex(n).tu = Credits3DShipVertex(n).tu + 0.002 * ConstSpeed
'    Next
    
    Credits3DShip.Z = Credits3DShip.Z + 0.03 * ConstSpeed
    
    For n = 1 To 1291
        Credits3DShipVertex(n).Z = Credits3DShipVertex(n).Z + 0.03 * ConstSpeed
    Next
    Credits3DShipLight.position.Z = Credits3DShipLight.position.Z + 0.03 * ConstSpeed
    
    Credits3DShipImpLight.position.Z = Credits3DShipLight.position.Z - 11
    
    Credits3DShipImpLight.attenuation1 = Rnd * 2
    
    Credits3DShipRedLight.position.Z = Credits3DShipLight.position.Z - 8.5
    
    Credits3DShipRedLightVertex(1).Z = Credits3DShipRedLight.position.Z
    Credits3DShipRedLightVertex(2).Z = Credits3DShipRedLight.position.Z
    Credits3DShipRedLightVertex(3).Z = Credits3DShipRedLight.position.Z
    Credits3DShipRedLightVertex(4).Z = Credits3DShipRedLight.position.Z
    
    LightTime = LightTime + ConstSpeed
    
    subAnimateShipImp
    
End Sub


Public Sub subDrawCreditsShip()

    If CamZ >= Credits3DShip.Z Then
        subDrawShipImpulse
    End If

    With g_D3DDev
        .BeginScene
        
            .LightEnable 0, False
        
            .SetRenderState D3DRENDERSTATE_ZENABLE, 2
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 1
        
            .SetLight 1, Credits3DShipLight
            .SetLight 2, Credits3DShipImpLight
            .SetLight 3, Credits3DShipRedLight
            .LightEnable 1, True
            .LightEnable 2, True
            If LightTime > 100 Then
                .LightEnable 3, True
                If LightTime > 200 Then LightTime = 0
            Else
                .LightEnable 3, False
            End If
                
        
            'Hinteres Dach
            .SetTexture 0, Credits3DShip.Tex(1)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(1), 60, D3DDP_WAIT
            
            'Hinteres Gondelteile
            .SetTexture 0, Credits3DShip.Tex(2)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(61), 120, D3DDP_WAIT
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(250), 120, D3DDP_WAIT
            
            .SetTexture 0, Nothing         'innerer Abschluss
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(181), 6, D3DDP_WAIT
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(370), 6, D3DDP_WAIT
            
            'Vordere Gondelteile
            .SetTexture 0, Credits3DShip.Tex(3)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(187), 60, D3DDP_WAIT
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(376), 60, D3DDP_WAIT
            
            .SetTexture 0, Credits3DShip.Tex(4)         'innerer Abschluss
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(247), 3, D3DDP_WAIT
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(436), 3, D3DDP_WAIT
            
            'Antrieb
            .SetTexture 0, Credits3DShip.Tex(5)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(439), 240, D3DDP_WAIT
            .SetTexture 0, Credits3DShip.Tex(6)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(679), 6, D3DDP_WAIT
            .SetTexture 0, Nothing
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(685), 120, D3DDP_WAIT
            
            'Oberer Boden
            .SetTexture 0, Credits3DShip.Tex(7)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(805), 6, D3DDP_WAIT
            
            '=== Hohlspitze
                'unterer Boden
            .SetTexture 0, Credits3DShip.Tex(8)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(811), 60, D3DDP_WAIT
                'Vordere Wand
            .SetTexture 0, Credits3DShip.Tex(9)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(871), 60, D3DDP_WAIT
                'oberer Boden
            .SetTexture 0, Credits3DShip.Tex(10)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(931), 60, D3DDP_WAIT
            '=============
            
            'Cockpit
            .SetTexture 0, Credits3DShip.Tex(11)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Credits3DShipVertex(991), 1291, D3DDP_WAIT
            
           
            If LightTime > 100 Then
                .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
                .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
                
                    Material.emissive.R = 1
                    Material.emissive.G = 0
                    Material.emissive.B = 0
                    g_D3DDev.SetMaterial Material
                
                .SetTexture 0, LightTex
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, Credits3DShipRedLightVertex(1), 4, D3DDP_WAIT
            End If
            
        .EndScene
    End With
    
    If CamZ < Credits3DShip.Z Then
        subDrawShipImpulse
    End If
    
End Sub

Public Sub GenerateImpElement(Count As Long)
    Dim RAD As Single
    
    RAD = Rnd * PI * 2
    
    With ImpElement(Count)
        .MX = Rnd * 0.01
        
        .X = Credits3DShip.X + Cos(RAD) / 5
        .Y = Credits3DShip.Y + Sin(RAD) / 5
        .Z = Credits3DShip.Z
    
        .Age = 0
    End With

End Sub


Public Sub subAnimateShipImp()
    Dim n As Long
    
    If ImpElementCounter + 5 * ConstSpeed > MAX_IMP_ELEMENTS Then ImpElementCounter = 5 * ConstSpeed
    
    For n = ImpElementCounter To ImpElementCounter + 5 * ConstSpeed
        GenerateImpElement n
    Next
    
    ImpElementCounter = ImpElementCounter + 5 * ConstSpeed
    
    Dim RAD1 As Single
    Dim RAD2 As Single
    
    For n = 1 To MAX_IMP_ELEMENTS
        With ImpElement(n)
        
            If Int(Rnd * 2) = 1 Then
                RAD1 = -ImpElementRadius
                RAD2 = 0
            Else
                RAD1 = 0
                RAD2 = -ImpElementRadius
            End If
            
            .Z = .Z - .MX * ConstSpeed
            
            .Vertex(1).X = .X
            .Vertex(1).Y = .Y
            
            .Vertex(2).X = .X + ImpElementRadius
            .Vertex(2).Y = .Y
            
            .Vertex(3).X = .X
            .Vertex(3).Y = .Y - ImpElementRadius
            
            .Vertex(4).X = .X + ImpElementRadius
            .Vertex(4).Y = .Y - ImpElementRadius
            
            .Vertex(1).Z = .Z + RAD1
            .Vertex(2).Z = .Z + RAD2
            .Vertex(3).Z = .Z + RAD1
            .Vertex(4).Z = .Z + RAD2
            
            .Age = .Age + ConstSpeed
            
        End With
    Next

End Sub


Public Sub subDrawShipImpulse()
    Dim n As Long

    '=== Impulse ===============================================================================
    With g_D3DDev
        .LightEnable 0, False
        .LightEnable 1, False
        .LightEnable 2, False
        .LightEnable 3, False
        
        .SetRenderState D3DRENDERSTATE_ZENABLE, 0
        .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
        .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
        
        .BeginScene
               
            .SetTexture 0, SunElementTex
            
            For n = 1 To MAX_IMP_ELEMENTS
            
                Material.emissive.R = (75 - ImpElement(n).Age) / 100
                Material.emissive.G = (50 - ImpElement(n).Age) / 100
                Material.emissive.B = (20 - ImpElement(n).Age) / 100
                .SetMaterial Material
        
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, ImpElement(n).Vertex(1), 4, D3DDP_DEFAULT
            Next
           
        .EndScene
    End With
    '===========================================================================================
    
    Material.emissive.R = 0
    Material.emissive.G = 0
    Material.emissive.B = 0
    g_D3DDev.SetMaterial Material
    
End Sub
    



