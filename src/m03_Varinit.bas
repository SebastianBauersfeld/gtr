Attribute VB_Name = "mnu_m03_Varinitiate"
Option Explicit

Public Sub subInitMenuVariables()
    Dim n As Long
    Dim m As Long
               
    '============= 3D-Render-Bereich deklarieren =============
    ViewPort.lX = 0
    ViewPort.lY = 0
    ViewPort.lWidth = ResolutionX
    ViewPort.lHeight = ResolutionY
    g_D3DDev.SetViewport ViewPort
    
    
    With RectViewport(0)
        .X1 = 0
        .Y1 = 0
        .X2 = ResolutionX
        .Y2 = ResolutionY
    End With
    '=========================================================
        
    '============== BildschirmPosition setzen ==============
    g_DX.IdentityMatrix matView
                              ' von wo(X, Y,   Z), wo hingucken   , Lage der 3DWelt, Rotation des Screens um Z-Achse in Rad
    Call g_DX.ViewMatrix(matView, Vector(0, 0, -30), Vector(0, 0, 0), Vector(0, 1, 0), 0)
    
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
    '=======================================================
      
    '============= Projektion der 3D-Welt festlegen =============
    g_DX.IdentityMatrix matProj
                                    ' Mindestentfernung
                                       ' Maximumentfernung
                                             ' Blickweite
    Call g_DX.ProjectionMatrix(matProj, 1, 5000, PI / 3)
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_PROJECTION, matProj
    
    g_D3DDev.SetRenderTarget BackBuffer
    '============================================================
    
    '=====================================================
    '============ weitere EngineEinstellungen ============
    g_D3DDev.SetRenderState D3DRENDERSTATE_CULLMODE, D3DCULL_NONE   'beide Seiten der Polys sollen gezeichnet werden
    g_D3DDev.SetRenderState D3DRENDERSTATE_FILLMODE, 3              'ob Points, Wireframe oder gefüllt

    '====== Materialdeklaration (für Licht) ======
    g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 2
    
    Material.diffuse.r = 1
    Material.diffuse.g = 1
    Material.diffuse.b = 1
    Material.diffuse.a = 1

    Material.Ambient.r = 1
    Material.Ambient.g = 1
    Material.Ambient.b = 1
    Material.Ambient.a = 1

    Material.specular.r = 1
    Material.specular.g = 1
    Material.specular.b = 1
    Material.specular.a = 1
    '=============================================
        
    'Vergrößerung:
    TextureMagFilter = D3DTFG_LINEAR
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, TextureMagFilter
    '=====================================================
    '=====================================================
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_SHADEMODE, 0
    
           
    '===Colorkeys und Farben================'===============================================
    CKeyB.low = 0                   'ColorkeyDefinition (die Farbe die unsichtbar ist) hier Schwarz
    CKeyB.high = 0
    CKeyW.low = RGB(255, 255, 255)  'ColorkeyDefinition (die Farbe die unsichtbar ist) hier Weiß
    CKeyW.high = RGB(255, 255, 255)
    '=======================================================================================


    'D3D-UmrechnungsVariablen =======================================================
    D3DDivX = 29.6
    D3DDivY = 22.1
    D3DSubX = -17.3
    D3DSubY = 17.4
    
    '=== Licht-Deklarationen ======================
    g_D3DDev.SetRenderState D3DRENDERSTATE_SHADEMODE, D3DSHADE_GOURAUD
    g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(0, 0, 0)
    g_D3DDev.SetRenderState D3DRENDERSTATE_DITHERENABLE, 1
    
    Material.emissive.r = 0
    Material.emissive.g = 0
    Material.emissive.b = 0
    Material.emissive.a = 0
        
    Material.Power = 20
    
    g_D3DDev.SetMaterial Material
    
    LightColor.r = 0.2
    LightColor.g = 0.5
    LightColor.b = 1
    
    For n = 0 To 4
        With Menu3DStar(n)
            .Light.diffuse = LightColor
            .Light.specular = LightColor
            .Light.Ambient = LightColor
            .Light.attenuation1 = 1
            .Light.dltType = D3DLIGHT_POINT
            .Light.position = Vector(0, -3, 0)
            .Light.range = 40
            g_D3DDev.SetLight n, .Light
            g_D3DDev.LightEnable n, True
        End With
    Next
    
    LightColor.r = 10
    LightColor.g = 10
    LightColor.b = 10
    MainMenu.Light.phi = 0.5
    MainMenu.Light.theta = 0.4
    MainMenu.Light.falloff = 1
    MainMenu.Light.diffuse = LightColor
    MainMenu.Light.specular = LightColor
    MainMenu.Light.Ambient = LightColor
    MainMenu.Light.attenuation1 = 1
    MainMenu.Light.dltType = D3DLIGHT_SPOT
    MainMenu.Light.position = Vector(0, 0, 0)
    MainMenu.Light.direction = Vector(0.3, 1, 10)
    MainMenu.Light.range = 100
    g_D3DDev.SetLight 5, MainMenu.Light
    g_D3DDev.LightEnable 5, True
    '============================================
        
    '=== 3D-Zeichen werden generiert ========================================
    With GTR3D
        .VertexCount = 0
        CHAR_G .VertexCount, 2, 2.4, 2, -2.5, -7, 5    '498 Vertices
        CHAR_T .VertexCount, 2, 2.4, 2, -2.5, -2, 5    '150 Vertices
        CHAR_R .VertexCount, 2, 2.4, 2, -2.5, 3, 5     '618 Vertices
        CHAR_RING .VertexCount, 2, 2.4, 2, 0, 0, 5     '744 Vertices
        .PosX = 0
        .PosY = -2.5
        .PosZ = 5
        .TargetX = .PosX
        .TargetY = .PosY
        .TargetZ = .PosZ
        '    .TargetX = -80
        '    .TargetY = 70
        '    .TargetZ = 150
        .Speed = 0.003
        .RotationMitte.X = 0     'um welchen Punkt
        .RotationMitte.Y = 0     'die Polygone sich
        .RotationMitte.Z = 11    'drehen sollen
    End With
    '========================================================================
    
    '=== Menu3DStar ===============================================================
    For n = 0 To 4
        With Menu3DStar(n)
            .X = Rnd * 32 - 16
            .Y = Rnd * 24 - 12
            .Z = Rnd * 20 - 10
            
            .TargetX = 0
            .TargetY = 0
            .TargetZ = 5
            
            .Vertex(0).tu = 0
            .Vertex(0).tv = 0
            .Vertex(1).tu = 1
            .Vertex(1).tv = 0
            .Vertex(2).tu = 0
            .Vertex(2).tv = 1
            .Vertex(3).tu = 0
            .Vertex(3).tv = 1
            .Vertex(4).tu = 1
            .Vertex(4).tv = 0
            .Vertex(5).tu = 1
            .Vertex(5).tv = 1
        End With
    Next
    '========================================================================
    
    '=== MainMenu ===========================================================
    With MainMenu
        .Choise.Height = 315
        .Choise.Width = 300
        .Choise.Rectangle.Top = 0
        .Choise.Rectangle.Bottom = .Choise.Height
        .Choise.Rectangle.Left = 0
        .Choise.Rectangle.Right = .Choise.Width
        .Choise.X = (ResolutionX - .Choise.Width) / 2
        .Choise.Y = ResolutionY
        .FadeSpeed = 0.04
        .MotionSpeed = 40
        .MoveY = -.MotionSpeed
        '    .MenuStatus = Options
        .MenuStatus = MainM
        .Quit = False
        
        .CamZ = -5000
        .FadeFromBlack = 0
        
        .StartGame = False
        .ItsMulti = False
        .StartCredits = False
        .StartIntro = True
    End With
    '========================================================================
    
    '=== SubMenu ========================================================
    With SubMenu
        .PosX = 1
        .TargetX = 0.7
        '    .TargetX = -0.5
        .MenuStatus = S_Misc
        .Vertex(0).X = 1.25: .Vertex(0).Y = 0.4:    .Vertex(0).Z = -29
        .Vertex(1).X = 2.08: .Vertex(1).Y = 0.4:    .Vertex(1).Z = -29
        .Vertex(2).X = 2.08: .Vertex(2).Y = -0.58:  .Vertex(2).Z = -29
        .Vertex(3).X = 1.25: .Vertex(3).Y = 0.4:    .Vertex(3).Z = -29
        .Vertex(4).X = 1:    .Vertex(4).Y = 0.1:    .Vertex(4).Z = -29
        .Vertex(5).X = 2.08: .Vertex(5).Y = -0.58:  .Vertex(5).Z = -29
        .Vertex(6).X = 1:    .Vertex(6).Y = -0.58:  .Vertex(6).Z = -29
        .Vertex(7).X = 1:    .Vertex(7).Y = 0.1:    .Vertex(7).Z = -29
        .Vertex(8).X = 2.08: .Vertex(8).Y = -0.58:  .Vertex(8).Z = -29
        
        .DDLine(0, 0) = ResolutionX: .DDLine(0, 1) = 118
        .DDLine(1, 0) = 290: .DDLine(1, 1) = 118
        .DDLine(2, 0) = 69: .DDLine(2, 1) = 318
        .DDLine(3, 0) = 69: .DDLine(3, 1) = ResolutionY
    End With
    '========================================================================
    
    '=== MainMenuControl ====================================================
    With MainMenu.Control
        .Height = 20
        .Width = 60
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
        .X = ResolutionX - .Width
        .Y = 0
    End With
    '========================================================================
    
    '=== Hintergrundsterne =================================================================
    With MainMenuBackStars
        
        For n = 0 To MAX_MENU_BACKSTARS
            For m = 0 To 2
                .RX(m, n) = Rnd * ResolutionX
                .RY(m, n) = Rnd * ResolutionY
            Next
        Next
        
        .Color(0) = 65535   'Sternfarbe1 setzen
        .Color(1) = 38100   'Sternfarbe2 setzen
        .Color(2) = 17100   'Sternfarbe3 setzen
        
    End With
    '=======================================================================================
    
    '======================== Polygone erstellen ========================
    For n = 1 To MAX_MENU_MOUSEPARTICLES
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, MenuMouseParticle(n).Vertex(1)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0, MenuMouseParticle(n).Vertex(2)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, MenuMouseParticle(n).Vertex(3)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 1, MenuMouseParticle(n).Vertex(4)
        GenerateMouseStar CInt(n)
    Next
    '====================================================================
    
    
    '=== Fade ===================================
    g_DX.CreateD3DVertex -2, 2, 1, 0, 0, -1, 0, 0, FadeVertex(1)
    g_DX.CreateD3DVertex 2, 2, 1, 0, 0, -1, 0, 0, FadeVertex(2)
    g_DX.CreateD3DVertex -2, -2, 1, 0, 0, -1, 0, 0, FadeVertex(3)
    g_DX.CreateD3DVertex 2, -2, 1, 0, 0, -1, 0, 0, FadeVertex(4)
    
    MenuMouseParticleRadius = 0.4
    MenuMouseParticleCounter = 1
    
    '=== Checkbox ====================================================
    With CheckBox
        .Height = 20
        .Width = 20
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
    End With
    '=================================================================
    
    '=== Scroller ====================================================
    With Scroller
        .Height = 21
        .Width = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
    End With
    '=================================================================
    
    '=== KeyInput ====================================================
    With KeyInput
        .CTRLDisc(1) = "Accelerate"
        .CTRLDisc(2) = "Turn left"
        .CTRLDisc(3) = "Turn right"
        .CTRLDisc(4) = "Fire"
        .CTRLDisc(5) = "Weapon 1"
        .CTRLDisc(6) = "Weapon 2"
        .CTRLDisc(7) = "Weapon 3"
        .CTRLDisc(8) = "Next Weapon"
        .CTRLDisc(9) = "Previous Weapon"
        .CTRLDisc(10) = "Recover"
        .CTRLDisc(11) = "Take Screenshot"
        .CTRLDisc(12) = "Toggle Scores"
        .CTRLDisc(13) = "Chat Message"
        .CTRLDisc(14) = "Team Message"
        .CTRLDisc(15) = "Toggle Target"
    End With
    '=================================================================
    
    PNameTextBox.InUse = False
    
    '=== KeyDefinitionen =============================================
    KeyStr(8) = "Backspace"
    KeyStr(9) = "Tab"
    KeyStr(13) = "Return"
    KeyStr(16) = "Shift"
    KeyStr(17) = "Ctrl"
    KeyStr(18) = "Alt"
    KeyStr(20) = "Caps Lock"
    KeyStr(27) = "ESC"
    KeyStr(32) = "Space"
    KeyStr(33) = "Page Up"
    KeyStr(34) = "Page Down"
    KeyStr(35) = "End"
    KeyStr(36) = "Home"
    KeyStr(37) = "Key Left"
    KeyStr(38) = "Key Up"
    KeyStr(39) = "Key Right"
    KeyStr(40) = "Key Down"
    KeyStr(45) = "Insert"
    KeyStr(46) = "Delete"
    KeyStr(48) = "0"
    KeyStr(49) = "1"
    KeyStr(50) = "2"
    KeyStr(51) = "3"
    KeyStr(52) = "4"
    KeyStr(53) = "5"
    KeyStr(54) = "6"
    KeyStr(55) = "7"
    KeyStr(56) = "8"
    KeyStr(57) = "9"
    KeyStr(65) = "A"
    KeyStr(66) = "B"
    KeyStr(67) = "C"
    KeyStr(68) = "D"
    KeyStr(69) = "E"
    KeyStr(70) = "F"
    KeyStr(71) = "G"
    KeyStr(72) = "H"
    KeyStr(73) = "I"
    KeyStr(74) = "J"
    KeyStr(75) = "K"
    KeyStr(76) = "L"
    KeyStr(77) = "M"
    KeyStr(78) = "N"
    KeyStr(79) = "O"
    KeyStr(80) = "P"
    KeyStr(81) = "Q"
    KeyStr(82) = "R"
    KeyStr(83) = "S"
    KeyStr(84) = "T"
    KeyStr(85) = "U"
    KeyStr(86) = "V"
    KeyStr(87) = "W"
    KeyStr(88) = "X"
    KeyStr(89) = "Y"
    KeyStr(90) = "Z"
    KeyStr(91) = "LWindow Key"
    KeyStr(92) = "RWindow Key"
    KeyStr(93) = "App Key"
    KeyStr(96) = "Numpad 0"
    KeyStr(97) = "Numpad 1"
    KeyStr(98) = "Numpad 2"
    KeyStr(99) = "Numpad 3"
    KeyStr(100) = "Numpad 4"
    KeyStr(101) = "Numpad 5"
    KeyStr(102) = "Numpad 6"
    KeyStr(103) = "Numpad 7"
    KeyStr(104) = "Numpad 8"
    KeyStr(105) = "Numpad 9"
    KeyStr(106) = "Numpad *"
    KeyStr(107) = "Numpad +"
    KeyStr(109) = "Numpad -"
    KeyStr(110) = "Numpad ,"
    KeyStr(111) = "Numpad /"
    KeyStr(112) = "F1"
    KeyStr(113) = "F2"
    KeyStr(114) = "F3"
    KeyStr(115) = "F4"
    KeyStr(116) = "F5"
    KeyStr(117) = "F6"
    KeyStr(118) = "F7"
    KeyStr(119) = "F8"
    KeyStr(120) = "F9"
    KeyStr(121) = "F10"
    KeyStr(122) = "F11"
    KeyStr(123) = "F12"
    KeyStr(124) = "F13"
    KeyStr(125) = "F14"
    KeyStr(126) = "F15"
    KeyStr(127) = "F16"
    KeyStr(144) = "Num Lock"
    KeyStr(145) = "Scroll Lock"
    KeyStr(186) = "Ü"
    KeyStr(187) = "+"
    KeyStr(188) = ","
    KeyStr(189) = "-"
    KeyStr(190) = "."
    KeyStr(191) = "#"
    KeyStr(219) = "ß"
    KeyStr(220) = "^"
    KeyStr(221) = "´"
    KeyStr(222) = "Ä"
    KeyStr(226) = "<"
    '=================================================================
    
    'JoyStick
    For n = 0 To 31
        JoyButtonStr(n) = "Joy Button " & n
    Next
    JoyButtonStr(32) = "Joy Left"
    JoyButtonStr(33) = "Joy Right"
    JoyButtonStr(34) = "Joy Up"
    JoyButtonStr(35) = "Joy Down"
    
    
    '=== Flyers ======================================================
    With Flyers
        .Count = MaxShips
    End With
    
    subLoadShipProperties
    '=================================================================
    
    '=== FlyerListBox ================================================
    With FlyerBox
        .Width = 21
        .Height = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
        
        .LoadFlyer = True
    End With
    
    With FlyerBox.Flyer
        .Width = 1920
        .Height = 48
    
        .Rectangle.Left = 0
        .Rectangle.Right = 48
        .Rectangle.Top = 0
        .Rectangle.Bottom = 48
    End With
    '=================================================================
    
    '=== ServerListBox ================================================
    With ServerListBox
        ReDim .List(1 To 100)
        .Start = 1
        .Width = 21
        .Height = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
        
        .Selected = 1
        .ListCount = 0
    End With
    '=================================================================
    
    '=== MapListBox ================================================
    Dim TMPDir As Variant
    With MapListBox
        ReDim .List(0 To 10)
        .Start = 1
        .Width = 21
        .Height = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
        
        .Selected = 1
        
        n = 1
        TMPDir = Dir(MapPath & "*.gmf")
        Do
            If n > UBound(.List) Then ReDim Preserve .List(UBound(.List) + 10)
            .List(n) = TMPDir
            .List(n) = Left(.List(n), Len(.List(n)) - 4)
            n = n + 1
            TMPDir = Dir
        Loop Until TMPDir = vbNullString
        
        .ListCount = n - 1
    End With
    '=================================================================
    
    '=== MessageListBox ==============================================
    With MessageListBox
        ReDim .List(0 To 10)
        .Start = 1
        .Width = 21
        .Height = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
        
        .Selected = 1
        
        .ListCount = 0
    End With
    '=================================================================
    
    '=== TargetGUI ====================================================
    With TargetGUI
        .Height = 21
        .Width = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
    End With
    '=================================================================
    
    GameMode(1) = "DM"
    GameMode(2) = "TDM"
    GameMode(3) = "CTF"
    GameMode(4) = "RAC"
    GameMode(5) = "OMA"
    
    '=== GameModeList ================================================
    With GameModeList
        ReDim .List(0 To 1)
        .Start = 1
        .Width = 21
        .Height = 21
        .Rectangle.Top = 0
        .Rectangle.Bottom = .Height
        .Rectangle.Left = 0
        .Rectangle.Right = .Width
        
        .Selected = 1
        
        .ListCount = 0
        
        .List(1) = "Death Match"
        '.List(2) = "Team Death Match"
        '.List(3) = "Capture The Flag"
        '.List(4) = "Race"
        '.List(5) = "O.M.A."
    End With
    '=================================================================
    
    FadetoCredits = 1
    
    
        
    'Netzeinstellungen
    BroadCastTextBox.Text = fctGetIniValue("Server", "BroadCast")
    IsOnline = OnlineConnection
    
