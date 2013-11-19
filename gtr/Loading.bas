Attribute VB_Name = "mnu_m04_Loading"
Option Explicit


Public Sub subLoadMenuTextures()
    Dim n As Long
    
    subLoadTexture "star1.bmp", Menu3DStarTex
    subLoadTexture "star.bmp", MenuMouseStarTex

    With TargetGUI
        For n = 1 To 5
            subLoadTexture "cross0" & n & ".bmp", .GUI(n)
        Next
    End With

End Sub

Public Sub subLoadMenuPictures()
    
    With MainMenu.Choise
        subLoadSurface .Picture, .Width, .Height, PicturePath & "menu.bmp"
    End With
    
    With MainMenu.Control
        subLoadSurface .Picture, .Width, .Height, PicturePath & "controls.bmp"
    End With
    
    With CheckBox
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "checkon1.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "checkoff1.bmp"
        subLoadSurface .Picture3, .Width, .Height, PicturePath & "checkon2.bmp"
        subLoadSurface .Picture4, .Width, .Height, PicturePath & "checkoff2.bmp"
    End With
    
    With Scroller
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "left.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "right.bmp"
    End With
    
    With FlyerBox
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "left.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "right.bmp"
    End With
    
    With ServerListBox
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "up.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "down.bmp"
    End With
        
    With MapListBox
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "up.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "down.bmp"
    End With
    
    With MessageListBox
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "up.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "down.bmp"
    End With
    
    With GameModeList
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "up.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "down.bmp"
    End With
    
    
    With TargetGUI
        subLoadSurface .Picture1, .Width, .Height, PicturePath & "left.bmp"
        subLoadSurface .Picture2, .Width, .Height, PicturePath & "right.bmp"
    End With

    With MCursor
        subLoadSurface .Picture, .Width, .Height, PicturePath & "cursor.bmp"
    End With


End Sub

Public Sub subLoadMenuSounds()

    Set MenuFadeSound = DS7.CreateSoundBufferFromFile(SoundPath & "fade.wav", BufferDesc, WaveFormat)
    Set MenuMoveSound = DS7.CreateSoundBufferFromFile(SoundPath & "menumove.wav", BufferDesc, WaveFormat)
    Set MenuBackSound = DS7.CreateSoundBufferFromFile(SoundPath & "menuback.wav", BufferDesc, WaveFormat)

End Sub

