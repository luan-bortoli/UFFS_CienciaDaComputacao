#2121101061 - Luan Bortoli
			.data
msg_bem_vindo:		.asciz "Bem-vindo ao Blackjack!\n"
msg_jogar: 		.asciz "\nDeseja jogar? (1 - Sim, 2 - Não): "
msg_pedir_cartas:	.asciz "Deseja pedir mais cartas? (1 - Sim, 2 - Não): "
msg_total_cartas: 	.asciz "Total de Cartas: "
msg_pontuacao: 		.asciz "\nPontuação: "
msg_pontuacao_dealer: 	.asciz "\n\tDealer: "
msg_pontuacao_jogador: 	.asciz "\n\tJogador: "

msg_jogador_recebe: 	.asciz "O jogador recebe: "
msg_dealer_recebe:	.asciz "O dealer recebe: "

msg_mao_jogador:	.asciz "A mão do jogador é: "
mao_jogador:		.space 52
msg_mao_dealer:		.asciz "A mão do dealer é: "
mao_dealer:		.space 52

sinal_soma:		.asciz " + "
sinal_igual:		.asciz " = "

pontos_dealer:		.word 0
pontos_jogador:		.word 0

msg_dealer_venceu:	.asciz "O dealer venceu!\n\n"
msg_jogador_venceu:	.asciz "O jogador venceu!\n\n"
msg_empate:		.asciz "O jogador e dealer empataram!\n\n"
msg_dealer_estourou:	.asciz "O dealer estourou! O jogador venceu!\n\n"
msg_jogador_estourou: 	.asciz "O jogador estourou! O dealer venceu!\n\n"

cartas: 		.word 1,2,3,4,5,6,7,8,9,10,11,12,13 	#Representação das cartas
valores_cartas:		.word 11,2,3,4,5,6,7,8,9,10,10,10,10 	#Valores das cartas, o As iniciará valendo 11
qtd_cartas_disponiveis:	.word 4,4,4,4,4,4,4,4,4,4,4,4,4 	#Quantidade de cartas disponiveis inicialmente para jogada

			.text
main:
	la a0, msg_bem_vindo				#Imprimir mensagem de bem-vindo
	li a7, 4
	ecall
	
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	
	la a0, msg_total_cartas				#Imprimir total de cartas
	li a7, 4
	ecall
	
	li a0, 52					#Total de cartas inicialmente
	li a7, 1
	ecall
	
	la a0, msg_pontuacao				#Imprimir label de pontuação
	li a7, 4
	ecall
	
	la a0, msg_pontuacao_jogador			#Imprimir label da pontuação do jogador
	li a7, 4
	ecall
	lw a0, pontos_jogador				#Imprimir quantidade de pontos jogador
	li a7, 1
	ecall
	
	la a0, msg_pontuacao_dealer			#Imprimir pontuação dealer
	li a7, 4
	ecall
	
	lw a0, pontos_dealer				#Imprimir quantidade de pontos dealer
	li a7, 1
	ecall
	
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	
	j iniciar_rodada				#Ir para o rótulo de iniciar rodada

#Rotina para restaurar cartas ao baralho (4 cópias de cada)
restaurar_cartas_iniciais:
	la t0, qtd_cartas_disponiveis
	li t1, 13					#Número total de tipos de cartas

redefinir_cartas_disponiveis:
	li t2, 4
	sw t2, 0(t0)
	addi t0, t0, 4
	addi t1, t1, -1
	bnez t1, redefinir_cartas_disponiveis
	j contagem_cartas_disponiveis

iniciar_rodada:						#Prepara uma nova rodada zerando variáveis e mãos
	li t6, 0					#Zera acumulador da mão do jogador
	li t5, 0					#Zera acumulador da mão do dealer
	la s1, mao_jogador				#Ponteiro para a mão do jogador
	la s2, mao_dealer				#Ponteiro para a mão do dealer
	li t0, 52					#Tamanho da mão (bytes)
	li t1, 0					#Índice para zerar a mão
	
