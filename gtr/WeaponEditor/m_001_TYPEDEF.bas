Attribute VB_Name = "m_001_TYPEDEF"
Option Explicit

'===Konstanten===

Public Const NUM_WEAPON_TYPES           As Integer = 7
Public Const NUM_SURFS                  As Integer = 5


'===Enums===

Public Enum EShootType                                      'AbschussArt
    SHOOT_TYPE_STRAIGHT = 1
    SHOOT_TYPE_DOUBLE_STRAIGHT
    SHOOT_TYPE_TRIPLE_SLANT
    SHOOT_TYPE_OCT_SLANT
End Enum


'===Typen===

Public Type TWeaponType                                     'Waffentyp mit Eigenschaften
    TypeName                            As String * 20
    Description                         As String * 255
    ShootType                           As EShootType
    SurfNum                             As Integer
    NumFrames                           As Integer
    SteerSpeed                          As Single
    Speed                               As Single
    AddShipSpeed                        As Boolean
    Power                               As Single
    FireDelay                           As Single
    Reloadable                          As Boolean
    ReloadSpeed                         As Single
    Consumption                         As Single
    LightColor                          As D3DCOLORVALUE
End Type
