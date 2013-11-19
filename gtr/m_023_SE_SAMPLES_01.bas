Attribute VB_Name = "m_023_SE_SAMPLES_01"
Option Explicit

Public Const MAX_SMALL_EXPLOSIONS                   As Long = 30
Public SmallExplosion(1 To MAX_SMALL_EXPLOSIONS)    As TEffect
Public SmallExploCount                              As Long

Public Const MAX_WALL_PUFFS                         As Long = 5
Public WallPuff(1 To MAX_WALL_PUFFS)                As TEffect
Public WallPuffCount                                As Long

Public Const MAX_BIG_EXPLOSIONS                     As Long = 5
Public BigExplosion(1 To MAX_BIG_EXPLOSIONS)        As TEffect
Public BigExploCount                                As Long

Public Const MAX_RESPAWN_EFFECTS                    As Long = 5
Public RespawnEffect(1 To MAX_RESPAWN_EFFECTS)      As TEffect
Public RespawnEffectCount                           As Long

Public Const MAX_WAVE_EXPLOSIONS                    As Long = 5
Public ExplosionWave(1 To MAX_WAVE_EXPLOSIONS)      As TEffect
Public WaveExploCount                               As Long

Public Impulse(1 To MAX_PLAYERS)                    As TEffect

Public WeaponLight                                  As TLight

Public WeaponExploLight(1 To MAX_SMALL_EXPLOSIONS)  As TLight
Public ShipExploLight(1 To MAX_BIG_EXPLOSIONS)      As TLight
Public RespawnLight(1 To MAX_RESPAWN_EFFECTS)       As TLight


Public EffectTexture(1 To 2)                        As DirectDrawSurface7
Public LightTexture                                 As DirectDrawSurface7

Public Wave(1 To 5)                                 As T3DWave
Public WaveUBound                                   As Long
Public WaveCount                                    As Long

'Public UseShockWaves                                As Boolean
'Public UseLights                                    As Boolean
'Public DrawImpulse                                  As Boolean


Public Sub AddSmallExplosion(ByRef VX As Long, ByRef VY As Long)
    SmallExploCount = SmallExploCount + 1
    If SmallExploCount > MAX_SMALL_EXPLOSIONS Then SmallExploCount = 1
    
    
    If IsEffectInRect(g_Map.Wnd, SmallExplosion(SmallExploCount), CSng(VX), CSng(VY)) Then
        SetEffect SmallExplosion(SmallExploCount), CSng(VX), CSng(VY)
        
        If UseLights Then SetLight WeaponExploLight(SmallExploCount), 0, CSng(VX), CSng(VY)
        
    End If
End Sub

Public Sub AddWallPuff(ByRef VX As Long, ByRef VY As Long)
    WallPuffCount = WallPuffCount + 1
    If WallPuffCount > MAX_WALL_PUFFS Then WallPuffCount = 1
    
    If IsEffectInRect(g_Map.Wnd, WallPuff(WallPuffCount), CSng(VX), CSng(VY)) Then
        SetEffect WallPuff(WallPuffCount), CSng(VX), CSng(VY)
    End If
End Sub

Public Sub AddBigExplosion(ByRef VX As Single, ByRef VY As Single)
    BigExploCount = BigExploCount + 1
    If BigExploCount > MAX_BIG_EXPLOSIONS Then BigExploCount = 1
    
    If PythA(g_Map.Wnd.Left + 512 - VX, g_Map.Wnd.Top + 384 - VY) < 1000 Then
        SetEffect BigExplosion(BigExploCount), VX, VY
        
        If UseLights Then SetLight ShipExploLight(BigExploCount), 0, CSng(VX), CSng(VY)
        
    End If
End Sub

Public Sub AddRespawnEffect(ByRef VX As Single, ByRef VY As Single, Important As Boolean)
    RespawnEffectCount = RespawnEffectCount + 1
    If RespawnEffectCount > MAX_RESPAWN_EFFECTS Then RespawnEffectCount = 1
    
    If IsEffectInRect(g_Map.Wnd, RespawnEffect(RespawnEffectCount), VX, VY) Or Important Then
        SetEffect RespawnEffect(RespawnEffectCount), VX, VY
        
        If UseLights Then SetLight RespawnLight(RespawnEffectCount), 0, CSng(VX), CSng(VY)
        
    End If
End Sub

