include Irvine32.inc

.data
    maxContacts DWORD 100
    currentCount DWORD 0

    phones DWORD 100 DUP(0)
    menu BYTE  "Phone Book Managment", 13, 10
         BYTE "1. Add ", 13, 10
         BYTE "2. Delete ", 13, 10
         BYTE "3. Display ", 13, 10
         BYTE "4. Exit", 13, 10
         BYTE "Enter your choice: ", 0
    wellcome      BYTE "Phone Book Managmet"            
    invalidChoice BYTE 13, 10, "Invalid choice. Please enter again.", 13, 10, 0
    exiting       BYTE 13, 10, "Exiting...", 13, 10, 0
    promptPhone   BYTE "Enter contact phone number: ", 0
    promptDelete  BYTE "Enter contact phone number to delete: ", 0
    notFound      BYTE "Contact not found.", 13, 10, 0
    listFull      BYTE "Contact list is full.", 13, 10, 0

.code
main PROC
    call Crlf
    call MainLoop  

MainLoop PROC
    
    mov edx, OFFSET menu
    call WriteString
    call ReadInt

    cmp eax, 1
    je addContact
    cmp eax, 2
    je deleteContact
    cmp eax, 3
    je displayContacts
    cmp eax, 4
    je exitProgram

    call invalidChoiceLabel
    jmp MainLoop    

MainLoop ENDP

addContact PROC
   
    mov eax, currentCount
    cmp eax, maxContacts
    jae contactListFull

  
    call Crlf
    mov edx, OFFSET promptPhone
    call WriteString
    call ReadInt
    mov esi, eax

  
    mov edi, OFFSET phones
    mov ebx, currentCount
    shl ebx, 2
    add edi, ebx
    mov [edi], esi

    inc currentCount

    jmp mainLoop

contactListFull:

    mov edx, OFFSET listFull
    call WriteString
    call Crlf
    jmp mainLoop
addContact ENDP
deleteContact PROC
    call Crlf
    mov edx, OFFSET promptDelete
    call WriteString
    call ReadInt
    mov esi, eax
    mov edi, OFFSET phones
    mov ecx, currentCount
deleteLoop:
    cmp ecx, 0
    je notFoundHandler
    mov eax, [edi]
    cmp eax, esi
    je foundDelete
    add edi, 4
    loop deleteLoop
notFoundHandler:
    mov edx, OFFSET notFound
    call WriteString
    call Crlf
    jmp mainLoop
foundDelete:
    mov ebx, edi
    add ebx, 4
shiftLoop:
    cmp ecx, 1
    je endShift
    mov eax, [ebx]
    mov [edi], eax
    add edi, 4
    add ebx, 4
    dec ecx
    jmp shiftLoop
endShift:
    dec currentCount
    jmp mainLoop
deleteContact ENDP
displayContacts PROC
    call Crlf
    mov ecx, currentCount
    mov esi, OFFSET phones
displayLoop:
    cmp ecx, 0
    je endDisplay
    mov eax, [esi]
    call WriteDec
    call Crlf
    add esi, 4
    loop displayLoop
endDisplay:
    call Crlf
    jmp mainLoop
displayContacts ENDP
invalidChoiceLabel PROC
    call Crlf
    mov edx, OFFSET invalidChoice
    call WriteString
    ret
invalidChoiceLabel ENDP
exitProgram PROC
    call Crlf
    mov edx, OFFSET exiting
    call WriteString
    call ExitProcess
exitProgram ENDP
main ENDP
END main
