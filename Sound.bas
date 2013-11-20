Attribute VB_Name = "mnu_m13_Sound"
Option Explicit


'=== Sounds im Menu ======================================
'=========================================================
Public Sub subPlayMenuFadeSound()
    
    MenuFadeSound.Stop
    MenuFadeSound.SetCurrentPosition 0
    'MenuFadeSound.Play 0

End Sub


Public Sub subPlayMenuMoveSound()
    
    MenuMoveSound.Stop
    MenuMoveSound.SetCurrentPosition 0
    'MenuMoveSound.Play 0

End Sub


Public Sub subPlayMenuBackSound()
    
    MenuBackSound.SetVolume -1000
    MenuBackSound.Play 1

End Sub
'=========================================================
'=========================================================