Public Sub AddWaveExplosion(ByRef VX As Single, ByRef VY As Single)
    WaveExploCount = WaveExploCount + 1
    If WaveExploCount > MAX_WAVE_EXPLOSIONS Then WaveExploCount = 1
    
    If PythA(g_Map.Wnd.Left + 512 - VX, g_Map.Wnd.Top + 384 - VY) < 1000 Then
        SetEffect ExplosionWave(WaveExploCount), VX, VY
    End If
End Sub

Public Sub AddWave(ByRef VX As Single, ByRef VY As Single)
    WaveCount = WaveCount + 1
    If WaveCount > UBound(Wave) Then WaveCount = LBound(Wave)
    
    If WaveUBound < WaveCount Then WaveUBound = WaveCount
    
    SetWaveNet Wave(WaveCount), VX, VY
End Sub

Public Sub InitSpecialEffects()
    Dim n As Long
    
    DrawRespawnEffect = GetINIValue(App.Path & "\config.ini", "OPTIONS", "DrawRespawnEffect")
    UseShockWaves = GetINIValue(App.Path & "\config.ini", "OPTIONS", "UseShockWaves")
    UseLights = GetINIValue(App.Path & "\config.ini", "OPTIONS", "UseLights")
    DrawImpulse = GetINIValue(App.Path & "\config.ini", "OPTIONS", "DrawImpulse")

    For n = 1 To MAX_SMALL_EXPLOSIONS
        With SmallExplosion(n)
            .ParticleCount = GetINIValue(App.Path & "\config.ini", "OPTIONS", "MaxWeaponExploParticles")
            ReDim .Particle(1 To .ParticleCount)
            
            .SpreadRange = PI * 2
            .SpreadRangeOffset = 0
        
            .StartMinRadius = 0
            .EndRadius = 20
                   
            .VDeceleration = 1
                   
            .ColorMode = START_AND_INV_COLOR
            .StartColor = SetColor(50, 100, 25)
            .InvColor = SetColor(210, 210, 210)
            
            .AttenuationStartRange = 0.3
            .AttenuationSpeed = 0.01
            
            .MinParticleRadius = 0.2
            .MaxParticleRadius = 1.2
            
            .MinParticleRot = 0
            .MaxParticleRot = 0

        End With
    Next n
    
    
    For n = 1 To MAX_WALL_PUFFS
        With WallPuff(n)
            .ParticleCount = 30
            ReDim .Particle(1 To .ParticleCount)
            
            .SpreadRange = PI * 2
            .SpreadRangeOffset = 0
        
            .StartMinRadius = 30
            .EndRadius = 30
                   
            .VDeceleration = 1
                   
            .ColorMode = ONLY_START_COLOR
            .StartColor = SetColor(210, 210, 210)
            
            .AttenuationStartRange = 0.3
            .AttenuationSpeed = 0.01
            
            .MinParticleRadius = 0.5
            .MaxParticleRadius = 1.5
            
            .MinParticleRot = -0.1
            .MaxParticleRot = 0.1

        End With
    Next n
    
    For n = 1 To MAX_BIG_EXPLOSIONS
        With BigExplosion(n)
            .ParticleCount = GetINIValue(App.Path & "\config.ini", "OPTIONS", "MaxExploParticles")
            ReDim .Particle(1 To .ParticleCount)
            
            .SpreadRange = PI * 2
            .SpreadRangeOffset = 0
        
            .StartMinRadius = 0
            .StartMaxRadius = 50
            .EndRadius = 150
            
            .VDivIncreasing = True
            .VMinIncreasing = 0.2
            .VMaxIncreasing = 3
            
            .VDeceleration = 1
                    
            .ColorMode = ONLY_START_COLOR
            .StartColor = SetColor(200, 150, 100)
            
            .AttenuationStartRange = 0.3
            .AttenuationSpeed = 0.01
            
            .MinParticleRadius = 0.3
            .MaxParticleRadius = 2.3
        End With
    Next n
        
    For n = 1 To MAX_PLAYERS
        With Impulse(n)
            .ParticleCount = 150
            ReDim .Particle(1 To .ParticleCount)
            
            .Draw = True
            
            .SpreadRange = PI / 4
            .SpreadRangeOffset = 3 * HPI - .SpreadRange / 2
            
            .StartMinRadius = 0
            .EndRadius = 150
                   
            .VDeceleration = 1
                   
            .ColorMode = ONLY_START_COLOR
            .StartColor = SetColor(200, 150, 100)
            
            .AttenuationStartRange = 0.3
            .AttenuationSpeed = 0.01
            
            .MinParticleRadius = 0.3
            .MaxParticleRadius = 1.2
            
            .InfiniteSpread = True
        End With
    Next n
    
    For n = 1 To MAX_RESPAWN_EFFECTS
        With RespawnEffect(n)
            .ParticleCount = 100
            ReDim .Particle(1 To .ParticleCount)
            
            .SpreadRange = PI * 2
            .SpreadRangeOffset = 0
            
            .StartMinRadius = 0
            .StartMaxRadius = 50
            .EndRadius = -100
            
            .VDeceleration = 1
                   
            .ColorMode = ONLY_START_COLOR
            .StartColor = SetColor(255, 255, 255)
            
            .AttenuationStartRange = 0.3
            .AttenuationSpeed = 0.01
            .AttenuationExpMode = True
            
            .MinParticleRadius = 0.7
            .MaxParticleRadius = 2
        End With
    Next n
    
    For n = 1 To MAX_WAVE_EXPLOSIONS
        With ExplosionWave(n)
            .ParticleCount = 500
            ReDim .Particle(1 To .ParticleCount)
            
            .SpreadRange = PI * 2
            .SpreadRangeOffset = 0
        
            .StartMinRadius = 0
            .EndRadius = 300
            
            .VDeceleration = 0.97
            .VDecelThreshold = 0.4
                    
            .ColorMode = ONLY_START_COLOR
            .StartColor = SetColor(100, 120, 200)
            
            .AttenuationStartRange = 0.3
            .AttenuationSpeed = 0.004
            
            .MinParticleRadius = 0.3
            .MaxParticleRadius = 1
            
            .MinParticleRot = -0.1
            .MaxParticleRot = 0.1
            
        End With
    Next n
        
    Load_Texture g_App.Path_Pics & "\effect01.bmp", EffectTexture(1)
    Load_Texture g_App.Path_Pics & "\effect02.bmp", EffectTexture(2)
    
    Load_Texture g_App.Path_Pics & "\light.bmp", LightTexture
    
    With WeaponLight
        
        .Draw = True
    
        .Radius = 150
        
        .AttenuationSpeed = 0
        
        .VDeceleration = 1
               
        .Color = SetColor(255, 255, 255)
        .Intensity = 1
    End With
    
    
    For n = 1 To MAX_SMALL_EXPLOSIONS
        With WeaponExploLight(n)
        
            .Radius = 200
            
            .AttenuationSpeed = 0.01
            
            .VDeceleration = 1
                   
            .Color = SetColor(255, 150, 100)
            .Intensity = 1
        End With
    Next n
    
    For n = 1 To MAX_BIG_EXPLOSIONS
        With ShipExploLight(n)
        
            .Radius = 800
            
            .AttenuationSpeed = 0.005
            
            .VDeceleration = 1
                   
            .Color = SetColor(255, 150, 100)
            .Intensity = 2
        End With
    Next n
    
    For n = 1 To MAX_RESPAWN_EFFECTS
        With RespawnLight(n)
        
            .Radius = 400
            
            .AttenuationSpeed = 0.01
            
            .VDeceleration = 1
                   
            .Color = SetColor(255, 255, 255)
            .Intensity = 2
        End With
    Next n
    
End Sub


Public Sub InitWaves()
    Dim n As Long
    
    For n = 1 To 5
        With Wave(n)
            .WaveCount = 1
            
            .c = 0.4
            
            .Amplitude = 1
            
            .WaveLength = 3
            
        End With
    Next n

End Sub

'zeichnet alle Waffenlichter
Public Sub Draw_Weapon_Lights()

    Dim n       As Long
    Dim m       As Long
    Dim RX      As Long
    Dim RY      As Long
    
    For n = 1 To g_PlrCnt
        For m = 1 To NUM_WARHEADS_PER_PLAYER
            With g_Plr(n).WarHead(m)
                If .Draw Then
                    If IsInRectSng(g_Map.Wnd, .VX, .VY, .Anim.FrameWidth, g_WeaponSurf(.SurfNum).Height) Then
                        
                        SetLight WeaponLight, 0, .VX + .Anim.FrameWidth * 0.5, .VY + g_WeaponSurf(.SurfNum).Height * 0.5
                        WeaponLight.Color = g_WeaponType(.Type).LightColor
                        DrawLight WeaponLight, EffectTexture(1)
                        
                    End If
                End If
            End With
        Next
    Next

End Sub
