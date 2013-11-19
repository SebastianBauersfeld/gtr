Attribute VB_Name = "gme_02_Loading"
Option Explicit

Public Sub InitDDraw()

    Set g_DD = g_DX.DirectDrawCreate("")
    
    g_DD.SetCooperativeLevel frmMain.hWnd, DDSCL_FULLSCREEN Or DDSCL_EXCLUSIVE
    g_DD.SetDisplayMode ResolutionX, ResolutionY, 16, 0, DDSDM_DEFAULT
    
    PrimaryBuffer.lFlags = DDSD_BACKBUFFERCOUNT Or DDSD_CAPS
    PrimaryBuffer.ddsCaps.lCaps = DDSCAPS_COMPLEX Or DDSCAPS_FLIP Or DDSCAPS_PRIMARYSURFACE Or DDSCAPS_VIDEOMEMORY Or DDSCAPS_3DDEVICE
    PrimaryBuffer.lBackBufferCount = 1
    Set Primary = g_DD.CreateSurface(PrimaryBuffer)
    
    Dim Caps As DDSCAPS2
    Caps.lCaps = DDSCAPS_BACKBUFFER
    Set BackBuffer = Primary.GetAttachedSurface(Caps)
    
    Set DDI = g_DD.GetDeviceIdentifier(DDGDI_DEFAULT)
    BackBuffer.SetForeColor RGB(255, 255, 255)
    
End Sub


Public Sub InitD3D()
    Dim i As Long

    Set D3D = g_DD.GetDirect3D
    Set g_D3DDev = D3D.CreateDevice("IID_IDirect3DHALDevice", BackBuffer)
        
    '=========================== Z-Buffer ===========================
    Set GetZBuffer = D3D.GetEnumZBufferFormats("IID_IDirect3DHALDevice")
     
    For i = 1 To GetZBuffer.GetCount()
        Call GetZBuffer.GetItem(i, PixFMTZBuffer)
        If PixFMTZBuffer.lFlags = DDPF_ZBUFFER Then Exit For
    Next
    
    PrimaryZBuffer.lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT Or DDSD_PIXELFORMAT
    PrimaryZBuffer.ddsCaps.lCaps = DDSCAPS_ZBUFFER 'Or DDSCAPS_VIDEOMEMORY
    PrimaryZBuffer.lWidth = ResolutionX
    PrimaryZBuffer.lHeight = ResolutionY
    PrimaryZBuffer.ddpfPixelFormat = PixFMTZBuffer
    
    Set ZBuffer = g_DD.CreateSurface(PrimaryZBuffer)
    BackBuffer.AddAttachedSurface ZBuffer
    
                            'Value des ZBuffers 0=OFF; 1=low Quality; 2=high Quality
    g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 2
    '================================================================
    
    ResolutionX = 1024
    ResolutionY = 768

End Sub



'=== Direct Sound-Initialisierung =====================================================
Public Sub InitDSound()

'Direct Sound initialisieren
Set DS7 = g_DX.DirectSoundCreate("")
DS7.SetCooperativeLevel frmMain.hWnd, DSSCL_PRIORITY

'Einstellungsmöglichkeiten
BufferDesc.lFlags = DSBCAPS_CTRLFREQUENCY Or DSBCAPS_CTRLPAN Or DSBCAPS_CTRLVOLUME Or DSBCAPS_STATIC

End Sub
'=======================================================================================


Public Sub LoadWave(iBuffer As DirectSoundBuffer, sfile As String)
         
    BufferDesc.lFlags = DSBCAPS_CTRLFREQUENCY Or DSBCAPS_CTRLPAN Or DSBCAPS_CTRLVOLUME Or DSBCAPS_STATIC
    
    Set iBuffer = DS7.CreateSoundBufferFromFile(SoundPath & sfile, BufferDesc, WaveFormat)

End Sub


Sub InitDirectInput()
    
    HasJoyStick = True

    Set DI = g_DX.DirectInputCreate()
    Set DIDevEnum = DI.GetDIEnumDevices(DIDEVTYPE_JOYSTICK, DIEDFL_ATTACHEDONLY)
    If DIDevEnum.GetCount = 0 Then
      HasJoyStick = False
      Exit Sub
    End If
    
    JoyName = DIDevEnum.GetItem(1).GetInstanceName
    
    EventHandle = g_DX.CreateEvent(frmMain)
    
    Set DIDev = Nothing
    Set DIDev = DI.CreateDevice(DIDevEnum.GetItem(1).GetGuidInstance)
    DIDev.SetCommonDataFormat DIFORMAT_JOYSTICK
    DIDev.SetCooperativeLevel frmMain.hWnd, DISCL_BACKGROUND Or DISCL_NONEXCLUSIVE
    
    DIDev.GetCapabilities JoyCaps
    
    DIDev.SetEventNotification EventHandle

    With DIProp_Range
        .lHow = DIPH_DEVICE
        .lSize = Len(DIProp_Range)
        .lMin = -5000
        .lMax = 5000
    End With
    DIDev.SetProperty "DIPROP_RANGE", DIProp_Range
    
    DIDev.Acquire
       
End Sub



'=== Sub um Texturen zu laden ========================================================
Public Sub subLoadTexture(ByRef File As String, ByRef Texture As DirectDrawSurface7)
    Dim Surface As DDSURFACEDESC2
    Dim TextureEnum As Direct3DEnumPixelFormats
    
    Set TextureEnum = g_D3DDev.GetTextureFormatsEnum()
    TextureEnum.GetItem 1, Surface.ddpfPixelFormat
    Surface.ddsCaps.lCaps = DDSCAPS_TEXTURE
    
    Set Texture = g_DD.CreateSurfaceFromFile(PicturePath & File, Surface)
End Sub
'=====================================================================================