End Sub


'lädt die Schiffeinstellungen
Public Sub subLoadShipProperties()

    Dim n           As Long
    Dim FileNum     As Integer
    
    FileNum = FreeFile

    Open App.Path & "\ships.cfg" For Binary As FileNum
        
        For n = 1 To MaxShips
            With FlyerProps(n)
                Get FileNum, , .TypeName
                Get FileNum, , .Description
                Get FileNum, , .Weight
                Get FileNum, , .Acceleration
                Get FileNum, , .MaxSpeed
                Get FileNum, , .SteerSpeed
                Get FileNum, , .Shields
                Get FileNum, , .CannonGap
            End With
        Next n
    
    Close FileNum

End Sub

Public Sub subLoadVariables()

    'Pfade
    PicturePath = App.Path & "\pictures\"
    SoundPath = App.Path & "\sounds\"
    MapPath = App.Path & "\maps\"
    ScreenShotPath = App.Path & "\screenshots\"
    FontPath = App.Path & "\fonts\"

    fctSetIniValue "Server", "BroadCast", GetBroadCast
    '======================================

    'Optionen

    DrawFPS = CBool(fctGetIniValue("Options", "DrawFPS"))
    DrawBackStars = CBool(fctGetIniValue("Options", "DrawBackStars"))
    DrawRespawnEffect = CBool(fctGetIniValue("Options", "DrawRespawnEffect"))
    UseShockWaves = CBool(fctGetIniValue("Options", "UseShockWaves"))
    UseLights = CBool(fctGetIniValue("Options", "UseLights"))
    DrawImpulse = CBool(fctGetIniValue("Options", "DrawImpulse"))
    
    CMaxExploParts = CInt(fctGetIniValue("Options", "MaxExploParticles"))
    CMaxWExploParts = CInt(fctGetIniValue("Options", "MaxWeaponExploParticles"))
    CMaxBackStars(1) = CInt(fctGetIniValue("Options", "MaxBackStars1"))
    CMaxBackStars(2) = CInt(fctGetIniValue("Options", "MaxBackStars2"))
    CMaxBackStars(3) = CInt(fctGetIniValue("Options", "MaxBackStars3"))
    
    AveragePing = CInt(fctGetIniValue("Options", "AveragePing"))
    
    With HUDColor
        .r = StrToSng(fctGetIniValue("OPTIONS", "HUDR"))
        .g = StrToSng(fctGetIniValue("OPTIONS", "HUDG"))
        .b = StrToSng(fctGetIniValue("OPTIONS", "HUDB"))
        .T = StrToSng(fctGetIniValue("OPTIONS", "HUDT"))
    End With
    
    CTargetGUI = CInt(fctGetIniValue("Options", "TargetGUI"))
    
    DrawKillBoard = CBool(fctGetIniValue("Options", "DrawKillBoard"))
    DrawMsgBoard = CBool(fctGetIniValue("Options", "DrawMsgBoard"))
       
    'TastenEinstellungen
    AscKeyUp = CInt(fctGetIniValue("KeyConfig", "ACCELERATE"))
    AscKeyLeft = CInt(fctGetIniValue("KeyConfig", "LEFT"))
    AscKeyRight = CInt(fctGetIniValue("KeyConfig", "RIGHT"))
    AscKeyFire = CInt(fctGetIniValue("KeyConfig", "FIRE"))
    AscKeyWeapon1 = CInt(fctGetIniValue("KeyConfig", "WEAPON1"))
    AscKeyWeapon2 = CInt(fctGetIniValue("KeyConfig", "WEAPON2"))
    AscKeyWeapon3 = CInt(fctGetIniValue("KeyConfig", "WEAPON3"))
    AscKeyNextWeapon = CInt(fctGetIniValue("KeyConfig", "NEXT_WEAPON"))
    AscKeyPrevWeapon = CInt(fctGetIniValue("KeyConfig", "PREVIOUS_WEAPON"))
    AscKeyRecover = CInt(fctGetIniValue("KeyConfig", "RECOVER"))
    AscKeyScreenshot = CInt(fctGetIniValue("KeyConfig", "SCREENSHOT"))
    AscKeyToggleHUD = CInt(fctGetIniValue("KeyConfig", "SCOREBOARD"))
    AscKeySay = CInt(fctGetIniValue("KeyConfig", "CHAT"))
    AscKeySayTeam = CInt(fctGetIniValue("KeyConfig", "TEAM_CHAT"))
    AscKeyToggleTarget = CInt(fctGetIniValue("KeyConfig", "TOGGLE_TARGET"))
    
    
                            JoyLeft = 32
                            JoyRight = 33
                            JoyUp = 34
                            JoyDown = 35
                            JoyFire = 0
    
    With KeyInput
        .Key(1) = AscKeyUp
        .Key(2) = AscKeyLeft
        .Key(3) = AscKeyRight
        .Key(4) = AscKeyFire
        .Key(5) = AscKeyWeapon1
        .Key(6) = AscKeyWeapon2
        .Key(7) = AscKeyWeapon3
        .Key(8) = AscKeyNextWeapon
        .Key(9) = AscKeyPrevWeapon
        .Key(10) = AscKeyRecover
        .Key(11) = AscKeyScreenshot
        .Key(12) = AscKeyToggleHUD
        .Key(13) = AscKeySay
        .Key(14) = AscKeySayTeam
        .Key(15) = AscKeyToggleTarget
    End With
    
    'PlayerEinstellungen
    PlayerName = Left(fctGetIniValue("Player", "Name"), 20)
    PNameTextBox.Text = PlayerName
    
    PlayerShip = fctGetIniValue("Player", "Ship")
    
    ServerName = Left(fctGetIniValue("Server", "Name"), 20)
    SNameTextBox.Text = ServerName
    
    BotCount = fctGetIniValue("Server", "BotNumber")
    MaxPlayers = fctGetIniValue("Server", "MaxPlayers")
    
    MapIsDestroyable = CBool(fctGetIniValue("Server", "MapDestroyable"))

    
