VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   3  'Fester Dialog
   Caption         =   "GTR-WeaponEditor"
   ClientHeight    =   7950
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11340
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   530
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   756
   StartUpPosition =   3  'Windows-Standard
   Begin VB.TextBox txtLightB 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   35
      Text            =   "5"
      Top             =   6720
      Width           =   4695
   End
   Begin VB.TextBox txtLightG 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   33
      Text            =   "5"
      Top             =   6360
      Width           =   4695
   End
   Begin VB.TextBox txtLightR 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   31
      Text            =   "5"
      Top             =   6000
      Width           =   4695
   End
   Begin VB.CommandButton cmdNextSurf 
      Caption         =   "-->"
      Height          =   615
      Left            =   10320
      TabIndex        =   30
      Top             =   6480
      Width           =   735
   End
   Begin VB.CommandButton cmdPriorSurf 
      Caption         =   "<--"
      Height          =   615
      Left            =   120
      TabIndex        =   29
      Top             =   6480
      Width           =   735
   End
   Begin VB.TextBox txtPower 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   28
      Text            =   "5"
      Top             =   4200
      Width           =   4695
   End
   Begin VB.TextBox txtNumFrames 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   27
      Text            =   "20"
      Top             =   2760
      Width           =   4695
   End
   Begin VB.TextBox txtReloadable 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   23
      Text            =   "0"
      Top             =   4920
      Width           =   4695
   End
   Begin VB.TextBox txtReloadSpeed 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   22
      Text            =   "5"
      Top             =   5280
      Width           =   4695
   End
   Begin VB.TextBox txtConsumption 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   21
      Text            =   "5"
      Top             =   5640
      Width           =   4695
   End
   Begin VB.TextBox txtFireInterval 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   19
      Text            =   "5"
      Top             =   4560
      Width           =   4695
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Speichern"
      Height          =   495
      Left            =   9600
      TabIndex        =   17
      Top             =   7320
      Width           =   1575
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "Übernehmen"
      Height          =   495
      Left            =   7920
      TabIndex        =   16
      Top             =   7320
      Width           =   1575
   End
   Begin VB.TextBox txtSteerSpeed 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   8
      Text            =   "0"
      Top             =   3120
      Width           =   4695
   End
   Begin VB.TextBox txtSpeed 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   7
      Text            =   "7"
      Top             =   3480
      Width           =   4695
   End
   Begin VB.TextBox txtShootType 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   6
      Text            =   "1"
      Top             =   2400
      Width           =   4695
   End
   Begin VB.TextBox txtAddShipSpeed 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      TabIndex        =   5
      Text            =   "1"
      Top             =   3840
      Width           =   4695
   End
   Begin VB.TextBox txtDescription 
      BorderStyle     =   0  'Kein
      Height          =   885
      Left            =   3960
      MaxLength       =   255
      MultiLine       =   -1  'True
      TabIndex        =   4
      Text            =   "frmMain.frx":0000
      Top             =   1440
      Width           =   4695
   End
   Begin VB.TextBox txtName 
      BorderStyle     =   0  'Kein
      Height          =   285
      Left            =   3960
      MaxLength       =   20
      TabIndex        =   3
      Text            =   "/"
      Top             =   1080
      Width           =   4695
   End
   Begin VB.CommandButton cmdNextWeapon 
      Caption         =   "-->"
      Height          =   615
      Left            =   10440
      TabIndex        =   2
      Top             =   960
      Width           =   735
   End
   Begin VB.CommandButton cmdPriorWeapon 
      Caption         =   "<--"
      Height          =   615
      Left            =   120
      TabIndex        =   1
      Top             =   960
      Width           =   735
   End
   Begin VB.PictureBox picWeapon 
      BorderStyle     =   0  'Kein
      Height          =   720
      Left            =   120
      ScaleHeight     =   35.446
      ScaleMode       =   0  'Benutzerdefiniert
      ScaleWidth      =   737
      TabIndex        =   0
      Top             =   120
      Width           =   11055
   End
   Begin VB.Label Label15 
      Alignment       =   1  'Rechts
      Caption         =   "Light B:"
      Height          =   255
      Left            =   1080
      TabIndex        =   36
      Top             =   6720
      Width           =   2655
   End
   Begin VB.Label Label14 
      Alignment       =   1  'Rechts
      Caption         =   "Light G:"
      Height          =   255
      Left            =   1080
      TabIndex        =   34
      Top             =   6360
      Width           =   2655
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Rechts
      Caption         =   "Light R:"
      Height          =   255
      Left            =   1080
      TabIndex        =   32
      Top             =   6000
      Width           =   2655
   End
   Begin VB.Label Label13 
      Alignment       =   1  'Rechts
      Caption         =   "Nachladebar:"
      Height          =   255
      Left            =   1080
      TabIndex        =   26
      Top             =   4920
      Width           =   2655
   End
   Begin VB.Label Label12 
      Alignment       =   1  'Rechts
      Caption         =   "NachladeGeschwindigkeit"
      Height          =   255
      Left            =   1080
      TabIndex        =   25
      Top             =   5280
      Width           =   2655
   End
   Begin VB.Label Label11 
      Alignment       =   1  'Rechts
      Caption         =   "Verbrauch:"
      Height          =   255
      Left            =   1080
      TabIndex        =   24
      Top             =   5640
      Width           =   2655
   End
   Begin VB.Label Label10 
      Alignment       =   1  'Rechts
      Caption         =   "SchussInterval:"
      Height          =   255
      Left            =   1080
      TabIndex        =   20
      Top             =   4560
      Width           =   2655
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Rechts
      Caption         =   "Kraft:"
      Height          =   255
      Left            =   1080
      TabIndex        =   18
      Top             =   4200
      Width           =   2655
   End
   Begin VB.Label Label8 
      Alignment       =   1  'Rechts
      Caption         =   "SchiffsGeschw hinzufügen:"
      Height          =   255
      Left            =   1080
      TabIndex        =   15
      Top             =   3840
      Width           =   2655
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Rechts
      Caption         =   "Geschwindigkeit:"
      Height          =   255
      Left            =   1080
      TabIndex        =   14
      Top             =   3480
      Width           =   2655
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Rechts
      Caption         =   "AnimationsGeschwindigkeit:"
      Height          =   255
      Left            =   1080
      TabIndex        =   13
      Top             =   3120
      Width           =   2655
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Rechts
      Caption         =   "Anzahl Bilder:"
      Height          =   255
      Left            =   1080
      TabIndex        =   12
      Top             =   2760
      Width           =   2655
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Rechts
      Caption         =   "SchussArt:"
      Height          =   255
      Left            =   1080
      TabIndex        =   11
      Top             =   2400
      Width           =   2655
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Rechts
      Caption         =   "Beschreibung:"
      Height          =   255
      Left            =   1080
      TabIndex        =   10
      Top             =   1440
      Width           =   2655
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Rechts
      Caption         =   "Name:"
      Height          =   255
      Left            =   1080
      TabIndex        =   9
      Top             =   1080
      Width           =   2655
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Übernehmen
Private Sub cmdApply_Click()

    GetSettings

End Sub

'vorherige Waffe
Private Sub cmdPriorWeapon_Click()

    GetSettings
    ScrollWeapon -1
    ShowSettings

End Sub

'nächste Waffe
Private Sub cmdNextWeapon_Click()
    
    GetSettings
    ScrollWeapon 1
    ShowSettings

End Sub

'vorherige Surf
Private Sub cmdPriorSurf_Click()
    
    ScrollWeaponSurf -1

End Sub

'nächste Surf
Private Sub cmdNextSurf_Click()

    ScrollWeaponSurf 1

End Sub

'Speichern
Private Sub cmdSave_Click()

    GetSettings
    SaveSettings

End Sub

'hier beginnt alles
Private Sub Form_Load()

    Init_Editor
    
End Sub