#Limpar a mão do jogador	
iniciar_limpeza_mao_jogador:
	li t1, 0
	la s1, mao_jogador
	
zerar_mao_jogador:
	li t2, 52
	bge t1, t2, iniciar_limpeza_mao_dealer
	sb zero, 0(s1)
	addi s1, s1, 1
	addi t1, t1, 1
	j zerar_mao_jogador

#Limpar a mão do dealer
iniciar_limpeza_mao_dealer:
	li t1, 0
	la s2, mao_dealer

zerar_mao_dealer:
	li t2, 52
	bge t1, t2, pedir_inicio_jogo
	sb zero, 0(s2)
	addi s2, s2, 1
	addi t1, t1, 1
	j zerar_mao_dealer

pedir_inicio_jogo:
	la a0, msg_jogar				#Pergunta se o jogador deseja jogar
	li a7, 4
	ecall
	li a7, 5
	ecall
	li t0, 2
	beq a0, t0, fim					#Encerra se a resposta for não (2)

iniciar_jogo_jogador:					#Inicia a jogada do jogador com duas cartas e mostra a mão
	la s1, mao_jogador
	jal comprar_carta_jogador
	jal comprar_carta_jogador
	jal exibir_msg_mao_jogador

comprar_mais_cartas_jogador:				#Laço para jogador continuar comprando cartas			
	la a0, msg_pedir_cartas				#Pede se deseja comprar mais cartas
	li a7, 4
	ecall
	li a7, 5
	ecall
	li t0, 2
	beq a0, t0, iniciar_jogada_dealer		#Senão comprar mais cartas, o dealer inicia a jogada
	jal comprar_carta_jogador
	jal exibir_msg_mao_jogador
	li t0, 21
	bgt t6, t0, iniciar_jogada_dealer		#Se estourar 21 pontos, o dealer inicia a jogada
	j comprar_mais_cartas_jogador
	
comprar_carta_jogador:					#Rotina de comprar cartas pelo jogador
	li a0, 0 					#Sorteio cartas jogador (Uso do RandIntRange)
	li a1, 12
	li a7, 42
	ecall
	mv t2, a0
	
	la t3, qtd_cartas_disponiveis			#Verifica se ainda existe copias da carta sorteada
	slli t4, t2, 2
	add t3, t3, t4
	lw t0, 0(t3)
	beqz t0, comprar_carta_jogador			#Se não houver a carta disponível sorteia uma nova
	
	addi t0, t0, -1					#Atualiza a quantidade de cartas
	sw t0, 0(t3)
	
	la t3, valores_cartas				#Soma valor ao total do jogador
	slli t4, t2, 2
	add t3, t3, t4
	lw t0, 0(t3)
	add t6, t6, t0
	
	li t3, 17
	ble t6, t3, processar_carta_jogador
	li t4, 0
	beq t2, t4, decrementa_valor_as_jogador 	#Regra do valor do Ás para o jogador
	j processar_carta_jogador

decrementa_valor_as_jogador:
	addi t6, t6, -10

processar_carta_jogador:
	la a0, msg_jogador_recebe			#Exibe a mensagem e valor da carta que o jogador recebeu
	li a7, 4
	ecall
	
	addi t2, t2, 1					#Ajusta índice da carta para exibição (0–12 → 1–13)
	mv a0, t2					#Prepara valor para imprimir
	li a7, 1
	ecall
	
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	
	sb t2, 0(s1)					#Armazena a carta sorteada na mão do jogador
	addi s1, s1, 1					#Avança ponteiro para próxima posição da mão
	ret
	
exibir_msg_mao_jogador:					#Exibe mensagem da mão do jogador
	la a0, msg_mao_jogador
	li a7, 4
	ecall
	la t3, mao_jogador

cartas_mao_jogador: 					#Imprime cartas que estao na mão do jogador
	lbu t2, 0(t3)				
	beqz t2, soma_valor_cartas_mao_jogador
	
	mv a0, t2
	li a7, 1
	ecall
	
	addi t3, t3, 1
	lbu t1, 0(t3)
	beqz t1, soma_valor_cartas_mao_jogador
	
	la a0, sinal_soma
	li a7, 4
	ecall
	j cartas_mao_jogador
	
