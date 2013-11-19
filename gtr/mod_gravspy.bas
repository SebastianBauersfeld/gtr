Attribute VB_Name = "mnu_m16_gravspyNet"
'  mod_gravspy.bas
' =======================================================
'                     - GRAVITY SPY -
'                 © 2002 by Robert Walter
' =======================================================
'  Zum Verwalten laufender "Gravity The Revolution" -
'  Spiele auf einem Webserver über php-scripte.
' =======================================================
Option Explicit
' //////////////////////////////////////////////////////////////////////////////
' //                                 DECLARATION
' //////////////////////////////////////////////////////////////////////////////

' ===============
' =  Constants  =
' ===============

Const EnableTextOut = 1
Public Const Timeout_Ping = 999

Private Const phpHost As String = "devagents.de"
'Private Const phpHost As String = "192.168.0.2"
Private Const phpLocation As String = "/gravspy/"

Private Const phpTest As String = "test.php"
Private Const phpCreate As String = "addserver.php"
Private Const phpUpdate As String = "update.php"
Private Const phpSession As String = "addsession.php"
Private Const phpList As String = "getlist.php"
Private Const phpRemove As String = "remove.php"

Private Const CreatingServer As Long = 1
Private Const UpdatingServer As Long = 2
Private Const Downloading    As Long = 3
Private Const LoggingOut     As Long = 4

' ===============
' =  Variables  =
' ===============

Public WS As Winsock                        ' Winsock Object
Private MyServer As TServerInfo_PassOn
Private GState As Long
Private gSid As String

Private HTTP_ReqHeader As String
Private HTTP_Response As String

Public RunningServer() As TServerInfo_Receive
Public ServerCount As Long
' ===========
' =  Types  =
' ===========

Public Type TServerInfo_Receive
    ServerName                      As String * 20
    CurrentMap                      As String * 20
    PlayerCount                     As Integer
    MaxPlayers                      As Integer
    Destroyable                     As Integer
    GameType                        As Long
    '-------------- blah blah ---------------------'
    IP                              As String * 15
    DateTime                        As String * 20
    LastRefresh                     As Long
    Latency                         As Long
End Type

Public Type TServerInfo_PassOn
    ServerName                      As String * 20
    CurrentMap                      As String * 20
    PlayerCount                     As Integer
    MaxPlayers                      As Integer
    Destroyable                     As Integer
    GameType                        As Long
End Type

Private Type IP_OPTION_INFORMATION
    TTL                             As Byte
    Tos                             As Byte
    Flags                           As Byte
    OptionsSize                     As Long
    OptionsData                     As String * 128
End Type

Private Type IP_ECHO_REPLY
    Address(0 To 3)                 As Byte
    Status                          As Long
    RoundTripTime                   As Long
    DataSize                        As Integer
    Reserved                        As Integer
    data                            As Long
    Options                         As IP_OPTION_INFORMATION
End Type

' ==============
' =  API-crap  =
' ==============

Private Declare Function IcmpCreateFile Lib "icmp.dll" () As Long
Private Declare Function IcmpCloseHandle Lib "icmp.dll" (ByVal HANDLE As Long) As Boolean
Private Declare Function IcmpSendEcho Lib "ICMP" (ByVal IcmpHandle As Long, ByVal DestAddress As Long, ByVal RequestData As String, ByVal RequestSize As Integer, RequestOptns As IP_OPTION_INFORMATION, ReplyBuffer As IP_ECHO_REPLY, ByVal ReplySize As Long, ByVal TimeOut As Long) As Boolean

' //////////////////////////////////////////////////////////////////////////////
'                                  PRIVATE STUFF
' //////////////////////////////////////////////////////////////////////////////

' activation string - it's needed to create a session
Private Function ActivationString() As String
    ' oma
    ActivationString = Chr(111) & _
                       Chr(109) & _
                       Chr(97)
End Function

