Attribute VB_Name = "mnu_m14_3DCharacters"
Option Explicit


Public Sub CreatePoly(WP As Integer, P1X As Single, P1Y As Single, P1Z As Single, P2X As Single, P2Y As Single, P2Z As Single, P3X As Single, P3Y As Single, P3Z As Single, P4X As Single, P4Y As Single, P4Z As Single, STRX As Single, STRY As Single, STRZ As Single, PosY As Single, PosX As Single, PosZ As Single)
    
    CreateTriangle WP, P1X, P1Y, P1Z, P2X, P2Y, P2Z, P3X, P3Y, P3Z, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WP, P2X, P2Y, P2Z, P4X, P4Y, P4Z, P3X, P3Y, P3Z, STRX, STRY, STRZ, PosY, PosX, PosZ

End Sub


Public Sub CreateTriangle(WP As Integer, P1X As Single, P1Y As Single, P1Z As Single, P2X As Single, P2Y As Single, P2Z As Single, P3X As Single, P3Y As Single, P3Z As Single, STRX As Single, STRY As Single, STRZ As Single, PosY As Single, PosX As Single, PosZ As Single)
    
    GTR3D.Vertex(WP).X = (P1X + PosX) * STRX
    GTR3D.Vertex(WP).Y = (P1Y + PosY) * STRY
    GTR3D.Vertex(WP).Z = (P1Z + PosZ) * STRZ
    GTR3D.Vertex(WP + 1).X = (P2X + PosX) * STRX
    GTR3D.Vertex(WP + 1).Y = (P2Y + PosY) * STRY
    GTR3D.Vertex(WP + 1).Z = (P2Z + PosZ) * STRZ
    GTR3D.Vertex(WP + 2).X = (P3X + PosX) * STRX
    GTR3D.Vertex(WP + 2).Y = (P3Y + PosY) * STRY
    GTR3D.Vertex(WP + 2).Z = (P3Z + PosZ) * STRZ
    
    WP = WP + 3
End Sub

