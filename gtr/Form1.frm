VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'Kein
   Caption         =   "GTR"
   ClientHeight    =   5880
   ClientLeft      =   2265
   ClientTop       =   1455
   ClientWidth     =   7560
   Icon            =   "Form1.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   392
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   504
   Begin VB.PictureBox picScreenShot 
      AutoRedraw      =   -1  'True
      BackColor       =   &H000000FF&
      BorderStyle     =   0  'Kein
      Height          =   615
      Left            =   1080
      ScaleHeight     =   41
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   57
      TabIndex        =   0
      Top             =   135
      Visible         =   0   'False
      Width           =   855
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Index           =   0
      Left            =   180
      Top             =   180
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements DirectXEvent

Private Sub DirectXEvent_DXCallback(ByVal EventID As Long)
       
    ' Get the device info
    If Not MainMenu.StartGame Then
        On Local Error Resume Next
        DIDev.GetDeviceStateJoystick Joy
        If Err.Number = DIERR_NOTACQUIRED Or Err.Number = DIERR_INPUTLOST Then
            DIDev.Acquire
            Exit Sub
        End If
    End If
    
    If g_DIEventHdl = EventID Then ProcessJoypadInput

End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = vbKeyLButton Then MouseLDown = True

End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    g_MouseX = X
    g_MouseY = Y

    MouseX = X
    MouseY = Y
    
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = vbKeyLButton Then MouseLDown = False
    If Button = vbKeyLButton Then MouseLUp = True
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    CurrentKey = KeyAscii

    If g_Console.Draw Then Enlarge_ConsoleInputLine KeyAscii
End Sub


Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If GetControlKey Then
        CurrentKeyDI = KeyCode
    End If
    
    ProcessKeyboardInput KeyCode, KEY_STATE_DOWN
    
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
    CurrentKey = 0
    CurrentKeyDI = 0
    
    If Not MainMenu.StartGame Then
        If KeyCode = vbKeyEscape Then
            If Not Intro.Quit Then
                Intro.Quit = True
            Else
                MainMenu.Quit = True
            End If
            If Not QuitCredits Then QuitCredits = True
    
        End If
    End If
    
    ProcessKeyboardInput KeyCode, KEY_STATE_UP
    
End Sub

Private Sub Winsock1_Close(Index As Integer)
    Call gsEvent_Close
End Sub

Private Sub Winsock1_Connect(Index As Integer)
    Call gsEvent_Connect
End Sub

Private Sub Winsock1_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    Call gsEvent_DataArrival(bytesTotal)
End Sub

Private Sub Winsock1_Error(Index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    Call gsEvent_Error(Number, Description)
End Sub

