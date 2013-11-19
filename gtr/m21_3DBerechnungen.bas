Attribute VB_Name = "mnu_m11_Berechnungen"
Option Explicit


'=== Flugberechnung des Sterns ==========================================
Public Sub sub3DGTRStarflight()
    Dim n As Long
    
    For n = 0 To 4
        With Menu3DStar(n)
        
            If Abs(.TargetX - .X) < 0.001 Then .TargetX = .TargetX + Rnd - 0.5
            If Abs(.TargetY - .Y) < 0.001 Then .TargetY = .TargetY + Rnd - 0.5
            If Abs(.TargetZ - .Z) < 0.001 Then .TargetZ = .TargetZ + Rnd - 0.5
            .SpeedX = .SpeedX + (.TargetX - .X) / (Abs(.TargetX - .X) * 1000)
            .SpeedY = .SpeedY + (.TargetY - .Y) / (Abs(.TargetY - .Y) * 1000)
            .SpeedZ = .SpeedZ + (.TargetZ - .Z) / (Abs(.TargetZ - .Z) * 1000)
            
            .X = .X + .SpeedX * ConstSpeed
            .Y = .Y + .SpeedY * ConstSpeed
            .Z = .Z + .SpeedZ * ConstSpeed
            
            .Vertex(0).X = .X + 1: .Vertex(0).Y = .Y + 1: .Vertex(0).Z = .Z
            .Vertex(1).X = .X + 2: .Vertex(1).Y = .Y + 1: .Vertex(1).Z = .Z
            .Vertex(2).X = .X + 1: .Vertex(2).Y = .Y: .Vertex(2).Z = .Z
            .Vertex(3).X = .X + 1: .Vertex(3).Y = .Y: .Vertex(3).Z = .Z
            .Vertex(4).X = .X + 2: .Vertex(4).Y = .Y + 1: .Vertex(4).Z = .Z
            .Vertex(5).X = .X + 2: .Vertex(5).Y = .Y: .Vertex(5).Z = .Z
            
            .Light.position = Vector(.X, .Y, .Z)
            g_D3DDev.SetLight n, .Light
            
        End With
    Next
End Sub
'========================================================================

'=== GTR-Bewegung =======================================================
Public Sub subMove3DGTRMenu()

    If MainMenu.CamZ + 30 < -0.1 Then
        MainMenu.CamZ = MainMenu.CamZ + ((-30 - MainMenu.CamZ) / 20) * ConstSpeed
        MainMenu.Choise.Y = ResolutionY
    Else
        MainMenu.CamZ = -30
    End If

    Dim n As Long
    
    If Abs(GTR3D.TargetX - GTR3D.PosX) > 0.1 Then
    
        With GTR3D
               
                .MovingX = ((.TargetX - .PosX) / 10) * ConstSpeed
                .MovingY = ((.TargetY - .PosY) / 10) * ConstSpeed
                .MovingZ = ((.TargetZ - .PosZ) / 10) * ConstSpeed
            
                For n = 0 To 2010
                    
                    .Vertex(n).X = .Vertex(n).X + .MovingX
                    .Vertex(n).Y = .Vertex(n).Y + .MovingY
                    .Vertex(n).Z = .Vertex(n).Z + .MovingZ
                    
                Next
                
        End With
             
        For n = 0 To 4
                With Menu3DStar(n)
                
                    .X = .X + GTR3D.MovingX
                    .Y = .Y + GTR3D.MovingY
                    .Z = .Z + GTR3D.MovingZ
                    
                    .TargetX = .TargetX + GTR3D.MovingX
                    .TargetY = .TargetY + GTR3D.MovingY
                    .TargetZ = .TargetZ + GTR3D.MovingZ
                End With
        Next
        
        With GTR3D
                .RotationMitte.X = .RotationMitte.X + .MovingX
                .RotationMitte.Y = .RotationMitte.Y + .MovingY
                .RotationMitte.Z = .RotationMitte.Z + .MovingZ
                
                .PosX = .PosX + .MovingX
                .PosY = .PosY + .MovingY
                .PosZ = .PosZ + .MovingZ
        End With
    
    End If
    
