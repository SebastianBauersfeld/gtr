Attribute VB_Name = "ntr_06_Berechnungen"
Option Explicit


Public Sub subMoveWStars()

    Dim n As Long
    
    With Intro
        For n = 0 To MAX_WSTARS
        
            WStarVertex(n * 3).Z = WStarVertex(n * 3).Z - .WarpStarSpeed * ConstSpeed
            WStarVertex(n * 3 + 1).Z = WStarVertex(n * 3 + 1).Z - .WarpStarSpeed * ConstSpeed
            WStarVertex(n * 3 + 2).Z = WStarVertex(n * 3 + 2).Z - .WarpStarSpeed * ConstSpeed
            
            If WStarVertex(n * 3).Z < -35 And .RecoverStars Then subRecoverWStar n
            
        Next
    End With

End Sub


Public Sub subRecoverWStar(Count As Long)

    WStarVertex(Count * 3).Z = 100 + WStarVertex(Count * 3).Z
    WStarVertex(Count * 3 + 1).Z = 100 + WStarVertex(Count * 3 + 1).Z
    WStarVertex(Count * 3 + 2).Z = 100 + WStarVertex(Count * 3 + 2).Z
    
End Sub



Public Sub subCalcSentences()
    Dim n As Long

Select Case curs.lPlay
' =========================================================== 1. Sentence
'Case 25000 To 60000, 130000 To 165000, 245000 To 280000, 465000 To 500000
Case 60000 To 70000, 165000 To 175000, 280000 To 290000, 500000 To 510000, 610000 To 620000, _
     720000 To 730000
   
    If Sentence.Fade < 0 Then
        For n = 0 To 5
            Sentence.Vertex(n).Z = -15
        Next
        Sentence.Fade = 0
        subInitFlash
    End If
    
    If Sentence.Fade < 1 Then Sentence.Fade = Sentence.Fade + ConstSpeed / 7
    
Case 90000 To 115000, 185000 To 205000, 300000 To 325000, 525000 To 550000, 630000 To 655000, _
     740000 To 765000
    
    Sentence.Fade = Sentence.Fade - ConstSpeed / 15
    
    For n = 0 To 5
        Sentence.Vertex(n).Z = Sentence.Vertex(n).Z - 1 * ConstSpeed
    Next
    
End Select

End Sub


Public Sub subInitFlash()

    Flash.Fade = 1
    Flash.StartTime = Timer

End Sub



