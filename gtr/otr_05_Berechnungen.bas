Attribute VB_Name = "otr_05_Berechnungen"
Option Explicit

Public Sub subCreditsScript()

    CreditsRun = CreditsRun + 0.1 * ConstSpeed
    
    Select Case CreditsRun
    Case Is < 100
        
        FadeFromBlackDull = 0
        
    Case 100 To 970
        
        subCloudMotion
        subAnimateSunCorona
        
        subAnimateCreditsShip
    
        subRunCam
        
        If CreditsRun > 940 Then Fishmode = Fishmode + 0.002 * ConstSpeed * Fishmode * Fishmode
    
        If CreditsRun > 967 Then Fade = Fade + 0.05 * ConstSpeed
        
        SubDrawCreditsUniverse
        
        If CreditsRun > 260 And CreditsRun < 275 Then Fade = 1
        If CreditsRun > 710 And CreditsRun < 725 Then Fade = 1
    
    Case 970 To 1070
    
        If CreditsRun < 973 Then
        
            Fishmode = PI / 3
        
            Fade = Fade + 0.01 * ConstSpeed
            
            CamX = 0
            CamY = 0
            CamZ = -30
    
            CamDX = 0
            CamDY = 0
            CamDZ = 0
            
            
            ViewPort.lX = 0
            ViewPort.lY = ResolutionY / 4
            ViewPort.lWidth = ResolutionX
            ViewPort.lHeight = ResolutionY / 2
            g_D3DDev.SetViewport ViewPort
            
        End If
        
        subMoveCWStars
        
        subCWarpStars
        
        If CreditsRun > 1067 Then Fade = Fade + 0.05 * ConstSpeed
        
    Case Is > 1070
    
        subGCameraScript
           
        subDrawGalaxyBack
            
        subDrawGalaxy
        
        Intro.CAMR = Intro.CAMR + ConstSpeed * (250 - Intro.CAMR) / 50
                    
        Intro.CAMRAD2 = Intro.CAMRAD2 + ConstSpeed * (0.4 - Intro.CAMRAD2) / 50
        
        
        If CreditsRun < 1072 Then
            
            Fade = Fade + 0.01 * ConstSpeed
            
            ViewPort.lX = 0
            ViewPort.lY = 0
            ViewPort.lWidth = ResolutionX
            ViewPort.lHeight = ResolutionY
            g_D3DDev.SetViewport ViewPort
        End If
        
    End Select
    
End Sub

'======================= Rotation initialisieren =======================
Public Sub subCloudMotion()
    Dim n As Long
    
    For n = 1 To MAX_SEGMENTS
        CloudVertex(n).tv = CloudVertex(n).tv - 0.00005 * ConstSpeed
        'S1CloudVertex(n).tv = S1CloudVertex(n).tv + 0.00001 * ConstSpeed
        'S2CloudVertex(n).tv = S2CloudVertex(n).tv - 0.00001 * ConstSpeed
    Next
End Sub
'=======================================================================




Public Sub GenerateSunElement(Count As Long)
    Dim Rad As Single
    
    Rad = Rnd * PI * 2
    
    With SunElement(Count)
        .MX = Cos(Rad) / 5
        .MY = Sin(Rad) / 5
        
        .X = Cos(Rad) * 120
        .Y = Sin(Rad) * 120 + 30
        .Vertex(1).Z = 4000
        .Vertex(2).Z = 4000
        .Vertex(3).Z = 4000
        .Vertex(4).Z = 4000

        .Age = 0
    End With

End Sub

Public Sub subAnimateSunCorona()
    Dim n As Long
    
    If SunElementCounter + 2 * ConstSpeed > MAX_SUN_ELEMENTS Then SunElementCounter = 2 * ConstSpeed
    
    For n = SunElementCounter To SunElementCounter + 2 * ConstSpeed
        GenerateSunElement n
    Next
    
    SunElementCounter = SunElementCounter + 2 * ConstSpeed
    
    
    For n = 1 To MAX_SUN_ELEMENTS
        With SunElement(n)
            
            .X = .X + .MX * ConstSpeed
            .Y = .Y + .MY * ConstSpeed
            
            .Vertex(1).X = .X
            .Vertex(1).Y = .Y
            
            .Vertex(2).X = .X + SunElementRadius
            .Vertex(2).Y = .Y
            
            .Vertex(3).X = .X
            .Vertex(3).Y = .Y - SunElementRadius
            
            .Vertex(4).X = .X + SunElementRadius
            .Vertex(4).Y = .Y - SunElementRadius
            
            .Age = .Age + ConstSpeed / 10
            
        End With
    Next

End Sub

Public Sub subRunCam()

    If RunCamSrc < SplinePointsS - 1.01 Then
        RunCamSrc = RunCamSrc + SPS(Int(RunCamSrc)).v * ConstSpeed
        
        subGetCameraPoint SPS(Int(RunCamSrc)), TPS(Int(RunCamSrc) * 2), TPS(Int(RunCamSrc) * 2 + 1), SPS(Int(RunCamSrc) + 1), RunCamSrc - Int(RunCamSrc), CSP
        
        CamX = CSP.X
        CamY = CSP.Y
        CamZ = CSP.Z
    End If
    
    If RunCamDir < SplinePointsD - 1.01 Then
        RunCamDir = RunCamDir + SPD(Int(RunCamDir)).v * ConstSpeed
        
        subGetCameraPoint SPD(Int(RunCamDir)), TPD(Int(RunCamDir) * 2), TPD(Int(RunCamDir) * 2 + 1), SPD(Int(RunCamDir) + 1), RunCamDir - Int(RunCamDir), CSP
        
        CamDX = CSP.X
        CamDY = CSP.Y
        CamDZ = CSP.Z
    End If

End Sub

Private Sub subGetCameraPoint(P1 As TCameraPoint, P2 As TCameraPoint, P3 As TCameraPoint, P4 As TCameraPoint, u As Single, P As TCameraPoint)
    Dim u1 As Single
    
    u1 = (1 - u)
    
    P.X = P1.X * u1 * u1 * u1 + _
          P2.X * 3 * u * u1 * u1 + _
          P3.X * 3 * u * u * u1 + _
          P4.X * u * u * u
    P.Y = P1.Y * u1 * u1 * u1 + _
          P2.Y * 3 * u * u1 * u1 + _
          P3.Y * 3 * u * u * u1 + _
          P4.Y * u * u * u
    P.Z = P1.Z * u1 * u1 * u1 + _
          P2.Z * 3 * u * u1 * u1 + _
          P3.Z * 3 * u * u * u1 + _
          P4.Z * u * u * u
End Sub


Public Sub subMoveCWStars()

    Dim n As Long
    
    For n = 0 To MAX_WSTARS
    
        WStarVertex(n * 3).Z = WStarVertex(n * 3).Z + 0.5 * ConstSpeed
        WStarVertex(n * 3 + 1).Z = WStarVertex(n * 3 + 1).Z + 0.5 * ConstSpeed
        WStarVertex(n * 3 + 2).Z = WStarVertex(n * 3 + 2).Z + 0.5 * ConstSpeed
        
        If WStarVertex(n * 3).Z > 75 Then subRecoverCWStar n
        
    Next

End Sub


Public Sub subRecoverCWStar(Count As Long)

    WStarVertex(Count * 3).Z = -110 + WStarVertex(Count * 3).Z
    WStarVertex(Count * 3 + 1).Z = -110 + WStarVertex(Count * 3 + 1).Z
    WStarVertex(Count * 3 + 2).Z = -110 + WStarVertex(Count * 3 + 2).Z
    
End Sub


