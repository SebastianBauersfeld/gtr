Attribute VB_Name = "m_Shared3D_01"
Option Explicit

Public Sub subInit3DFontProps()
    Dim File As Integer
    Dim TMP As String
    Dim Pos As Long
    Dim Pos2 As Long

    Dim n As Long

    File = FreeFile

    Open FontPath & "3D.fnt" For Input As #File

        With D3DFont

            For n = 32 To 255

                Input #File, TMP

                TMP = TMP & " "

                'LEFT
                Pos = InStr(1, TMP, "X", vbBinaryCompare)

                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop

                .Letter(n).Left = Mid(TMP, Pos + 2, Pos2 - Pos - 2)

                'TOP
                Pos = InStr(1, TMP, "Y", vbBinaryCompare)

                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop

                .Letter(n).Top = Mid(TMP, Pos + 2, Pos2 - Pos - 2)

                'RIGHT
                Pos = InStr(1, TMP, "W", vbBinaryCompare)

                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop

                .Letter(n).Right = Mid(TMP, Pos + 2, Pos2 - Pos - 2) + .Letter(n).Left

                'BOTTOM
                Pos = InStr(1, TMP, "H", vbBinaryCompare)

                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop

                .Letter(n).Bottom = Mid(TMP, Pos + 2, Pos2 - Pos - 2) + .Letter(n).Top

            Next n

        End With

    Close #File

End Sub


Public Sub subDraw3DText(ByVal X As Single, ByVal Y As Single, ByVal Text As String, R As Single, G As Single, B As Single, Size As Long, Dull As Single)
    Dim n                       As Long
    Dim TMPX                    As Single
    Dim TMPY                    As Single
    Dim TmpRect                 As RECT
    Dim Vertex(1 To 4)          As D3DVERTEX


    Call g_DX.ViewMatrix(matView, Vector(0, 1000, -Size), Vector(0, 1000, 0), Vector(0, 1, 0), 0)
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView

    g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 0

    g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
    g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 2

    g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1

    Material.diffuse.R = 0
    Material.diffuse.G = 0
    Material.diffuse.B = 0

    Material.emissive.R = R * Dull
    Material.emissive.G = G * Dull
    Material.emissive.B = B * Dull
    g_D3DDev.SetMaterial Material

    g_D3DDev.SetTexture 0, FontTex

    TMPX = X

    For n = 1 To Len(Text)
        TMPY = Y

        If Asc(Mid(Text, n, 1)) >= 32 Then

            TmpRect = D3DFont.Letter(Asc(Mid(Text, n, 1)))

            With TmpRect

                g_DX.CreateD3DVertex TMPX, TMPY + 500, 0, 0, 0, -1, .Left / 256, .Top / 256, Vertex(1)
                g_DX.CreateD3DVertex TMPX + .Right - .Left, TMPY + 500, 0, 0, 0, -1, .Right / 256, .Top / 256, Vertex(2)
                g_DX.CreateD3DVertex TMPX, (TMPY - (.Bottom - .Top) * 1.3) + 500, 0, 0, 0, -1, .Left / 256, .Bottom / 256, Vertex(3)
                g_DX.CreateD3DVertex TMPX + .Right - .Left, (TMPY - (.Bottom - .Top) * 1.3) + 500, 0, 0, 0, -1, .Right / 256, .Bottom / 256, Vertex(4)

                g_D3DDev.BeginScene

                    g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, Vertex(1), 4, D3DDP_DEFAULT

                g_D3DDev.EndScene

                TMPX = TMPX + .Right - .Left
            End With
        End If
    Next n

End Sub




Public Sub subDrawEffect(Dull As Single, Src As Byte, Dest As Byte)
    Dim n As Long

    With g_D3DDev
        Call g_DX.ProjectionMatrix(matProj, 0.1, 5000, PI / 3)
        g_D3DDev.SetTransform D3DTRANSFORMSTATE_PROJECTION, matProj
    
        g_DX.ViewMatrix matView, Vector(0, 0, -1), Vector(0, 0, 0), Vector(0, 1, 0), 0
        .SetTransform D3DTRANSFORMSTATE_VIEW, matView
    
        .BeginScene
        
            .SetRenderState D3DRENDERSTATE_ZENABLE, 0
            
            For n = 0 To 7
                .LightEnable n, False
            Next
            
            .SetTexture 0, Nothing
            
            Material.emissive.a = Dull
            Material.emissive.R = Dull
            Material.emissive.G = Dull
            Material.emissive.B = Dull
            .SetMaterial Material
        
            .SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1
            .SetRenderState D3DRENDERSTATE_SRCBLEND, Src
            .SetRenderState D3DRENDERSTATE_DESTBLEND, Dest
            
            .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, FadeVertex(1), 4, D3DDP_WAIT
            
            For n = 0 To 7
                .LightEnable n, True
            Next

    
        .EndScene
    End With
    
    
End Sub
