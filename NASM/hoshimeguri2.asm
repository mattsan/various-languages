; アセンブル:
;   $ nasm -f macho hoshimeguri2.asm
;
; リンク:
;   $ ld -macosx_version_min 10.7.0 -o hoshimeguri2 hoshimeguri2.o
;
; 実行:
;   $ ./hoshimeguri2 ../data.txt

BUFFER_SIZE     equ     65536
LINE_SIZE       equ     256

global start

section .text
open_file:
        push    ebp
        mov     ebp, esp
        push    dword 0
        push    dword 0
        push    dword [ebp + 8]
        mov     eax, 5
        sub     esp, 4
        int     0x80
        add     esp, 16
        pop     ebp
        ret

section .text
load_data:
        push    ebp
        mov     ebp, esp
        push    dword [ebp + 16]
        push    dword [ebp + 12]
        push    dword [ebp + 8]
        mov     eax, 3
        sub     esp, 4
        int     0x80
        add     esp, 16
        pop     ebp
        ret

section .text
close_file:
        push    ebp
        mov     ebp, esp
        push    dword [ebp + 8]
        mov     eax, 6
        sub     esp, 12
        int     0x80
        add     esp, 16
        pop     ebp
        ret

section .text
exec_tests:
        push    ebp
        mov     ebp, esp
        sub     esp, 4

        push    esi
        mov     esi, dword [ebp + 8]
.test_loop:
        push    dword esi
        dec     esi
.exctrac_input_loop:
        inc     esi
        cmp     byte [esi], ' '
        jnz     .exctrac_input_loop
        mov     byte [esi], 0

        inc     esi
        push    dword esi
        dec     esi
.extract_expected_loop:
        inc     esi
        cmp     byte [esi], 0x0a
        jnz     .extract_expected_loop
        mov     byte [esi], 0

        inc     esi
        mov     dword [ebp - 4], esi

        call    .test
        add     esp, 8

        mov     esi, dword [ebp - 4]
        cmp     byte [esi], 0
        jnz     .test_loop

        pop     esi

        push    line_feed
        call    write_string
        add     esp, 4

        add     esp, 4
        pop     ebp
        ret

.test:
        push    ebp
        mov     ebp, esp

        push    dword actual
        push    dword [ebp + 12]
        call    solve
        add     esp, 8

        push    dword actual
        push    dword [ebp + 8]
        push    dword [ebp + 12]
        call    .judge
        add     esp, 12

.exit_test:
        pop     ebp
        ret

.judge:
        push    ebp
        mov     ebp, esp

        push    dword [ebp + 16]
        push    dword [ebp + 12]
        call    .compare_string
        add     esp, 8
        or      eax, eax
        jnz     .write_correct_answer

        push    dot
        call    write_string
        add     esp, 4
        jmp     .exit_judge

.write_correct_answer:
        push    input_label
        call    write_string
        add     esp, 4

        push    dword [ebp + 8]
        call    write_string
        add     esp, 4

        push    expected_label
        call    write_string
        add     esp, 4

        push    dword [ebp + 12]
        call    write_string
        add     esp, 4

        push    actual_label
        call    write_string
        add     esp, 4

        push    dword [ebp + 16]
        call    write_string
        add     esp, 4

        push    line_feed
        call    write_string
        add     esp, 4

.exit_judge:
        pop     ebp
        ret

.compare_string:
        push    ebp
        mov     ebp, esp
        xor     eax, eax

        mov     esi, [ebp + 8]
        mov     edi, [ebp + 12]

.compare_loop:
        mov     al, byte [esi]
        mov     ah, byte [edi]

        cmp     al, ah
        jnz     .different

        or      al, al
        jz      .exit_compare_string

        inc     esi
        inc     edi
        jmp     .compare_loop

.different:
        sub     al, ah
        movsx   eax, al

.exit_compare_string:

        pop     ebp
        ret

