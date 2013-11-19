Attribute VB_Name = "mnu_m07_3DMenu"
Option Explicit


'=== SubMenu ============================================================
Public Sub subDrawSubMenu()
    
    Material.emissive.R = 0
    Material.emissive.G = 0.1
    Material.emissive.B = 0.2
    Material.emissive.a = 0.1
    
    g_D3DDev.SetMaterial Material
    
    With g_D3DDev
    
        .BeginScene
        
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, True
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, SubMenu.Vertex(0), 9, D3DDP_WAIT
            
        .EndScene
    
    End With
    
    With SubMenu
    
        If .PosX < -0.499 Then
            BackBuffer.DrawLine .DDLine(0, 0), .DDLine(0, 1), .DDLine(1, 0), .DDLine(1, 1)
            BackBuffer.DrawLine .DDLine(1, 0), .DDLine(1, 1), .DDLine(2, 0), .DDLine(2, 1)
            BackBuffer.DrawLine .DDLine(2, 0), .DDLine(2, 1), .DDLine(3, 0), .DDLine(3, 1)
            '===============================================================================================
            If MainMenu.MenuStatus = SingleM Then subDrawSingleplayerMenu
            If MainMenu.MenuStatus = Multi Then subDrawMultiplayerMenu
            If MainMenu.MenuStatus = Options Then subDrawOptionsMenu
            '===============================================================================================
        End If
    End With
    
End Sub
'========================================================================

'=== 3D-Menu ============================================================
Public Sub subDraw3DMenu()
    Dim n As Long
    Dim m As Long

    '=== Mauslicht im Menu =============
    MainMenu.Light.position = Vector(MouseX / 29 - 19, -MouseY / 23 + 18, -20)
    g_D3DDev.SetLight 5, MainMenu.Light
    g_D3DDev.LightEnable 5, True
    '===================================

    'Löschen des       "3DBuffers"   , WICHTIG für Zbuffer, alles löschen , Farbe mit der gelöscht werden soll
    g_D3DDev.Clear 1, RectViewport(), D3DCLEAR_ZBUFFER Or D3DCLEAR_TARGET, RGB(0, 0, 0), 1, 0
    
    
    '=== Sterne werden in den ZuZeichnenSpeicher geladen =================================
    With MainMenuBackStars
            
            BackBuffer.Lock EmptyRect, EmptyStr, DDLOCK_WRITEONLY, 0
            For n = 0 To MAX_MENU_BACKSTARS
                For m = 0 To 2
                    BackBuffer.SetLockedPixel .RX(m, n), .RY(m, n), .Color(m)
                Next
            Next
            BackBuffer.Unlock EmptyRect
        
    End With
    '=====================================================================================
    
    If MainMenu.FadeFromBlack < 1 Then
        MainMenu.FadeFromBlack = MainMenu.FadeFromBlack + 0.005 * ConstSpeed
        subDrawEffect MainMenu.FadeFromBlack, 8, 3
    End If
    
    Material.specular.R = 0
    Material.specular.G = 0
    Material.specular.B = 0
    Material.specular.a = 0
    
    Material.diffuse.R = 0
    Material.diffuse.G = 0
    Material.diffuse.B = 0
    Material.diffuse.a = 0
    
    Material.emissive.R = 0
    Material.emissive.G = 0
    Material.emissive.B = 0
    Material.emissive.a = 0
    
    g_D3DDev.SetMaterial Material
        
    Call g_DX.ViewMatrix(matView, Vector(0, 0, MainMenu.CamZ), Vector(0, 0, 0), Vector(0, 1, 0), 0)
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
    
    With g_D3DDev
        .BeginScene
    
            '=== GTR im Kreis Rendern ==================
            .SetTexture 0, Nothing
            .SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
            .SetRenderState D3DRENDERSTATE_ZENABLE, 0
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, GTR3D.Vertex(0), GTR3D.VertexCount + 12, D3DDP_WAIT
            .LightEnable 5, False
            '===========================================
            
            '=== 5 Sterne Rendern ======================
            .SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1
            .SetTexture 0, Menu3DStarTex
            For n = 0 To 4
                .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Menu3DStar(n).Vertex(0), 6, D3DDP_WAIT
            Next
            .SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 0
            .SetTexture 0, Nothing
            '===========================================
            
        .EndScene
    End With
End Sub
'=========================================================================

'=== MausSterne ==========================================================
Public Sub subDrawMenuMouseStars()
    Dim n As Long

    g_D3DDev.BeginScene
        g_D3DDev.SetTexture 0, MenuMouseStarTex
        g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1
        g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 0

        For n = 1 To MAX_MENU_MOUSEPARTICLES
            Material.emissive.R = (100 - MenuMouseParticle(n).Age / 10) / 100
            Material.emissive.G = (50 - MenuMouseParticle(n).Age / 10) / 100
            Material.emissive.B = (0 - MenuMouseParticle(n).Age / 10) / 100
            'Material.emissive.a = (100 - MenuMouseParticle(n).Age / 10) / 100

            g_D3DDev.SetMaterial Material

            g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, MenuMouseParticle(n).Vertex(1), 4, D3DDP_DEFAULT
        Next
        
        g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 2
        Material.emissive.R = 0
        Material.emissive.G = 0
        Material.emissive.B = 0
        Material.emissive.a = 0
        g_D3DDev.SetMaterial Material
        
        g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, False
        g_D3DDev.SetTexture 0, Nothing
        
    g_D3DDev.EndScene
End Sub
'=========================================================================


Public Sub DrawFade(X1, Y1, X2, Y2, Count)
    Dim Vertex(5) As D3DVERTEX
    
    Vertex(0).X = X1 / D3DDivX + D3DSubX: Vertex(0).Y = -Y1 / D3DDivY + D3DSubY: Vertex(0).Z = 0
    Vertex(1).X = X2 / D3DDivX + D3DSubX: Vertex(1).Y = -Y1 / D3DDivY + D3DSubY: Vertex(1).Z = 0
    Vertex(2).X = X1 / D3DDivX + D3DSubX: Vertex(2).Y = -Y2 / D3DDivY + D3DSubY: Vertex(2).Z = 0
    Vertex(3).X = X2 / D3DDivX + D3DSubX: Vertex(3).Y = -Y2 / D3DDivY + D3DSubY: Vertex(3).Z = 0
    Vertex(4).X = X2 / D3DDivX + D3DSubX: Vertex(4).Y = -Y1 / D3DDivY + D3DSubY: Vertex(4).Z = 0
    Vertex(5).X = X1 / D3DDivX + D3DSubX: Vertex(5).Y = -Y2 / D3DDivY + D3DSubY: Vertex(5).Z = 0
    
    Material.emissive.R = Count
    Material.emissive.G = Count
    Material.emissive.B = Count
    Material.emissive.a = Count
    
    g_D3DDev.SetMaterial Material
    
    g_D3DDev.BeginScene
    
            g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 0
            g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, True
            g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Vertex(0), 6, D3DDP_WAIT
            g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, False
            g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 2
    
    g_D3DDev.EndScene
    
    Material.emissive.R = 0
    Material.emissive.G = 0
    Material.emissive.B = 0
    Material.emissive.a = 0
    
    g_D3DDev.SetMaterial Material

End Sub

