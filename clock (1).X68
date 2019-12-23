*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
            
HARDWARE    EQU    $E00000
            
            ORG    $1000
START:      
            MOVE.L  #32,D0           ;task number 32
            CLR.B   D1               ;parameter: display window
            TRAP    #15              ;system call

            LEA     HARDWARE, A1
            LEA     SETUP, A2
            LEA     CONVERT, A3
            
INIT        MOVE.B  (A2, D1), (A1, D2)
            ADDQ    #2, D2
            ADDQ    #1, D1
            CMP.L   #8, D1
            BNE     INIT
          
            CLR.L   D1
            CLR.L   D2
                   
            MOVE    #3, D0
            MOVE.B  SS, D3
            MOVE.B  MM, D4
            MOVE.B  HH, D5
            
           
;LOOP        MOVE.B  (A3, D3), (A1, D2) ;D2 controls where, d1 controls what
;            ADDQ    #2, D3
;            ADDQ    #1, D2
;            CMP.L   #8, D2
;            BNE     LOOP

            MOVE.L  #ISR6,$78 
            MOVE.L  #ISR7,$7C
           
LOOP        CLR.L   D3
            CLR.L   D4
            CLR.L   D5
            
            MOVE.B  SS, D3
            MOVE.B  MM, D4
            MOVE.B  HH, D5
            
            DIVU    #10, D3
            DIVU    #10, D4
            DIVU    #10, D5
            
            MOVE.B  D3, D6
            SWAP    D3
            MOVE.B  D3, D7
            
            MOVE.B  #14, D2
            MOVE.B  (A3, D7), (A1, D2)
            
            MOVE.B  #12, D2
            MOVE.B  (A3, D6), (A1, D2)
            
            MOVE.B  D4, D6
            SWAP    D4
            MOVE.B  D4, D7
            
            MOVE.B  #8, D2
            MOVE.B  (A3, D7), (A1, D2)
            
            MOVE.B  #6, D2
            MOVE.B  (A3, D6), (A1, D2)
            
            MOVE.B  D5, D6
            SWAP    D5
            MOVE.B  D5, D7
            
            MOVE.B  #2, D2
            MOVE.B  (A3, D7), (A1, D2)
            
            MOVE.B  #0, D2
            MOVE.B  (A3, D6), (A1, D2)
                   
            BRA     LOOP
            
            SIMHALT
            
* Put variables and constants here
ISR6        ORI.W   #$0600, SR     
            SUBI.B  #1, COUNTER
            MOVE.B  COUNTER, D1
            JSR     UPDATETIME
            
            RTE       

UPDATETIME    
            CMPI.B  #0, COUNTER
            BEQ     zerosec
            BRA     EXIT
     
zerosec     ADDI.B  #1, SS
            MOVE.B  #60, COUNTER
            CMPI.B  #60, SS
            BEQ     seconds
            BRA     EXIT

seconds     ADDI.B  #1, MM
            MOVE.B  $0, SS
            CMPI.B  #60, MM
            BEQ     minutes
            BRA     EXIT

minutes     ADDI.B  #1, HH
            MOVE.B  #0, MM
            CMPI.B  #24, HH
            BEQ     hours
            BRA     EXIT

hours       MOVE.B  #0, HH
            BRA     EXIT
            

EXIT        RTS

ISR7        ORI     #0700, SR
            MOVE.B  #0, HH
            MOVE.B  #0, MM
            MOVE.B  #0, SS
            RTE


MSG6        DC.B    'Executing level-6 interrupt service routine',0
COUNTER     DC.B     60 
HH          DC.B     0
MM          DC.B     0
SS          DC.B     0           
CONVERT     DC.B    $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $67
SETUP       DC.B    $00, $00, $40, $00, $00, $40, $00, $00 
DASH        DC.B    $40
           
            END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