soma_valor_cartas_mao_jogador:				#Imprime somatório dos valores da cartas da mão do jogador
	la a0, sinal_igual
	li a7, 4
	ecall
	
	mv a0, t6
	li a7, 1
	ecall
	
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	ret

iniciar_jogada_dealer:					#Rotina de inicio de jogada do dealer
	la s2, mao_dealer
	jal comprar_carta_dealer
	jal comprar_carta_dealer
	jal exibir_msg_mao_dealer
	
	li t0, 21
	bgt t6, t0, fim_dealer_jogo			#Se o jogador atingiu 21 pontos, dealer não joga

comprar_mais_cartas_dealer:				#Laço para dealer continuar comprando cartas até somar 17 ou mais
	li t0, 17
	bge t5, t0, fim_dealer_jogo
	jal comprar_carta_dealer
	jal exibir_msg_mao_dealer
	j comprar_mais_cartas_dealer

comprar_carta_dealer:					#Compra de carta pelo dealer
	li a0, 0					#Sorteio cartas dealer (Uso do RandIntRange)
	li a1, 12
	li a7, 42
	ecall
	mv t2, a0
	
	la t3, qtd_cartas_disponiveis			#Verifica se ainda existe copias da carta sorteada
	slli t4, t2, 2
	add t3, t3, t4
	lw t0, 0(t3)
	beqz t0, comprar_carta_dealer			#Se não houver a carta disponível sorteia uma nova
	
	addi t0, t0, -1					#Atualiza a quantidade de cartas
	sw t0, 0(t3)
	
	la t3, valores_cartas				#Soma valor ao total do dealer
	slli t4, t2, 2
	add t3, t3, t4
	lw t0, 0(t3)
	add t5, t5, t0
	
	li t3, 17
	ble t5, t3, processar_carta_dealer
	li t4, 0
	beq t2, t4, decrementa_valor_as_dealer		#Regra do valor do Ás para o dealer
	j processar_carta_dealer

decrementa_valor_as_dealer:
	addi t5, t5, -10

processar_carta_dealer:
	la a0, msg_dealer_recebe			#Exibe a mensagem e valor da carta que o dealer recebeu
	li a7, 4
	ecall
	
	addi t2, t2, 1					#Ajusta índice da carta para exibição (0–12 → 1–13)
	mv a0, t2					#Prepara valor para imprimir
	li a7, 1
	ecall

	li a0, 10					#Nova linha
	li a7, 11
	ecall
	
	sb t2, 0(s2)					#Armazena a carta sorteada na mão do jogador
	addi s2, s2, 1					#Avança ponteiro para próxima posição da mão
	ret

exibir_msg_mao_dealer:					#Exibe mensagem da mão do jogador
	la a0, msg_mao_dealer
	li a7, 4
	ecall
	la t3, mao_dealer

cartas_mao_dealer:					#Imprime cartas que estao na mão do dealer
	lbu t2, 0(t3)
	beqz t2, soma_valor_cartas_mao_dealer
	
	mv a0, t2
	li a7, 1
	ecall
	
	addi t3, t3, 1
	lbu t1, 0(t3)
	beqz t1, soma_valor_cartas_mao_dealer
	
	la a0, sinal_soma
	li a7, 4
	ecall
	j cartas_mao_dealer

soma_valor_cartas_mao_dealer:				#Imprime somatório dos valores da cartas da mão do dealer
	la a0, sinal_igual
	li a7, 4
	ecall
	
	mv a0, t5
	li a7, 1
	ecall
	
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	li a0, 10					#Nova linha
	li a7, 11
	ecall
	ret

fim_dealer_jogo:					#Finalização da rodada após o dealer jogar
	j eh_vencedor
	