Private Sub Interprete(Response As String)
    Select Case GState
    Dim n As Integer
        Case CreatingServer
            gSid = GetValue(Response, "gsid")
            gs_Update MyServer
        Case UpdatingServer
            TextOut GetValue(Response, "result")
        Case Downloading
          Dim SPack() As String
          Dim tmpServer() As TServerInfo_Receive
            If GetValue(Response, "result") = "empty" Then
                TextOut "No running games"
                ServerCount = 0
                Exit Sub
            End If
            SPack = Split(Response, "#")
            ReDim tmpServer(UBound(SPack))
            ServerCount = UBound(SPack) + 1
            For n = 0 To UBound(SPack)
                With tmpServer(n)
                    .CurrentMap = GetValue(SPack(n), "CurrentMap")
                    .DateTime = GetValue(SPack(n), "DateTime")
                    .Destroyable = GetValue(SPack(n), "Destroyable")
                    .GameType = GetValue(SPack(n), "GameType")
                    .IP = GetValue(SPack(n), "IP")
                    .LastRefresh = GetValue(SPack(n), "LastRefresh")
                    .MaxPlayers = GetValue(SPack(n), "MaxPlayers")
                    .PlayerCount = GetValue(SPack(n), "PlayerCount")
                    .ServerName = GetValue(SPack(n), "ServerName")
                    .Latency = 999
                End With
            Next n
            RunningServer = tmpServer
            ListOut RunningServer
    End Select
End Sub

' filters certain values from a string
Private Function GetValue(tag As String, VName As String) As String
  Dim tLine() As String
  Dim n As Integer
  Dim VarName, VarValue As String
  Dim AllocatorPos As Integer
    On Error GoTo EXCEPTION
    tLine = Split(tag, Chr(10), , vbBinaryCompare)       ' split into lines
    For n = 0 To UBound(tLine)
        AllocatorPos = InStr(1, tLine(n), ": ", vbTextCompare)
        VarName = Left(tLine(n), AllocatorPos - 1)
        If VarName = VName Then
            VarValue = Right(tLine(n), Len(tLine(n)) - AllocatorPos - 1)
        End If
    Next n
    GetValue = VarValue
    Exit Function
EXCEPTION:
    TextOut "invalid server response"
    GetValue = "ERROR"
End Function

' filters the important data
Private Function FilterData(Response As String) As String
  Dim dBeg, dEnd As Long
    On Error Resume Next
    dBeg = InStr(1, Response, "{") + 1
    dEnd = InStr(1, Response, "}")
    FilterData = Mid(Response, dBeg, dEnd - dBeg)
End Function

' standard TextOut shit
Private Sub TextOut(s As String)
    If EnableTextOut Then
        With MessageListBox
            .ListCount = .ListCount + 1
            ReDim Preserve .List(.ListCount)
            .List(.ListCount) = s
            .Start = .ListCount - 4
        End With
    End If
End Sub

' transforms IP-string into a long value
Private Function IPtoLong(sIP As String) As Long
  Dim Address() As String
  Dim Result As Long
  On Error Resume Next
    Address = Split(sIP, ".")
    Result = Result + 256 ^ 0 * CByte(Address(0)) + _
                      256 ^ 1 * CByte(Address(1)) + _
                      256 ^ 2 * CByte(Address(2)) + _
                      256 ^ 3 * CByte(Address(3))
    IPtoLong = Result
End Function

Private Sub ListOut(ServerList() As TServerInfo_Receive)
  Dim n As Integer
        For n = 0 To UBound(ServerList)
            With ServerList(n)
                TextOut "===================="
                TextOut "Servername :" & .ServerName
                TextOut "IP         :" & .IP
                TextOut "Map        :" & .CurrentMap
                TextOut "GameType   :" & .GameType
                TextOut "Destroyable:" & .Destroyable
                TextOut "LastRefresh:" & .LastRefresh
                TextOut "MaxPlayers :" & .MaxPlayers
                TextOut "PlayerCount:" & .PlayerCount
                TextOut "Latency    :" & .Latency
                TextOut "===================="
            End With
        Next n
End Sub

' executes php scripts
Private Sub phpExecute(Host As String, URL As String)
    ' create HTTP request header
    HTTP_ReqHeader = "GET " & URL & " HTTP/1.0" & vbCrLf & _
                     "Host: " & Host & vbCrLf & _
                     "Connection: close" & vbCrLf & _
                     "Accept: */*" & vbCrLf & vbCrLf
    ' Connection request
    WS.Close
    WS.Connect Host, 80
    ' => gsEvent_Connect
End Sub

' //////////////////////////////////////////////////////////////////////////////
'                                  PUBLIC STUFF
' //////////////////////////////////////////////////////////////////////////////

' ===================
' =  Pseudo-Events  =
' ===================