Public Sub CHAR_G(WV As Integer, STRX As Single, STRY As Single, STRZ As Single, PosY As Single, PosX As Single, PosZ As Single)

    'Vorderes Surface
    CreatePoly WV, 1.66, 1, 0, 2.33, 1, 0, 1.25, 0, 0, 2.75, 0, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.66, 1, 0, 1.25, 0, 0, 1.25, 1.05, 0, 0.9, 0.05, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.25, 1.05, 0, 0.9, 0.05, 0, 1.1, 1.1, 0, 0.33, 0.2, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.1, 1.1, 0, 0.33, 0.2, 0, 1.03, 1.3, 0, 0.1, 0.6, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.03, 1.3, 0, 0.1, 0.6, 0, 1, 1.55, 0, 0, 1.3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 1.55, 0, 0, 1.3, 0, 1, 3.4, 0, 0, 3.7, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.33, 1, 0, 2.75, 0, 0, 2.75, 1.07, 0, 3.1, 0.03, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.75, 1.07, 0, 3.1, 0.03, 0, 2.9, 1.15, 0, 3.6, 0.2, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.9, 1.15, 0, 3.6, 0.2, 0, 2.95, 1.3, 0, 3.9, 0.5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.95, 1.3, 0, 3.9, 0.5, 0, 3, 1.6, 0, 4, 1.3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 1.6, 0, 4, 1.3, 0, 3, 2, 0, 4, 2.4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 2, 0, 4, 2.4, 0, 3.95, 2.7, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 2, 0, 3.95, 2.7, 0, 3.7, 2.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 2, 0, 3.7, 2.93, 0, 3.45, 3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 2, 0, 3.45, 3, 0, 2, 2, 0, 2, 3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 3.4, 0, 0, 3.7, 0, 1.07, 3.75, 0, 0.15, 4.5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.07, 3.75, 0, 0.15, 4.5, 0, 1.2, 3.9, 0, 0.4, 4.8, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.2, 3.9, 0, 0.4, 4.8, 0, 1.45, 3.99, 0, 0.7, 4.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.45, 3.99, 0, 0.7, 4.93, 0, 1.55, 4, 0, 1.3, 5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.55, 4, 0, 1.3, 5, 0, 3, 4, 0, 3.45, 5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 3.45, 5, 0, 3.75, 4.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 3.75, 4.93, 0, 3.95, 4.65, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 3.95, 4.65, 0, 4, 4.4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 4, 4.4, 0, 4, 4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Hinteres Surface
    CreatePoly WV, 1.66, 1, 1, 2.33, 1, 1, 1.25, 0, 1, 2.75, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.66, 1, 1, 1.25, 0, 1, 1.25, 1.05, 1, 0.9, 0.05, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.25, 1.05, 1, 0.9, 0.05, 1, 1.1, 1.1, 1, 0.33, 0.2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.1, 1.1, 1, 0.33, 0.2, 1, 1.03, 1.3, 1, 0.1, 0.6, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.03, 1.3, 1, 0.1, 0.6, 1, 1, 1.55, 1, 0, 1.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 1.55, 1, 0, 1.3, 1, 1, 3.4, 1, 0, 3.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.33, 1, 1, 2.75, 0, 1, 2.75, 1.07, 1, 3.1, 0.03, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.75, 1.07, 1, 3.1, 0.03, 1, 2.9, 1.15, 1, 3.6, 0.2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.9, 1.15, 1, 3.6, 0.2, 1, 2.95, 1.3, 1, 3.9, 0.5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.95, 1.3, 1, 3.9, 0.5, 1, 3, 1.6, 1, 4, 1.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 1.6, 1, 4, 1.3, 1, 3, 2, 1, 4, 2.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 2, 1, 4, 2.4, 1, 3.95, 2.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 2, 1, 3.95, 2.7, 1, 3.7, 2.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 2, 1, 3.7, 2.93, 1, 3.45, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 2, 1, 3.45, 3, 1, 2, 2, 1, 2, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 3.4, 1, 0, 3.7, 1, 1.07, 3.75, 1, 0.15, 4.5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.07, 3.75, 1, 0.15, 4.5, 1, 1.2, 3.9, 1, 0.4, 4.8, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.2, 3.9, 1, 0.4, 4.8, 1, 1.45, 3.99, 1, 0.7, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.45, 3.99, 1, 0.7, 4.93, 1, 1.55, 4, 1, 1.3, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.55, 4, 1, 1.3, 5, 1, 3, 4, 1, 3.45, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 3.45, 5, 1, 3.75, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 3.75, 4.93, 1, 3.95, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 3.95, 4.65, 1, 4, 4.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 4, 4.4, 1, 4, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Z-Surfaces
    CreatePoly WV, 1.66, 1, 0, 2.33, 1, 0, 1.66, 1, 1, 2.33, 1, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.25, 0, 0, 2.75, 0, 0, 1.25, 0, 1, 2.75, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.66, 1, 0, 1.25, 1.05, 0, 1.66, 1, 1, 1.25, 1.05, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.25, 0, 0, 0.9, 0.05, 0, 1.25, 0, 1, 0.9, 0.05, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.25, 1.05, 0, 1.1, 1.1, 0, 1.25, 1.05, 1, 1.1, 1.1, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.9, 0.05, 0, 0.33, 0.2, 0, 0.9, 0.05, 1, 0.33, 0.2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.1, 1.1, 0, 1.03, 1.3, 0, 1.1, 1.1, 1, 1.03, 1.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.33, 0.2, 0, 0.1, 0.6, 0, 0.33, 0.2, 1, 0.1, 0.6, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.03, 1.3, 0, 1, 1.55, 0, 1.03, 1.3, 1, 1, 1.55, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.1, 0.6, 0, 0, 1.3, 0, 0.1, 0.6, 1, 0, 1.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 1.55, 0, 1, 3.4, 0, 1, 1.55, 1, 1, 3.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 1.3, 0, 0, 3.7, 0, 0, 1.3, 1, 0, 3.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.33, 1, 0, 2.75, 1.07, 0, 2.33, 1, 1, 2.75, 1.07, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.75, 0, 0, 3.1, 0.03, 0, 2.75, 0, 1, 3.1, 0.03, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.75, 1.07, 0, 2.9, 1.15, 0, 2.75, 1.07, 1, 2.9, 1.15, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.1, 0.03, 0, 3.6, 0.2, 0, 3.1, 0.03, 1, 3.6, 0.2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.9, 1.15, 0, 2.95, 1.3, 0, 2.9, 1.15, 1, 2.95, 1.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.6, 0.2, 0, 3.9, 0.5, 0, 3.6, 0.2, 1, 3.9, 0.5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.95, 1.3, 0, 3, 1.6, 0, 2.95, 1.3, 1, 3, 1.6, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.9, 0.5, 0, 4, 1.3, 0, 3.9, 0.5, 1, 4, 1.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 1.6, 0, 3, 2, 0, 3, 1.6, 1, 3, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 1.3, 0, 4, 2.4, 0, 4, 1.3, 1, 4, 2.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 2.4, 0, 3.95, 2.7, 0, 4, 2.4, 1, 3.95, 2.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.95, 2.7, 0, 3.7, 2.93, 0, 3.95, 2.7, 1, 3.7, 2.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.7, 2.93, 0, 3.45, 3, 0, 3.7, 2.93, 1, 3.45, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 2, 0, 2, 2, 0, 3, 2, 1, 2, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2, 2, 0, 2, 3, 0, 2, 2, 1, 2, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.45, 3, 0, 2, 3, 0, 3.45, 3, 1, 2, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 3.4, 0, 1.07, 3.75, 0, 1, 3.4, 1, 1.07, 3.75, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 3.7, 0, 0.15, 4.5, 0, 0, 3.7, 1, 0.15, 4.5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.07, 3.75, 0, 1.2, 3.9, 0, 1.07, 3.75, 1, 1.2, 3.9, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.15, 4.5, 0, 0.4, 4.8, 0, 0.15, 4.5, 1, 0.4, 4.8, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.2, 3.9, 0, 1.45, 3.99, 0, 1.2, 3.9, 1, 1.45, 3.99, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.4, 4.8, 0, 0.7, 4.93, 0, 0.4, 4.8, 1, 0.7, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.45, 3.99, 0, 1.55, 4, 0, 1.45, 3.99, 1, 1.55, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.7, 4.93, 0, 1.3, 5, 0, 0.7, 4.93, 1, 1.3, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.55, 4, 0, 4, 4, 0, 1.55, 4, 1, 4, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.3, 5, 0, 3.45, 5, 0, 1.3, 5, 1, 3.45, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.45, 5, 0, 3.75, 4.93, 0, 3.45, 5, 1, 3.75, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.75, 4.93, 0, 3.95, 4.65, 0, 3.75, 4.93, 1, 3.95, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.95, 4.65, 0, 4, 4.4, 0, 3.95, 4.65, 1, 4, 4.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 4.4, 0, 4, 4, 0, 4, 4.4, 1, 4, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ

