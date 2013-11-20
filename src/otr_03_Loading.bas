Attribute VB_Name = "otr_03_Loading"
Option Explicit


Public Sub subLoadCreditsTextures()
    Dim n As Long

    '===================================================== Texture =========================================
    subLoadTexture "planet.bmp", EarthTex
    subLoadTexture "star.bmp", SunElementTex
    subLoadTexture "circle.bmp", RingTex
    subLoadTexture "clouds.bmp", CloudTex
    subLoadTexture "stars.bmp", StarsTex
    subLoadTexture "sun.bmp", SunTex
    subLoadTexture "light.bmp", LightTex
    
    subLoadTexture "warpstar.bmp", WarpStarTex
    subLoadTexture "star.bmp", StarTex
    subLoadTexture "galaxy.bmp", GalaxyTex
    
    subLoadTexture "font3d.bmp", FontTex
    '=======================================================================================================

    For n = 1 To 11
        subLoadTexture "surface" & Format(n, "00") & ".bmp", Credits3DShip.Tex(n)
    Next

End Sub



Public Sub subLoadCreditsSounds()
    
    LoadWave CreditsMusic, "outro.wav"
    
End Sub



Public Sub subUnloadLoadCreditsStuff()
    Dim n As Long

    '===================================================== Texture =========================================
    Set EarthTex = Nothing
    Set SunElementTex = Nothing
    Set RingTex = Nothing
    Set CloudTex = Nothing
    Set StarsTex = Nothing
    Set SunTex = Nothing
    Set EarthTex = Nothing
    Set LightTex = Nothing
    
    Set WarpStarTex = Nothing
    Set StarTex = Nothing
    Set GalaxyTex = Nothing
    
    Set FontTex = Nothing
    '=======================================================================================================

    For n = 1 To 11
        Set Credits3DShip.Tex(n) = Nothing
    Next
    
    Set CreditsMusic = Nothing

End Sub