End Sub
Public Sub subSaveVariables()
    'Optionen
    fctSetIniValue "Options", "DrawFPS", CStr(CByte(DrawFPS))
    fctSetIniValue "Options", "DrawBackStars", CStr(CByte(DrawBackStars))
    fctSetIniValue "Options", "DrawRespawnEffect", CStr(CByte(DrawRespawnEffect))
    fctSetIniValue "Options", "UseShockWaves", CStr(CByte(UseShockWaves))
    fctSetIniValue "Options", "UseLights", CStr(CByte(UseLights))
    fctSetIniValue "Options", "DrawImpulse", CStr(CByte(DrawImpulse))
    
    fctSetIniValue "Options", "MaxExploParticles", CStr(CMaxExploParts)
    fctSetIniValue "Options", "MaxWeaponExploParticles", CStr(CMaxWExploParts)
    fctSetIniValue "Options", "MaxBackStars1", CStr(CMaxBackStars(1))
    fctSetIniValue "Options", "MaxBackStars2", CStr(CMaxBackStars(2))
    fctSetIniValue "Options", "MaxBackStars3", CStr(CMaxBackStars(3))
    
    fctSetIniValue "Options", "AveragePing", CStr(AveragePing)
    
    
    With HUDColor
        fctSetIniValue "Options", "HUDR", CStr(.r)
        fctSetIniValue "Options", "HUDG", CStr(.g)
        fctSetIniValue "Options", "HUDB", CStr(.b)
        fctSetIniValue "Options", "HUDT", CStr(.T)
    End With
    
    fctSetIniValue "Options", "TargetGUI", CStr(CTargetGUI)
    
    fctSetIniValue "Options", "DrawKillBoard", CStr(CByte(DrawKillBoard))
    fctSetIniValue "Options", "DrawMsgBoard", CStr(CByte(DrawMsgBoard))
    
    'TastenEinstellungen
    With KeyInput
        AscKeyUp = .Key(1)
        AscKeyLeft = .Key(2)
        AscKeyRight = .Key(3)
        AscKeyFire = .Key(4)
        AscKeyWeapon1 = .Key(5)
        AscKeyWeapon2 = .Key(6)
        AscKeyWeapon3 = .Key(7)
        AscKeyNextWeapon = .Key(8)
        AscKeyPrevWeapon = .Key(9)
        AscKeyRecover = .Key(10)
        AscKeyScreenshot = .Key(11)
        AscKeyToggleHUD = .Key(12)
        AscKeySay = .Key(13)
        AscKeySayTeam = .Key(14)
        AscKeyToggleTarget = .Key(15)
    End With
    
    fctSetIniValue "KeyConfig", "ACCELERATE", CStr(AscKeyUp)
    fctSetIniValue "KeyConfig", "LEFT", CStr(AscKeyLeft)
    fctSetIniValue "KeyConfig", "RIGHT", CStr(AscKeyRight)
    fctSetIniValue "KeyConfig", "FIRE", CStr(AscKeyFire)
    fctSetIniValue "KeyConfig", "WEAPON1", CStr(AscKeyWeapon1)
    fctSetIniValue "KeyConfig", "WEAPON2", CStr(AscKeyWeapon2)
    fctSetIniValue "KeyConfig", "WEAPON3", CStr(AscKeyWeapon3)
    fctSetIniValue "KeyConfig", "NEXT_WEAPON", CStr(AscKeyNextWeapon)
    fctSetIniValue "KeyConfig", "PREVIOUS_WEAPON", CStr(AscKeyPrevWeapon)
    fctSetIniValue "KeyConfig", "RECOVER", CStr(AscKeyRecover)
    fctSetIniValue "KeyConfig", "SCREENSHOT", CStr(AscKeyScreenshot)
    fctSetIniValue "KeyConfig", "SCOREBOARD", CStr(AscKeyToggleHUD)
    fctSetIniValue "KeyConfig", "CHAT", CStr(AscKeySay)
    fctSetIniValue "KeyConfig", "TEAM_CHAT", CStr(AscKeySayTeam)
    fctSetIniValue "KeyConfig", "TOGGLE_TARGET", CStr(AscKeyToggleTarget)
        
    
    'PlayerEinstellungen
    PlayerName = PNameTextBox.Text
    fctSetIniValue "Player", "Name", CStr(PlayerName)
    
    fctSetIniValue "Player", "Ship", CStr(PlayerShip)
End Sub


Public Function GetBroadCast() As String
    Dim n As Long
    Dim TMPStr As String

    TMPStr = WS.LocalIP
    
    For n = 1 To 3
    
        If Mid(TMPStr, Len(TMPStr) - n, 1) = "." Then
            GetBroadCast = Left(TMPStr, Len(TMPStr) - n) & "255"
            Exit For
        End If
    
    Next
End Function