End Sub

Public Sub CHAR_T(WV As Integer, STRX As Single, STRY As Single, STRZ As Single, PosY As Single, PosX As Single, PosZ As Single)

    'Vorderes Surface
    CreatePoly WV, 1, 4, 0, 0.55, 5, 0, 3, 4, 0, 3.45, 5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 3.45, 5, 0, 3.75, 4.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 3.75, 4.93, 0, 3.95, 4.65, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 3.95, 4.65, 0, 4, 4.4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 0, 4, 4.4, 0, 4, 4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 0, 0.55, 5, 0, 0.25, 4.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 0, 0.25, 4.93, 0, 0.05, 4.65, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 0, 0.05, 4.65, 0, 0, 4.4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 0, 0, 4.4, 0, 0, 4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.5, 4, 0, 2.5, 4, 0, 1.5, 0, 0, 2.5, 0, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Hinteres Surface
    CreatePoly WV, 1, 4, 1, 0.55, 5, 1, 3, 4, 1, 3.45, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 3.45, 5, 1, 3.75, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 3.75, 4.93, 1, 3.95, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 3.95, 4.65, 1, 4, 4.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3, 4, 1, 4, 4.4, 1, 4, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 1, 0.55, 5, 1, 0.25, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 1, 0.25, 4.93, 1, 0.05, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 1, 0.05, 4.65, 1, 0, 4.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1, 4, 1, 0, 4.4, 1, 0, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.5, 4, 1, 2.5, 4, 1, 1.5, 0, 1, 2.5, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Z-Surfaces
    CreatePoly WV, 0.55, 5, 0, 3.45, 5, 0, 0.55, 5, 1, 3.45, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.45, 5, 0, 3.75, 4.93, 0, 3.45, 5, 1, 3.75, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.75, 4.93, 0, 3.95, 4.65, 0, 3.75, 4.93, 1, 3.95, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.95, 4.65, 0, 4, 4.4, 0, 3.95, 4.65, 1, 4, 4.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 4.4, 0, 4, 4, 0, 4, 4.4, 1, 4, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.55, 5, 0, 0.25, 4.93, 0, 0.55, 5, 1, 0.25, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.25, 4.93, 0, 0.05, 4.65, 0, 0.25, 4.93, 1, 0.05, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.05, 4.65, 0, 0, 4.4, 0, 0.05, 4.65, 1, 0, 4.4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 4.4, 0, 0, 4, 0, 0, 4.4, 1, 0, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.5, 4, 0, 2.5, 4, 1, 4, 4, 0, 4, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 4, 0, 0, 4, 1, 1.5, 4, 0, 1.5, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.5, 4, 0, 1.5, 4, 1, 1.5, 0, 0, 1.5, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.5, 4, 0, 2.5, 4, 1, 2.5, 0, 0, 2.5, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.5, 0, 0, 1.5, 0, 1, 2.5, 0, 0, 2.5, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ

