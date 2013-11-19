Attribute VB_Name = "ntr_03_Loading"
Option Explicit

Public Sub subLoadIntroTextures()
    '===================================================== Textures ========================================
    subLoadTexture "star.bmp", StarTex
    subLoadTexture "galaxy.bmp", GalaxyTex
    subLoadTexture "font3d.bmp", FontTex
    subLoadTexture "stars.bmp", StarsTex
    subLoadTexture "warpstar.bmp", WarpStarTex
    
    subLoadTexture "enhance.bmp", Sentence.Tex(1)
    subLoadTexture "improve.bmp", Sentence.Tex(2)
    subLoadTexture "muh.bmp", Sentence.Tex(3)
    '=======================================================================================================
End Sub

Public Sub subLoadIntroSounds()
    
    LoadWave IntroMusic, "intro.wav"   'Laden der Sounddatei in einen Buffer
    
End Sub


Public Sub subUnloadLoadIntroStuff()
    '===================================================== Textures ========================================
    Set StarTex = Nothing
    Set GalaxyTex = Nothing
    Set FontTex = Nothing
    Set StarsTex = Nothing
    Set WarpStarTex = Nothing

    Set Sentence.Tex(1) = Nothing
    Set Sentence.Tex(2) = Nothing
    Set Sentence.Tex(3) = Nothing
    
    Set IntroMusic = Nothing
    '=======================================================================================================
End Sub