Public Sub gsEvent_Close()
  Dim Response As String
    TextOut "Winsock connection closed"
    ' filter data
    'TextOut "================" & vbCrLf & HTTP_Response & vbCrLf & "================"
    Response = FilterData(HTTP_Response)
    'TextOut "================" & vbCrLf & Response & vbCrLf & "================"
    'TextOut GState & " : " & Response
    Interprete Response
    
    Response = vbNullString
    HTTP_Response = vbNullString
End Sub

Public Sub gsEvent_Connect()
    TextOut "Winsock connection activated"
    ' Anfrage senden
    WS.SendData HTTP_ReqHeader
End Sub

Public Sub gsEvent_DataArrival(bytesTotal As Long)
  Dim Arrival As String
    TextOut CStr(bytesTotal) & " bytes received"
    WS.GetData Arrival
    'TextOut Arrival
    HTTP_Response = HTTP_Response & Arrival
End Sub

Public Sub gsEvent_Error(Number As Integer, Description As String)
    TextOut "Winsock error " & Number & " :"
    TextOut Description
End Sub

' ====================
' =  Initialisation  =
' ====================

Public Sub gs_Init(Index As Integer)
    Set WS = frmMain.Winsock1(Index)
End Sub

' =====================
' =  Interpretations  =
' =====================

' refresh latency
Public Sub gs_UpdateLatency(ServerID As Long)
  Dim Latency As Long
    On Error Resume Next
    Latency = gs_ping(Trim(RunningServer(ServerID).IP))
    RunningServer(ServerID).Latency = Latency
    ListOut RunningServer()
End Sub

' creates server
Public Sub gs_CreateServer(Server As TServerInfo_PassOn)
    GState = CreatingServer
    MyServer = Server
    TextOut "Registration of session " & Trim(Server.ServerName) & " =>"
    phpExecute phpHost, phpLocation & phpCreate & "?s=" & ActivationString
End Sub

' logs out
Public Sub gs_LogOut()
    GState = LoggingOut
    TextOut "Terminate session =>"
    phpExecute phpHost, phpLocation & phpRemove & "?gsid=" & gSid
End Sub

' refreshs server data
Public Sub gs_Update(Server As TServerInfo_PassOn)
  Dim ParaList As String
    GState = UpdatingServer
    ParaList = "?" & _
               "gsid=" & gSid & "&" & _
               "sn=" & Trim(Server.ServerName) & "&" & _
               "cm=" & Trim(Server.CurrentMap) & "&" & _
               "pc=" & Server.PlayerCount & "&" & _
               "mp=" & Server.MaxPlayers & "&" & _
               "de=" & CInt(Server.Destroyable) & "&" & _
               "gt=" & Server.GameType
    TextOut "Updating " & Trim(Server.ServerName) & " =>"
    phpExecute phpHost, phpLocation & phpUpdate & ParaList
End Sub


' downloads server list
Public Sub gs_GetList()
    GState = Downloading
    TextOut "Loading server list =>"
    phpExecute phpHost, phpLocation & phpList
End Sub

' kleine ping funktion
Public Function gs_ping(HostIP As String) As Long
  Dim hFile As Long
  Dim Address As Long, rIP As String
  Dim OptInfo As IP_OPTION_INFORMATION
  Dim EchoReply As IP_ECHO_REPLY
    Address = IPtoLong(HostIP)
    hFile = IcmpCreateFile()
        If hFile = 0 Then
            TextOut "Unable to create ICMP file handle"
            Exit Function
        End If
        OptInfo.TTL = 255
        If IcmpSendEcho(hFile, Address, String(32, "A"), 32, OptInfo, EchoReply, Len(EchoReply) + 8, Timeout_Ping) Then
            rIP = CStr(EchoReply.Address(0)) + "." + CStr(EchoReply.Address(1)) + "." + CStr(EchoReply.Address(2)) + "." + CStr(EchoReply.Address(3))
        Else
            TextOut "Timeout"
        End If
        If EchoReply.Status = 0 Then
            TextOut "Reply from " + rIP + " recieved after " + Trim$(CStr(EchoReply.RoundTripTime)) + "ms"
            gs_ping = EchoReply.RoundTripTime
        Else
            TextOut "Failure!!!"
            gs_ping = 9999
        End If
    Call IcmpCloseHandle(hFile)
End Function

Public Function IsInternetServer(ByRef List As TNetWorkGameList)

    If List.Count > 0 Then
        IsInternetServer = True
    Else
        IsInternetServer = False
    End If
 
End Function

