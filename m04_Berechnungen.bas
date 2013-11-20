Attribute VB_Name = "gme_04_Berechnungen"
Option Explicit

'FPS berechnen(Technik 2)
Public Sub CalcFPS()
If FPSTimer < g_DX.TickCount Then
    FPS = 1000 * TimeQuotient / (g_DX.TickCount - FPSTimer)
    FPSTimer = g_DX.TickCount
    TimeQuotient = 1
Else
    TimeQuotient = TimeQuotient + 1
End If

If FPS > 0 Then
    ConstSpeed = 85 / FPS
Else
    ConstSpeed = 1
End If

End Sub


'=== ÜberRandProzedur für alle Rectangles ============================================
Public Sub subOverEdge(lWidth As Integer, lHeight As Integer, lAnimationNumber As Integer, ByRef lX As Single, ByRef lY As Single, ByRef lRectangle As RECT)
Dim BackUplX As Single
Dim BackUplY As Single
Dim BackUplRect As RECT

BackUplX = lX
BackUplY = lY

BackUplRect.Left = lWidth * lAnimationNumber
BackUplRect.Right = BackUplRect.Left + lWidth
BackUplRect.Top = 0
BackUplRect.Bottom = BackUplRect.Top + lHeight

lRectangle.Left = BackUplRect.Left
lRectangle.Right = BackUplRect.Right
lRectangle.Top = BackUplRect.Top
lRectangle.Bottom = BackUplRect.Bottom

If BackUplX < 0 And BackUplX + lWidth >= 0 Then
    lRectangle.Left = BackUplRect.Left - BackUplX
    lX = 0
End If

If BackUplY < 0 And BackUplY + lHeight >= 0 Then   'für oberen Rand
    lRectangle.Top = BackUplRect.Top - BackUplY
    lY = 0
End If

If BackUplX <= ResolutionX And BackUplX + lWidth > ResolutionX Then  'für Rechten Rand
    lRectangle.Right = (ResolutionX - BackUplX) + BackUplRect.Left
End If

If BackUplY <= ResolutionY And BackUplY + lHeight > ResolutionY Then   'für unteren Rand
    lRectangle.Bottom = (ResolutionY - BackUplY) + BackUplRect.Top
End If


End Sub