End Sub

Public Sub CHAR_R(WV As Integer, STRX As Single, STRY As Single, STRZ As Single, PosY As Single, PosX As Single, PosZ As Single)

    'Vorderes Surface
    CreatePoly WV, 0, 0, 0, 1, 0, 0, 0, 1.3, 0, 1, 0.7, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 1.3, 0, 1, 0.7, 0, 0, 2.07, 0, 1.03, 1.45, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 2.07, 0, 1.03, 1.45, 0, 0, 2.45, 0, 1.15, 1.85, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 0, 1.15, 1.85, 0, 1.2, 1.95, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 0, 1.2, 1.95, 0, 1.28, 2, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 2.45, 0, 1.28, 2, 0, 1.2, 3.05, 0, 1.3, 3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.28, 2, 0, 1.3, 3, 0, 1.85, 2, 0, 2.55, 3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 0, 1.2, 3.05, 0, 1.03, 3.2, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 0, 1.03, 3.2, 0, 1, 3.3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 2.45, 0, 1, 3.3, 0, 0, 4.4, 0, 1, 3.7, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 4.4, 0, 1, 3.7, 0, 0.07, 4.65, 0, 1.05, 3.86, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.07, 4.65, 0, 1.05, 3.86, 0, 0.15, 4.78, 0, 1.1, 3.95, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1.1, 3.95, 0, 0.15, 4.78, 0, 0.35, 4.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.1, 3.95, 0, 0.35, 4.93, 0, 1.23, 4, 0, 0.6, 5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.23, 4, 0, 0.6, 5, 0, 2.57, 4, 0, 2.65, 5, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.57, 4, 0, 2.65, 5, 0, 2.78, 3.9, 0, 3.1, 4.85, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.78, 3.9, 0, 3.1, 4.85, 0, 2.9, 3.78, 0, 3.45, 4.65, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 2.9, 3.78, 0, 3.45, 4.65, 0, 3.68, 4.38, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.9, 3.78, 0, 3.68, 4.38, 0, 2.98, 3.65, 0, 3.9, 4, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.98, 3.65, 0, 3.9, 4, 0, 3, 3.57, 0, 4, 3.65, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 3.57, 0, 4, 3.65, 0, 3, 3.43, 0, 4, 3.35, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 3.43, 0, 4, 3.35, 0, 2.95, 3.3, 0, 3.87, 2.93, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.95, 3.3, 0, 3.87, 2.93, 0, 2.78, 3.1, 0, 3.69, 2.6, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.78, 3.1, 0, 3.69, 2.6, 0, 2.7, 3.05, 0, 3.47, 2.3, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.7, 3.05, 0, 3.47, 2.3, 0, 2.55, 3, 0, 3.4, 2, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3.4, 2, 0, 2.55, 3, 0, 2.33, 1.8, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 2.55, 3, 0, 2.33, 1.8, 0, 2.12, 1.94, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 2.55, 3, 0, 1.85, 2, 0, 2.12, 1.94, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.4, 2, 0, 2.33, 1.8, 0, 3.38, 1.8, 0, 2.51, 1.55, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.38, 1.8, 0, 2.51, 1.55, 0, 3.74, 1, 0, 2.75, 1, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.74, 1, 0, 2.75, 1, 0, 4, 0, 0, 3, 0, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Hinteres Surface
    CreatePoly WV, 0, 0, 1, 1, 0, 1, 0, 1.3, 1, 1, 0.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 1.3, 1, 1, 0.7, 1, 0, 2.07, 1, 1.03, 1.45, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 2.07, 1, 1.03, 1.45, 1, 0, 2.45, 1, 1.15, 1.85, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 1, 1.15, 1.85, 1, 1.2, 1.95, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 1, 1.2, 1.95, 1, 1.28, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 2.45, 1, 1.28, 2, 1, 1.2, 3.05, 1, 1.3, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.28, 2, 1, 1.3, 3, 1, 1.85, 2, 1, 2.55, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 1, 1.2, 3.05, 1, 1.03, 3.2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 0, 2.45, 1, 1.03, 3.2, 1, 1, 3.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 2.45, 1, 1, 3.3, 1, 0, 4.4, 1, 1, 3.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 4.4, 1, 1, 3.7, 1, 0.07, 4.65, 1, 1.05, 3.86, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.07, 4.65, 1, 1.05, 3.86, 1, 0.15, 4.78, 1, 1.1, 3.95, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 1.1, 3.95, 1, 0.15, 4.78, 1, 0.35, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.1, 3.95, 1, 0.35, 4.93, 1, 1.23, 4, 1, 0.6, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.23, 4, 1, 0.6, 5, 1, 2.57, 4, 1, 2.65, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.57, 4, 1, 2.65, 5, 1, 2.78, 3.9, 1, 3.1, 4.85, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.78, 3.9, 1, 3.1, 4.85, 1, 2.9, 3.78, 1, 3.45, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 2.9, 3.78, 1, 3.45, 4.65, 1, 3.68, 4.38, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.9, 3.78, 1, 3.68, 4.38, 1, 2.98, 3.65, 1, 3.9, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.98, 3.65, 1, 3.9, 4, 1, 3, 3.57, 1, 4, 3.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 3.57, 1, 4, 3.65, 1, 3, 3.43, 1, 4, 3.35, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 3.43, 1, 4, 3.35, 1, 2.95, 3.3, 1, 3.87, 2.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.95, 3.3, 1, 3.87, 2.93, 1, 2.78, 3.1, 1, 3.69, 2.6, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.78, 3.1, 1, 3.69, 2.6, 1, 2.7, 3.05, 1, 3.47, 2.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.7, 3.05, 1, 3.47, 2.3, 1, 2.55, 3, 1, 3.4, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 3.4, 2, 1, 2.55, 3, 1, 2.33, 1.8, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 2.55, 3, 1, 2.33, 1.8, 1, 2.12, 1.94, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreateTriangle WV, 2.55, 3, 1, 1.85, 2, 1, 2.12, 1.94, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.4, 2, 1, 2.33, 1.8, 1, 3.38, 1.8, 1, 2.51, 1.55, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.38, 1.8, 1, 2.51, 1.55, 1, 3.74, 1, 1, 2.75, 1, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.74, 1, 1, 2.75, 1, 1, 4, 0, 1, 3, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Z-Surfaces
    CreatePoly WV, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 0, 0, 1, 0.7, 0, 1, 0, 1, 1, 0.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 0.7, 0, 1.03, 1.45, 0, 1, 0.7, 1, 1.03, 1.45, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.03, 1.45, 0, 1.15, 1.85, 0, 1.03, 1.45, 1, 1.15, 1.85, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.15, 1.85, 0, 1.2, 1.95, 0, 1.15, 1.85, 1, 1.2, 1.95, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.2, 1.95, 0, 1.28, 2, 0, 1.2, 1.95, 1, 1.28, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.2, 3.05, 0, 1.3, 3, 0, 1.2, 3.05, 1, 1.3, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.28, 2, 0, 1.85, 2, 0, 1.28, 2, 1, 1.85, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.3, 3, 0, 2.55, 3, 0, 1.3, 3, 1, 2.55, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.2, 3.05, 0, 1.03, 3.2, 0, 1.2, 3.05, 1, 1.03, 3.2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.03, 3.2, 0, 1, 3.3, 0, 1.03, 3.2, 1, 1, 3.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 3.3, 0, 1, 3.7, 0, 1, 3.3, 1, 1, 3.7, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 4.4, 0, 0, 4.4, 1, 0, 0, 0, 0, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0, 4.4, 0, 0.07, 4.65, 0, 0, 4.4, 1, 0.07, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1, 3.7, 0, 1.05, 3.86, 0, 1, 3.7, 1, 1.05, 3.86, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.07, 4.65, 0, 0.15, 4.78, 0, 0.07, 4.65, 1, 0.15, 4.78, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.05, 3.86, 0, 1.1, 3.95, 0, 1.05, 3.86, 1, 1.1, 3.95, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.15, 4.78, 0, 0.35, 4.93, 0, 0.15, 4.78, 1, 0.35, 4.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.1, 3.95, 0, 1.23, 4, 0, 1.1, 3.95, 1, 1.23, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.35, 4.93, 0, 0.6, 5, 0, 0.35, 4.93, 1, 0.6, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.23, 4, 0, 2.57, 4, 0, 1.23, 4, 1, 2.57, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 0.6, 5, 0, 2.65, 5, 0, 0.6, 5, 1, 2.65, 5, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.57, 4, 0, 2.78, 3.9, 0, 2.57, 4, 1, 2.78, 3.9, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.65, 5, 0, 3.1, 4.85, 0, 2.65, 5, 1, 3.1, 4.85, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.78, 3.9, 0, 2.9, 3.78, 0, 2.78, 3.9, 1, 2.9, 3.78, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.1, 4.85, 0, 3.45, 4.65, 0, 3.1, 4.85, 1, 3.45, 4.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.45, 4.65, 0, 3.68, 4.38, 0, 3.45, 4.65, 1, 3.68, 4.38, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.9, 3.78, 0, 2.98, 3.65, 0, 2.9, 3.78, 1, 2.98, 3.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.68, 4.38, 0, 3.9, 4, 0, 3.68, 4.38, 1, 3.9, 4, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.98, 3.65, 0, 3, 3.57, 0, 2.98, 3.65, 1, 3, 3.57, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.9, 4, 0, 4, 3.65, 0, 3.9, 4, 1, 4, 3.65, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 3.57, 0, 3, 3.43, 0, 3, 3.57, 1, 3, 3.43, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 3.65, 0, 4, 3.35, 0, 4, 3.65, 1, 4, 3.35, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3, 3.43, 0, 2.95, 3.3, 0, 3, 3.43, 1, 2.95, 3.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 3.35, 0, 3.87, 2.93, 0, 4, 3.35, 1, 3.87, 2.93, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.95, 3.3, 0, 2.78, 3.1, 0, 2.95, 3.3, 1, 2.78, 3.1, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.87, 2.93, 0, 3.69, 2.6, 0, 3.87, 2.93, 1, 3.69, 2.6, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.78, 3.1, 0, 2.7, 3.05, 0, 2.78, 3.1, 1, 2.7, 3.05, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.69, 2.6, 0, 3.47, 2.3, 0, 3.69, 2.6, 1, 3.47, 2.3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.7, 3.05, 0, 2.55, 3, 0, 2.7, 3.05, 1, 2.55, 3, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.47, 2.3, 0, 3.4, 2, 0, 3.47, 2.3, 1, 3.4, 2, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.33, 1.8, 1, 2.12, 1.94, 1, 2.33, 1.8, 0, 2.12, 1.94, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 1.85, 2, 1, 2.12, 1.94, 1, 1.85, 2, 0, 2.12, 1.94, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.4, 2, 0, 3.38, 1.8, 0, 3.4, 2, 1, 3.38, 1.8, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.33, 1.8, 0, 2.51, 1.55, 0, 2.33, 1.8, 1, 2.51, 1.55, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.38, 1.8, 0, 3.74, 1, 0, 3.38, 1.8, 1, 3.74, 1, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.51, 1.55, 0, 2.75, 1, 0, 2.51, 1.55, 1, 2.75, 1, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 3.74, 1, 0, 4, 0, 0, 3.74, 1, 1, 4, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 2.75, 1, 0, 3, 0, 0, 2.75, 1, 1, 3, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    CreatePoly WV, 4, 0, 0, 3, 0, 0, 4, 0, 1, 3, 0, 1, STRX, STRY, STRZ, PosY, PosX, PosZ