End Sub
'=======================================================================

'======================= Rotation initialisieren =======================
Public Sub subRotate3DGTRMenu()
    Dim n As Long
    
    With GTR3D
    
        For n = 0 To 1271       ' GTR
            
            .TempVector.X = .Vertex(n).X
            .TempVector.Y = .Vertex(n).Y
            .TempVector.Z = .Vertex(n).Z
            
            MenuCharacterRotation .TempVector, .RotationMitte, GTR3D.Speed
            
            GTR3D.Vertex(n).X = .TempVector.X
            GTR3D.Vertex(n).Y = .TempVector.Y
            GTR3D.Vertex(n).Z = .TempVector.Z
        Next
        
        For n = 1272 To 2010    ' Ring
            
            .TempVector.X = .Vertex(n).X
            .TempVector.Y = .Vertex(n).Y
            .TempVector.Z = .Vertex(n).Z
                                            
            MenuCharacterRotation .TempVector, .RotationMitte, -GTR3D.Speed
            
            .Vertex(n).X = .TempVector.X
            .Vertex(n).Y = .TempVector.Y
            .Vertex(n).Z = .TempVector.Z
        Next
        
    End With

End Sub
'=======================================================================

'====================== Rotation errechnen ======================
Public Sub MenuCharacterRotation(ByRef Vector As D3DVECTOR, Mitte As D3DVECTOR, ByVal Speed As Single)
    Dim RMat As D3DMATRIX
    Dim PMat As D3DMATRIX
    Dim DMat As D3DMATRIX
    
    g_DX.IdentityMatrix RMat
    g_DX.IdentityMatrix PMat
    g_DX.IdentityMatrix DMat
    
    g_DX.RotateYMatrix RMat, Speed * ConstSpeed
    
    PMat.rc41 = Vector.X - Mitte.X
    PMat.rc42 = Vector.Y - Mitte.Y
    PMat.rc43 = Vector.Z - Mitte.Z
    
    RMat.rc41 = Mitte.X
    RMat.rc42 = Mitte.Y
    RMat.rc43 = Mitte.Z
    
    g_DX.MatrixMultiply DMat, PMat, RMat
    
    Vector.X = DMat.rc41
    Vector.Y = DMat.rc42
    Vector.Z = DMat.rc43

End Sub
'================================================================


'=== MainMenu wird bewegt=================================================
Public Sub subMoveMainMenu()

    With MainMenu.Choise
    
        .Y = .Y + MainMenu.MoveY * ConstSpeed
        
        If Abs(MainMenu.MoveY) <> MainMenu.MoveY Then MainMenu.MoveY = ((ResolutionY - .Height) / 2 - .Y) / 10
        
        If .Y > ResolutionY Then
            MainMenu.MoveY = 0
            .Y = ResolutionY
            If MainMenu.MenuStatus <> MainM Then
                GTR3D.TargetX = -80
                GTR3D.TargetY = 70
                GTR3D.TargetZ = 150
                SubMenu.TargetX = -0.5
            End If
        End If
        
        If .Y <= (ResolutionY - .Height) / 2 Then
            MainMenu.MoveY = 0
            .Y = (ResolutionY - .Height) / 2
        End If
           
    End With
    

End Sub
'=========================================================================

'=== SubMenu wird bewegt==================================================
Public Sub subMoveSubMenu()
    Dim n As Long
    
    With SubMenu
    
        .MovingX = ((.TargetX - .PosX) / 10) * ConstSpeed
    
        For n = 0 To 8
            .Vertex(n).X = .Vertex(n).X + .MovingX
        Next
        
        .PosX = .PosX + .MovingX
           
    End With

