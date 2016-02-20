; $ nasm -f macho hoshimeguri1.asm
; $ ld -macosx_version_min 10.7.0 -o hoshimeguri1 hoshimeguri1.o
; $ ./hoshimeguri1 ../data.txt

BUFFER_SIZE     equ     65536
LINE_SIZE       equ     256

global start

section .text
open_file:
        ; int open_file(char* filename)
        ; return: file descriptor
        push    ebp
        mov     ebp, esp
        push    dword 0                 ; mode
        push    dword 0                 ; flag: read
        push    dword [ebp + 8]         ; filename
        mov     eax, 5                  ; system call: open
        sub     esp, 4
        int     0x80
        add     esp, 16
        pop     ebp
        ret

section .text
load_data:
        ; int load_data(int file_descriptor, char* buffer, int buffer_size)
        ; return: loaded data size (bytes)
        push    ebp
        mov     ebp, esp
        push    dword [ebp + 16]        ; buffer_size
        push    dword [ebp + 12]        ; buffer
        push    dword [ebp + 8]         ; file descriptor
        mov     eax, 3                  ; system call: read
        sub     esp, 4
        int     0x80
        add     esp, 16
        pop     ebp
        ret

section .text
close_file:
        ; void close_file(int file_descriptor)
        push    ebp
        mov     ebp, esp
        push    dword [ebp + 8]         ; file descriptor
        mov     eax, 6                  ; system call: close
        sub     esp, 12
        int     0x80
        add     esp, 16
        pop     ebp
        ret

section .text
exec_tests:
        ; void exec_tests(char* data)
        push    ebp
        mov     ebp, esp
        sub     esp, 4

        push    esi
        mov     esi, dword [ebp + 8]    ; buffer
.test_loop:
        push    dword esi               ; input
        dec     esi
.exctrac_input_loop:
        inc     esi
        cmp     byte [esi], ' '         ; find space
        jnz     .exctrac_input_loop
        mov     byte [esi], 0           ; write NULL instead space

        inc     esi
        push    dword esi               ; expected
        dec     esi
.extract_expected_loop:
        inc     esi
        cmp     byte [esi], 0x0a        ; find line-feed
        jnz     .extract_expected_loop
        mov     byte [esi], 0           ; write NULL instead line-feed

        inc     esi
        mov     dword [ebp - 4], esi    ; store head of next line to a local variable

        call    .test
        add     esp, 8

        mov     esi, dword [ebp - 4]    ; head of next line
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
        ; void test(char* input, char* expected)
        push    ebp
        mov     ebp, esp

        push    dword actual
        push    dword [ebp + 12]        ; input
        call    solve
        add     esp, 8

        push    dword actual            ; actual
        push    dword [ebp + 8]         ; expected
        push    dword [ebp + 12]        ; input
        call    .judge
        add     esp, 12

        pop     ebp
        ret

.judge:
        ; void judge(char* input, char* expected, char* actual)
        push    ebp
        mov     ebp, esp

        push    dword [ebp + 16]        ; actual
        push    dword [ebp + 12]        ; expected
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

        push    dword [ebp + 8]         ; input
        call    write_string
        add     esp, 4

        push    expected_label
        call    write_string
        add     esp, 4

        push    dword [ebp + 12]        ; expected
        call    write_string
        add     esp, 4

        push    actual_label
        call    write_string
        add     esp, 4

        push    dword [ebp + 16]        ; actual
        call    write_string
        add     esp, 4

        push    line_feed
        call    write_string
        add     esp, 4

.exit_judge:
        pop     ebp
        ret

.compare_string:
        ; int compare_string(char* str1, char* str2)
        ; return: 0 => str1 == str2, positive => str1 > str2, negative => str1 < str2
        push    ebp
        mov     ebp, esp
        xor     eax, eax

        mov     esi, [ebp + 8]          ; str1
        mov     edi, [ebp + 12]         ; str2

.compare_loop:
        mov     al, byte [esi]
        mov     ah, byte [edi]

        cmp     al, ah
        jnz     .different              ; detect difference

        or      al, al
        jz      .exit_compare_string    ; detect end of string

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
        ; void solve(char* input, char* output)
        push    ebp
        mov     ebp, esp
        push    esi

        push    edi
        mov     esi, dword [ebp + 8]    ; input
        mov     edi, dword [ebp + 12]   ; output

        mov     al, byte [esi]
        mov     byte [edi], al          ; copy first charactor from input to output
        inc     esi

.solve_loop:
        mov     al, byte [esi]          ; get charactor from input
        inc     esi
        or      al, al
        jz      .exit_solve             ; detect end of string

        and     al, 1                   ; 'W' & 1 => 1, 'R' & 1 => 0
        mov     ah, byte [edi]          ; read previouse charactor
        inc     edi
        sub     ah, 'A'                 ; convert charactor to index
        shl     ah, 1                   ; ah = index * 2
        add     al, ah                  ; al = index * 2 + 1
        movsx   eax, al                 ; expand 8 bit to 32 bit
        mov     al, byte [star + eax]   ; get next charactor
        mov     byte [edi], al
        jmp     .solve_loop

.exit_solve:
        inc     edi
        mov     byte [edi], 0           ; set end of string NULL
        pop     edi

        pop     esi
        pop     ebp
        ret

section .text
write_string:
        ; void write_string(char* str)
        push    ebp
        mov     ebp, esp
        push    esi

        mov     esi, [ebp + 8]          ; str
        xor     eax, eax                ; clear counter zero
.count_string_size:
        cmp     byte [esi + eax], 0
        jz      .start_writing          ; detect end of string
        inc     eax
        jmp     .count_string_size

.start_writing:
        push    dword eax               ; size
        push    dword [ebp + 8]         ; buffer
        push    dword 1                 ; file descriptor: stdout
        mov     eax, 4                  ; system call: write
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
star:           db  'HIDGJAFIBCHADEJCFGBE'
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