section .text
solve:
        push    ebp
        mov     ebp, esp
        push    esi

        push    ecx
        push    edx

        push    edi
        mov     esi, dword [ebp + 8]    ; input
        mov     edi, dword [ebp + 12]   ; output

        mov     al, byte [esi]
        inc     esi
        call    .index
        mov     byte [edi], al          ; store first index to output

.solve_loop:
        mov     al, byte [esi]          ; get charactor from input
        inc     esi
        or      al, al
        jz      .decode                 ; detect end of string

        and     al, 1                   ; al = when 'W' then 1, when 'R' then 0
        shl     al, 1                   ; al = al * 2
        mov     ah, byte [edi]          ; ah = previous index
        inc     edi
        movsx   edx, ah                 ; edx = previous index
        and     ah, 1                   ; ah = when odd then 1, when even then 0
        add     al, ah                  ; al = bit 1 => 'W' or 'R', bit 2 => odd or even
        movsx   eax, al
        dec     eax
        jz      .forward2               ; when 'R' and odd then move forward 2
        dec     eax
        jz      .backward2              ; when 'W' and even then move backward 2
        add     edx, 1                  ; else move forward
        jmp     .next_step
.backward2:
        add     edx, 8
        jmp     .next_step
.forward2:
        add     edx, 2
.next_step
        mov     eax, edx
        xor     edx, edx
        mov     ecx, 10
        idiv    ecx                     ; eax div ecx -> eax: quotient, edx: remainder
        mov     byte [edi], dl          ; store next index to output
        jmp     .solve_loop

.decode:                                ; decode from index sequence to charactor sequence
        inc     edi
        sub     edi, dword [ebp + 12]   ; edi <- edi - output (= sequence length)
        mov     ecx, edi                ; ecx = sequence length

        mov     esi, dword [ebp + 12]   ; output
        inc     ecx
.decode_loop:
        dec     ecx
        jz      .exit_solve             ; detect empty
        mov     al, byte [esi]
        movsx   eax, al
        mov     al, byte [star + eax]   ; get charactor
        mov     byte [esi], al          ; store charactor
        inc     esi
        jmp     .decode_loop

.exit_solve:
        pop     edi
        pop     edx
        pop     ecx

        pop     esi
        pop     ebp
        ret

.index:
      push      esi
      mov       esi, star

.index_loop:
      cmp       al, byte [esi]
      jz        .exit_index
      inc       esi
      jmp       .index_loop

.exit_index:
      sub       esi, star
      mov       eax, esi
      pop       esi
      ret

section .text
write_string:
        push    ebp
        mov     ebp, esp
        push    esi

        mov     esi, [ebp + 8]
        xor     eax, eax
.count_string_size:
        cmp     byte [esi + eax], 0
        jz      .start_writing
        inc     eax
        jmp     .count_string_size

.start_writing:
        push    dword eax
        push    dword [ebp + 8]
        push    dword 1
        mov     eax, 4
        sub     esp, 4
        int     0x80
        add     esp, 16

        pop     esi
        pop     ebp
        ret

section .text
start:
        mov     eax, dword [esp + 8]    ; argv[1]
        push    eax
        call    open_file
        add     esp, 4
        mov     [fd], dword eax

        push    dword BUFFER_SIZE
        push    dword buffer
        push    dword [fd]
        call    load_data
        add     esp, 12
        mov     [size], dword eax

        push    dword [fd]
        call    close_file
        add     esp, 4

        push    dword [size]
        push    dword buffer
        call    exec_tests
        add     esp, 8

        ; exit
        push    dword 0
        mov     eax, 1
        sub     esp, 12
        int     0x80

section .data
star:           db  'AHCJEBGDIF'
dot:            db  '.', 0
input_label:    db  0x0a, 'input:    ', 0
expected_label: db  0x0a, 'expected: ', 0
actual_label:   db  0x0a, 'actual:   ', 0
line_feed:      db  0x0a, 0

section .bss
fd:     resd    1
size:   resd    1
actual: resb    LINE_SIZE
buffer: resb    BUFFER_SIZE