End Sub
'=========================================================================

'=== Bewegung der Hintergrundsterne ermitteln ===================
Public Sub subMoveMainMenuBackStars()
    
    Dim n As Long
    Dim m As Long
    
    With MainMenuBackStars
    
            .RAD(0) = .RAD(0) + 0.005
            .SpeedX(0) = (Cos(.RAD(0)) / 10) * ConstSpeed
            .SpeedY(0) = ((Sin(.RAD(0)) + Cos(.RAD(0))) / 10) * ConstSpeed
            
            .RAD(1) = .RAD(1) + 0.02
            .SpeedX(1) = (Cos(-.RAD(1)) / 15) * ConstSpeed
            .SpeedY(1) = ((Sin(-.RAD(1)) + Cos(.RAD(1))) / 15) * ConstSpeed
        
            .RAD(2) = .RAD(2) + 0.03
            .SpeedX(2) = (Cos(.RAD(2)) / 20) * ConstSpeed
            .SpeedY(2) = ((Sin(.RAD(2)) + Cos(-.RAD(2))) / 20) * ConstSpeed
        
        For n = 0 To MAX_MENU_BACKSTARS
            For m = 0 To 2
                    .RX(m, n) = .RX(m, n) - .SpeedX(m)
                    If .RX(m, n) > ResolutionX Then .RX(m, n) = .RX(m, n) - ResolutionX
                    If .RX(m, n) < 0 Then .RX(m, n) = .RX(m, n) + ResolutionX
                
                    .RY(m, n) = .RY(m, n) - .SpeedY(m)
                    If .RY(m, n) > ResolutionY Then .RY(m, n) = .RY(m, n) - ResolutionY
                    If .RY(m, n) < 0 Then .RY(m, n) = .RY(m, n) + ResolutionY
            Next
        Next
        
    End With

End Sub
'================================================================

Public Sub subMoveMouseStars()
    Dim n As Long
    
    MenuMousePartTimeCounter = MenuMousePartTimeCounter + 1 * ConstSpeed
    
    If ConstSpeed < 10 Then
        If MenuMousePartTimeCounter Mod (10 / (ConstSpeed + 0.0001)) = 0 Then
            GenerateMouseStar MenuMouseParticleCounter
            MenuMouseParticleCounter = MenuMouseParticleCounter + 1
            If MenuMouseParticleCounter > MAX_MENU_MOUSEPARTICLES Then MenuMouseParticleCounter = 1
        End If
    End If
    
    For n = 1 To MAX_MENU_MOUSEPARTICLES
        With MenuMouseParticle(n)
            
            .X = .X + .MX * ConstSpeed
            .Y = .Y + .MY * ConstSpeed
            
            .Vertex(1).X = .X
            .Vertex(1).Y = .Y
            
            .Vertex(2).X = .X + MenuMouseParticleRadius
            .Vertex(2).Y = .Y
            
            .Vertex(3).X = .X
            .Vertex(3).Y = .Y + MenuMouseParticleRadius
            
            .Vertex(4).X = .X + MenuMouseParticleRadius
            .Vertex(4).Y = .Y + MenuMouseParticleRadius
            
            .Age = .Age + ConstSpeed * 1.5
            
            If .Age > 1000 Then .Age = 1000
            
        End With
    Next

End Sub


Public Sub GenerateMouseStar(Count As Integer)
    Dim RAD As Single
    
    RAD = -Rnd * (PI / 3) - 0.5
    MenuMouseParticle(Count).MX = Cos(RAD) / 300
    MenuMouseParticle(Count).MY = Sin(RAD) / 300
    
    MenuMouseParticle(Count).X = (MouseX + 15) / D3DDivX + D3DSubX
    MenuMouseParticle(Count).Y = -(MouseY + 23) / D3DDivY + D3DSubY
    
    MenuMouseParticle(Count).Age = 0

End Sub
