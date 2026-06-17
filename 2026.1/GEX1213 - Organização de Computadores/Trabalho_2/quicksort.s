.section .data
vetor: .word 0, -12, 35, -7, 89
espaco: .ascii " "
nova_linha: .ascii "\n"

.section .bss
    .align 4
buffer_int: .skip 32

.section .text
.globl _start

_start:
    la s0, vetor        # s0 = ponteiro para o vetor
    li s1, 5          # s1 = tamanho do vetor

    mv a0, s0           # a0 = endereço base do vetor
    li a1, 0            # a1 = índice inicial
    li a2, 4           # a2 = índice final
    jal ra, quicksort

    li t1, 0            # t1 = contador i = 0

print_loop:
    beq t1, s1, fim

    slli t0, t1, 2      # t0 = i * 4
    add  t0, s0, t0     # t0 = &vetor[i]
    lw   a0, 0(t0)      # a0 = vetor[i]

    addi sp, sp, -16
    sd   t1, 0(sp)
    jal  ra, print_int
    ld   t1, 0(sp)
    addi sp, sp, 16

    # Imprime espaço
    li a0, 1            # stdout
    la a1, espaco       # endereço do caractere espaço
    li a2, 1            # quantidade de bytes
    li a7, 64           # syscall write
    ecall

    addi t1, t1, 1      # i++
    j print_loop

print_int:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp)

    mv s0, a0           # s0 = número a ser impresso
    la s1, buffer_int   # s1 = início do buffer
    addi s2, s1, 31     # s2 = final do buffer
    mv s3, s2           # s3 = posição atual no buffer
    li s4, 0            # s4 = flag de número negativo

    # Se o número for positivo ou zero, vai direto para a conversão
    bge s0, zero, print_loop_conversao
    li s4, 1            # marca que o número é negativo
    sub s0, zero, s0    # transforma em positivo

print_loop_conversao:
    li t2, 10           # divisor
    li t3, 0            # quociente
    mv t4, s0           # valor usado para calcular o resto

print_divide_por_10:
    blt t4, t2, print_salva_digito

    sub t4, t4, t2      # t4 = t4 - 10
    addi t3, t3, 1      # quociente++
    j print_divide_por_10

print_salva_digito:
    addi t4, t4, '0'    # converte o resto para ASCII
    addi s3, s3, -1
    sb t4, 0(s3)

    mv s0, t3           # s0 recebe o quociente
    bne s0, zero, print_loop_conversao

    beq s4, zero, print_escreve_numero

    # Adiciona sinal negativo
    addi s3, s3, -1
    li t4, '-'
    sb t4, 0(s3)

print_escreve_numero:
    fence               # garante que a escrita no buffer seja concluída antes do write

    li a0, 1            # stdout
    mv a1, s3           # endereço inicial da string
    sub a2, s2, s3      # tamanho da string
    li a7, 64           # syscall write
    ecall

    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48
    ret

quicksort:
    addi sp, sp, -48

    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)

    mv s0, a0           # s0 = vetor
    mv s1, a1           # s1 = início
    mv s2, a2           # s2 = fim

    bge s1, s2, quick_end

    mv a0, s0
    mv a1, s1
    mv a2, s2
    jal ra, particiona

    mv s3, a0           # s3 = posição do pivô

    mv   a0, s0
    mv   a1, s1
    addi a2, s3, -1
    jal ra, quicksort

    mv   a0, s0
    addi a1, s3, 1
    mv   a2, s2
    jal ra, quicksort

quick_end:
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)

    addi sp, sp, 48
    ret

particiona:
    addi sp, sp, -64

    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)

    mv s0, a0           # s0 = vetor
    mv s1, a1           # s1 = início
    mv s2, a2           # s2 = fim

    slli t0, s2, 2
    add  t0, s0, t0
    lw   s3, 0(t0)      # s3 = pivô

    mv s4, s1           # s4 = k = início
    mv s5, s1           # s5 = i = início

for_loop:
    bge s5, s2, fim_for

    slli t0, s5, 2
    add  t0, s0, t0
    lw   t1, 0(t0)      # t1 = vetor[i]

    # Equivalente a: se vetor[i] > pivô, não troca
    blt s3, t1, nao_troca

    mv  a0, s0
    mv  a1, s5          # a1 = i
    mv  a2, s4          # a2 = k
    jal ra, troca

    addi s4, s4, 1      # k++

nao_troca:
    addi s5, s5, 1      # i++
    j for_loop

fim_for:
    slli t0, s4, 2
    add  t0, s0, t0
    lw   t1, 0(t0)      # t1 = vetor[k]

    # Equivalente a: se vetor[k] <= pivô, pula a troca final
    bge s3, t1, pula_troca_final

    mv  a0, s0
    mv  a1, s4          # a1 = k
    mv  a2, s2          # a2 = fim
    jal ra, troca

pula_troca_final:
    mv a0, s4           # retorna k

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)

    addi sp, sp, 64
    ret

troca:
    slli t0, a1, 2
    add  t0, a0, t0     # t0 = &vetor[i]

    slli t1, a2, 2
    add  t1, a0, t1     # t1 = &vetor[j]

    lw t2, 0(t0)        # t2 = vetor[i]
    lw t3, 0(t1)        # t3 = vetor[j]

    sw t3, 0(t0)        # vetor[i] = vetor[j]
    sw t2, 0(t1)        # vetor[j] = vetor[i]

    ret

fim:
    # Imprime quebra de linha
    li a0, 1
    la a1, nova_linha
    li a2, 1
    li a7, 64           # syscall write
    ecall

    # Encerra o programa
    li a0, 0            # código de saída 0
    li a7, 93           # syscall exit
    ecall
