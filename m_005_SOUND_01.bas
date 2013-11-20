Attribute VB_Name = "m_007_SOUND_01"
Option Explicit

Private SBufDesc                        As DSBUFFERDESC
Private SWaveFormat                     As WAVEFORMATEX

'Initialisiert DirectSound und gibt zurück ob Vorgang erfolgreich war
Public Function Init_DS() As Boolean
    
    On Error GoTo error:
    
    Set g_DS = g_DX.DirectSoundCreate("")
    g_DS.SetCooperativeLevel frmMain.hWnd, DSSCL_PRIORITY
    
    With SWaveFormat
        .nFormatTag = WAVE_FORMAT_PCM
        .nChannels = 10
        .lSamplesPerSec = 22050
        .nBitsPerSample = 16
        .nBlockAlign = .nBitsPerSample / 8 * .nChannels
        .lAvgBytesPerSec = .lSamplesPerSec * .nBlockAlign
    End With
    
    'Einstellungsmöglichkeiten
    SBufDesc.lFlags = DSBCAPS_CTRLFREQUENCY Or DSBCAPS_CTRLPAN Or DSBCAPS_CTRLVOLUME Or DSBCAPS_STATIC
    
    Init_DS = True
    Exit Function
    
error:
    Init_DS = False

End Function

'fährt DirectSound herunter
Public Sub Unload_DS()
    
    g_DS.SetCooperativeLevel frmMain.hWnd, DSSCL_NORMAL
    
    Set g_DS = Nothing

End Sub

'lädt einen Soundbuffer in den Speicher
Public Function Load_SBuf(ByVal Path As String, ByRef SBuf As DirectSoundBuffer) As Boolean

    On Error GoTo error:
    
    Set SBuf = g_DS.CreateSoundBufferFromFile(Path, SBufDesc, SWaveFormat)
    
    With SBuf
        .SetVolume 0
        .SetPan 0
        .SetCurrentPosition 0
    End With
    
    Load_SBuf = True
    Exit Function
    
error:
    Load_SBuf = False

End Function

'dupliziert einen Soundbuffer
Public Function Duplicate_SBuf(ByRef SBuf As DirectSoundBuffer, ByRef OriginalSBuf As DirectSoundBuffer) As Boolean

    On Error GoTo error:
    
    Set SBuf = g_DS.DuplicateSoundBuffer(OriginalSBuf)
    
    Duplicate_SBuf = True
    Exit Function
    
error:
    Duplicate_SBuf = False

End Function

'löscht einen SoundBuffer aus dem Speicher
Public Sub Unload_SBuf(ByRef SBuf As DirectSoundBuffer)

    Set SBuf = Nothing

End Sub

'Setzt die Eigenschaften eines SoundBuffers (Speed geht von 0 bis 1)
Public Sub Init_SBuf(ByRef SBuf As DirectSoundBuffer, Optional ByVal Volume As Long = 1, Optional ByVal Pan As Long = 10001, Optional ByVal Speed As Single = 1)
    
    Dim h_WaveFormatEx       As WAVEFORMATEX
    
    With SBuf
        If Volume <= 0 Then
            If Volume < -10000 Then Volume = -10000
            .SetVolume Volume
        End If
        
        If Pan <= 10000 Then
            If Pan < -10000 Then Pan = -10000
            .SetPan Pan
        End If
        
        'Frequenz errechnen
        .GetFormat h_WaveFormatEx
        .SetFrequency h_WaveFormatEx.lSamplesPerSec * Speed
    End With
    
End Sub

'Setzt die Eigenschaften für einen Stereo-Sound (Speed geht von 0 bis 1)
Public Sub Init_Stereo_SBuf(ByRef SBuf As DirectSoundBuffer, ByVal SrcX As Long, ByVal SrcY As Long, ByVal ListenerX As Long, ByVal ListenerY As Long, Optional ByVal Speed As Single = 1)
    
    Dim h_Dist              As Long
    Dim h_Volume            As Long
    Dim h_Pan               As Long
    Dim h_WaveFormatEx      As WAVEFORMATEX
    
    With SBuf
        'Lautstärke errechnen
        h_Dist = PythA(ListenerX - SrcX, ListenerY - SrcY)
        h_Volume = -(h_Dist * SOUND_DISTANCE_FACTOR)
        
        If h_Volume < -10000 Then h_Volume = -10000
        .SetVolume h_Volume
        
        'Pan errechnen
        h_Pan = SrcX - ListenerX
        
        If h_Pan < -10000 Then
            h_Pan = -10000
        ElseIf h_Pan > 10000 Then
            h_Pan = 10000
        End If
                    
        .SetPan h_Pan
        
        'Frequenz errechnen
        .GetFormat h_WaveFormatEx
        .SetFrequency h_WaveFormatEx.lSamplesPerSec * Speed
    End With

End Sub

'Spielt einen Sound ab
Public Sub Play_SBuf(ByRef SBuf As DirectSoundBuffer, Optional ByVal LoopSBuf As Boolean = False)

    With SBuf
        If (.GetStatus And (DSBSTATUS_PLAYING Or _
        DSBSTATUS_LOOPING)) = 0 Then
        
            If LoopSBuf Then           'ob der Sound geloopt werden soll
                .Play DSBPLAY_LOOPING
            Else
                .Play DSBPLAY_DEFAULT
            End If
        
        End If
    End With
    
End Sub

'Stoppt einen laufenden Sound
Public Sub Stop_SBuf(ByRef SBuf As DirectSoundBuffer)
    
    On Error Resume Next
    
    With SBuf
        If (.GetStatus And DSBSTATUS_PLAYING) Then .Stop
    End With
        
End Sub
