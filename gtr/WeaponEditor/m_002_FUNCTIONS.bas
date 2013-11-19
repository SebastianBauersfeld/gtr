Attribute VB_Name = "m_003_FUNCTIONS"
Option Explicit

'initialisiert den Editor
Public Sub Init_Editor()

    g_CurrentWeapon = 1
    g_CurrentSurf = 1
    LoadWeaponBmp 1
    
    LoadSettings
    ShowSettings

End Sub

'lädt die Schiffeinstellungen
Public Sub LoadSettings()

    Dim n           As Long
    Dim FileNum     As Integer
    
    FileNum = FreeFile

    Open App.Path & "\weapons.cfg" For Binary As FileNum
        
        For n = 1 To NUM_WEAPON_TYPES
            With g_WeaponType(n)
                Get FileNum, , .TypeName
                Get FileNum, , .Description
                Get FileNum, , .ShootType
                Get FileNum, , .SurfNum
                Get FileNum, , .NumFrames
                Get FileNum, , .SteerSpeed
                Get FileNum, , .Speed
                Get FileNum, , .AddShipSpeed
                Get FileNum, , .Power
                Get FileNum, , .FireDelay
                Get FileNum, , .Reloadable
                Get FileNum, , .ReloadSpeed
                Get FileNum, , .Consumption
                
                Get FileNum, , .LightColor.r
                Get FileNum, , .LightColor.g
                Get FileNum, , .LightColor.b
            End With
        Next n
    
    Close FileNum

End Sub

'speichert die Schiffeinstellungen
Public Sub SaveSettings()

    Dim n           As Long
    Dim FileNum     As Integer
    
    FileNum = FreeFile

    Open App.Path & "\weapons.cfg" For Binary As FileNum
        
        For n = 1 To NUM_WEAPON_TYPES
            With g_WeaponType(n)
                Put FileNum, , .TypeName
                Put FileNum, , .Description
                Put FileNum, , .ShootType
                Put FileNum, , .SurfNum
                Put FileNum, , .NumFrames
                Put FileNum, , .SteerSpeed
                Put FileNum, , .Speed
                Put FileNum, , .AddShipSpeed
                Put FileNum, , .Power
                Put FileNum, , .FireDelay
                Put FileNum, , .Reloadable
                Put FileNum, , .ReloadSpeed
                Put FileNum, , .Consumption
                
                Put FileNum, , .LightColor.r
                Put FileNum, , .LightColor.g
                Put FileNum, , .LightColor.b
            End With
        Next n
    
    Close FileNum

End Sub

'holt Informationen aus Steuerelementen
Public Sub GetSettings()
    
    With frmMain
        If Not IsNumeric(.txtNumFrames.Text) Then .txtNumFrames.Text = "0"
        If Not IsNumeric(.txtShootType.Text) Then .txtShootType.Text = "0"
        If Not IsNumeric(.txtPower.Text) Then .txtPower.Text = "0"
        If Not IsNumeric(.txtSpeed.Text) Then .txtSpeed.Text = "0"
        If Not IsNumeric(.txtSteerSpeed.Text) Then .txtSteerSpeed.Text = "0"
        If Not IsNumeric(.txtFireInterval.Text) Then .txtFireInterval.Text = "0"
        If Not IsNumeric(.txtReloadSpeed.Text) Then .txtReloadSpeed.Text = "0"
        If Not IsNumeric(.txtConsumption.Text) Then .txtConsumption.Text = "0"
        If Not IsNumeric(.txtReloadable.Text) Then .txtReloadable.Text = "0"
        If Not IsNumeric(.txtAddShipSpeed.Text) Then .txtAddShipSpeed.Text = "0"
        If Not IsNumeric(.txtLightR.Text) Then .txtLightR.Text = "0"
        If Not IsNumeric(.txtLightG.Text) Then .txtLightG.Text = "0"
        If Not IsNumeric(.txtLightB.Text) Then .txtLightB.Text = "0"
    End With

    With g_WeaponType(g_CurrentWeapon)
        .TypeName = frmMain.txtName.Text
        .Description = frmMain.txtDescription.Text
        .ShootType = frmMain.txtShootType.Text
        .NumFrames = frmMain.txtNumFrames.Text
        .SurfNum = g_CurrentSurf
        .Power = frmMain.txtPower.Text
        .Speed = frmMain.txtSpeed.Text
        .SteerSpeed = frmMain.txtSteerSpeed.Text
        .FireDelay = frmMain.txtFireInterval.Text
        .ReloadSpeed = frmMain.txtReloadSpeed.Text
        .Consumption = frmMain.txtConsumption.Text
        .Reloadable = CBool(frmMain.txtReloadable.Text)
        .AddShipSpeed = CBool(frmMain.txtAddShipSpeed.Text)
        
        .LightColor.r = CSng(frmMain.txtLightR.Text)
        .LightColor.g = CSng(frmMain.txtLightG.Text)
        .LightColor.b = CSng(frmMain.txtLightB.Text)
    End With

End Sub

'zeigt Informationen in Steuerelementen an
Public Sub ShowSettings()

    With g_WeaponType(g_CurrentWeapon)
        frmMain.txtName.Text = .TypeName
        frmMain.txtDescription.Text = .Description
        frmMain.txtShootType.Text = .ShootType
        frmMain.txtNumFrames.Text = .NumFrames
        frmMain.txtPower.Text = .Power
        frmMain.txtSpeed.Text = .Speed
        frmMain.txtSteerSpeed.Text = .SteerSpeed
        frmMain.txtFireInterval.Text = .FireDelay
        frmMain.txtReloadSpeed.Text = .ReloadSpeed
        frmMain.txtConsumption.Text = .Consumption
        frmMain.txtReloadable.Text = Abs(CInt(.Reloadable))
        frmMain.txtAddShipSpeed.Text = Abs(CInt(.AddShipSpeed))
        
        frmMain.txtLightR.Text = .LightColor.r
        frmMain.txtLightG.Text = .LightColor.g
        frmMain.txtLightB.Text = .LightColor.b
        
        g_CurrentSurf = .SurfNum
        If g_CurrentSurf = 0 Then g_CurrentSurf = 1
        If g_CurrentSurf > NUM_SURFS Then g_CurrentSurf = NUM_SURFS
        LoadWeaponBmp g_CurrentSurf
    End With

End Sub

'Bild auswählen
Public Sub ScrollWeaponSurf(ByVal Speed As Integer)

    g_CurrentSurf = g_CurrentSurf + Speed
    
    If g_CurrentSurf > NUM_SURFS Then
        g_CurrentSurf = NUM_SURFS
    ElseIf g_CurrentSurf < 1 Then
        g_CurrentSurf = 1
    End If
    
    LoadWeaponBmp (g_CurrentSurf)

End Sub

'Waffe auswählen
Public Sub ScrollWeapon(ByVal Speed As Integer)

    g_CurrentWeapon = g_CurrentWeapon + Speed
    
    If g_CurrentWeapon > NUM_WEAPON_TYPES Then
        g_CurrentWeapon = NUM_WEAPON_TYPES
    ElseIf g_CurrentWeapon < 1 Then
        g_CurrentWeapon = 1
    End If

End Sub

'lädt die Waffen-Bitmap
Public Sub LoadWeaponBmp(ByVal i As Integer)

    frmMain.picWeapon.Picture = LoadPicture(App.Path & "\weapon_" & Format(i, "000") & ".bmp")

End Sub
