Attribute VB_Name = "m_005_MATHEMATICS_01"
Option Explicit

Private TimerFreq                   As Currency             'Timer-Frequenz
Private LastCntrVal                 As Currency             'letzte Zeitnahme
Private FPSLoopQuotient             As Long

'Pythagoras (Addition)
Public Function PythA(ByVal a As Single, ByVal b As Single) As Single

    PythA = Sqr(a * a + b * b)

End Function

'Pythagoras ohne Wurzel
Public Function CQuad(ByVal a As Single, ByVal b As Single) As Single

    CQuad = a * a + b * b

End Function

'Rectangle-Kollision
Public Function RectCollision(ByVal X1 As Long, ByVal Y1 As Long, ByVal Width1 As Integer, ByVal Height1 As Integer, ByVal X2 As Long, ByVal Y2 As Long, ByVal Width2 As Integer, ByVal Height2 As Integer) As Boolean

    RectCollision = ((X1 + Width1 >= X2) And (X1 <= X2 + Width2) And (Y1 + Height1 >= Y2) And (Y1 <= Y2 + Height2))

End Function

'gibt zurück ob sich ein Objekt in einem Rectangle befindet
Public Function IsInRect(ByRef Rectangle As RECT, ByVal X As Long, ByVal Y As Long, ByVal Width As Integer, ByVal Height As Integer) As Boolean

    With Rectangle
        IsInRect = ((X + Width >= .Left) And (Y + Height >= .Top) And (X <= .Right) And (Y <= .Bottom))
    End With

End Function

'gibt zurück ob sich ein Objekt in einem RectSng befindet
Public Function IsInRectSng(ByRef Rectangle As TRectSng, ByVal X As Long, ByVal Y As Long, ByVal Width As Integer, ByVal Height As Integer) As Boolean

    With Rectangle
        IsInRectSng = ((X + Width >= .Left) And (Y + Height >= .Top) And (X <= .Right) And (Y <= .Bottom))
    End With

End Function

'Radius Kollision
Public Function RadiusCollision(ByVal MidX1 As Long, ByVal MidY1 As Long, ByVal r1 As Integer, ByVal MidX2 As Long, ByVal MidY2 As Long, ByVal r2 As Integer) As Boolean
    
    Dim a As Long
    Dim b As Long
    
    a = MidX2 - MidX1
    b = MidY2 - MidY1
    RadiusCollision = (Sqr(a * a + b * b) <= r1 + r2)
        
End Function

'Event initialisieren (TimeOut in ms)
Public Sub SetEvent(ByRef TimeEvent As TTimeEvent, ByVal StartDelay As Long, Optional ByVal TimeOut As Long = 0)

    With TimeEvent
        .StartTime = g_DX.TickCount
        .StartDelay = StartDelay
        .TimeOut = TimeOut
    End With

End Sub

'Event-Status abfragen (SpeedFact von 0 bis 1)
Public Function GetEventStatus(ByRef TimeEvent As TTimeEvent, Optional ByVal SpeedFact As Single = 1) As Boolean
    
    With TimeEvent
        If .StartDelay >= 0 Then
            If .TimeOut > 0 Then
                GetEventStatus = (g_DX.TickCount >= .StartTime + .StartDelay * SpeedFact And g_DX.TickCount <= .StartTime + (.StartDelay + .TimeOut) * SpeedFact)
            ElseIf .TimeOut = 0 Then
                GetEventStatus = (g_DX.TickCount >= .StartTime + .StartDelay * SpeedFact)
            End If
        Else
            GetEventStatus = False
        End If
    End With
    
End Function

'initialisiert die FPS-Berechnung
Public Sub Init_FPSCalculation(ByRef FPS As Single)

    QueryPerformanceFrequency TimerFreq
    LastCntrVal = 0
    FPSLoopQuotient = 1
    FPS = DEFAULT_GAMESPEED

End Sub

'berechnet die FPS
Public Sub GetFPS(ByRef FPS As Single)
    
    Dim CurrentCntrVal      As Currency

    QueryPerformanceCounter CurrentCntrVal

    If LastCntrVal < CurrentCntrVal Then
        FPS = FPSLoopQuotient / ((CurrentCntrVal - LastCntrVal) / TimerFreq)
        LastCntrVal = CurrentCntrVal
        FPSLoopQuotient = 1

        If FPS < 1 Then FPS = 1
    Else
        FPSLoopQuotient = FPSLoopQuotient + 1
    End If
    
End Sub

'gibt den Durchschnittsfaktor der Spielgeschwindigkeit zurück
Public Function GetAVF(ByVal FPS As Single, Optional ByVal GameSpeed As Single = DEFAULT_GAMESPEED) As Single

    GetAVF = GameSpeed / FPS

End Function

'Gibt den Beschleunigungsfaktor zurück
Public Function GetAVAcc(ByVal AccFactor As Single, ByVal AVF As Single) As Single

    GetAVAcc = 1 + (AccFactor - 1) * AVF

End Function

'Gibt den Rad zwischen zwei Punkten zurück
Public Function GetRad(ByRef dx As Long, ByRef dy As Long) As Single

    If dx < 0 Then
        GetRad = (Atn(dy / dx) + HPI)
    ElseIf dy < 0 And dx > 0 Then
        GetRad = Atn(dy / dx) + PI + HPI
    Else
        If dx = 0 Then
            If dy < 0 Then
                GetRad = HPI
            Else
                GetRad = PI + HPI
            End If
        Else
            GetRad = Atn(dy / dx) + PI + HPI
        End If
    End If
    
End Function