eh_vencedor:
	li t0, 21					#Valor máximo para pontuar
	bgt t6, t0, jogador_estourou 			#Se o jogador passar de 21, dealer ganha
	bgt t5, t0, dealer_estourou			#Se o dealer passar de 21, jogador ganha
	blt t6, t5, dealer_venceu			#Se o dealer tiver mais pontos que o jogador, dealer ganha
	blt t5, t6, jogador_venceu			#Se o jogador tiver mais pontos que o dealer, jogador ganha
	j empate					#Se as pontuações forem iguais, é empate

dealer_estourou:
	la a0, msg_dealer_estourou
	li a7, 4
	ecall
	j somar_ponto_jogador

jogador_venceu:
	la a0, msg_jogador_venceu
	li a7, 4
	ecall
	j somar_ponto_jogador
	
somar_ponto_jogador:
	la t2, pontos_jogador
	lw t1, 0(t2)
	addi t1, t1, 1
	sw t1, 0(t2)
	j fim_rodada
	
jogador_estourou:
	la a0, msg_jogador_estourou
	li a7, 4
	ecall
	j somar_ponto_dealer

dealer_venceu:
	la a0, msg_dealer_venceu
	li a7, 4
	ecall
	j somar_ponto_dealer
	
somar_ponto_dealer:
	la t2, pontos_dealer
	lw t1, 0(t2)
	addi t1, t1, 1
	sw t1, 0(t2)
	j fim_rodada

empate:
	la a0, msg_empate
	li a7, 4
	ecall
	j fim_rodada

fim_rodada:
	li t0, 0					#Inicializa contador de cartas usadas
	li t1, 13					#Número total de tipos de cartas
	la t2, qtd_cartas_disponiveis			#Ponteiro para vetor com quantidades restantes de cada carta

verificar_necessidade_restaurar_baralho:
	lw t3, 0(t2)					#Carrega quantidade disponível da carta atual
	add t0, t0, t3					#Soma ao total de cartas disponíveis
	addi t2, t2, 4					#Avança para próxima carta no vetor
	addi t1, t1, -1					#Decrementa contador de tipos de carta
	bnez t1, verificar_necessidade_restaurar_baralho#Repete para todas as 13 cartas

	li t2, 52					#Total de cartas no baralho
	sub t0, t2, t0					#Calcula número de cartas que já foram usadas
	li t3, 40					#Limite de cartas usadas antes de restaurar baralho
	bge t0, t3, restaurar_cartas_iniciais		#Se >= 40 cartas usadas, restaurar baralho

contagem_cartas_disponiveis:
	li t0, 0					#Inicializa contador de cartas disponíveis
	li t1, 13					#Número total de tipos de cartas
	la t2, qtd_cartas_disponiveis			#Ponteiro para vetor de disponibilidade

exibir_total_cartas:
	lw t3, 0(t2)					#Carrega quantidade da carta atual
	add t0, t0, t3					#Soma ao total geral de cartas disponíveis
	addi t2, t2, 4					#Avança para próxima carta
	addi t1, t1, -1					#Decrementa contador de tipos
	bnez t1, exibir_total_cartas			#Continua até contar todas as cartas

exibir_status_jogo:
	la a0, msg_total_cartas				#Imprime total de cartas na tela
	li a7, 4
	ecall
	
	mv a0, t0					#Exibe o número de cartas disponíveis
	li a7, 1
	ecall

	la a0, msg_pontuacao				#Imprimir label pontuação
	li a7, 4
	ecall

	la a0, msg_pontuacao_jogador			#Imprimir label da pontuação do jogador
	li a7, 4
	ecall
	lw a0, pontos_jogador				#Imprimir quantidade de pontos jogador
	li a7, 1
	ecall

	la a0, msg_pontuacao_dealer			#Imprimir label da pontuação do dealer
	li a7, 4
	ecall
	lw a0, pontos_dealer				#Imprimir quantidade de pontos do dealer
	li a7, 1
	ecall
	
	li a0, 10					#Nova linha
	li a7, 11
	ecall

	j iniciar_rodada
	
fim:							#Encerramento do jogo
	li a7, 10
	ecall