End Sub

Public Sub CHAR_RING(WV As Integer, STRX As Single, STRY As Single, STRZ As Single, PosY As Single, PosX As Single, PosZ As Single)
    Dim n As Single
    Dim RAD As Single
    Dim Step1 As Single
    
    RAD = 9
    Step1 = PI * 2 / 30
    
    For n = 0 To (PI * 2) - Step1 Step Step1
    
    'Vorderes Surface
        CreatePoly WV, Cos(n) * RAD, Sin(n) * RAD, 0, Cos(n + Step1) * RAD, Sin(n + Step1) * RAD, 0 _
        , Cos(n) * (RAD - 1), Sin(n) * (RAD - 1), 0, Cos(n + Step1) * (RAD - 1), Sin(n + Step1) * (RAD - 1), 0, STRX, STRY, STRZ, PosY, PosX, PosZ
    'Hinteres Surface
        CreatePoly WV, Cos(n) * RAD, Sin(n) * RAD, 1, Cos(n + Step1) * RAD, Sin(n + Step1) * RAD, 1 _
        , Cos(n) * (RAD - 1), Sin(n) * (RAD - 1), 1, Cos(n + Step1) * (RAD - 1), Sin(n + Step1) * (RAD - 1), 1, STRX, STRY, STRZ, PosY, PosX, PosZ
    
    'Z-Surfaces
        CreatePoly WV, Cos(n) * RAD, Sin(n) * RAD, 1, Cos(n + Step1) * RAD, Sin(n + Step1) * RAD, 1 _
        , Cos(n) * RAD, Sin(n) * RAD, 0, Cos(n + Step1) * RAD, Sin(n + Step1) * RAD, 0, STRX, STRY, STRZ, PosY, PosX, PosZ
        CreatePoly WV, Cos(n) * (RAD - 1), Sin(n) * (RAD - 1), 0, Cos(n + Step1) * (RAD - 1), Sin(n + Step1) * (RAD - 1), 0 _
        , Cos(n) * (RAD - 1), Sin(n) * (RAD - 1), 1, Cos(n + Step1) * (RAD - 1), Sin(n + Step1) * (RAD - 1), 1, STRX, STRY, STRZ, PosY, PosX, PosZ

    Next

End Sub
