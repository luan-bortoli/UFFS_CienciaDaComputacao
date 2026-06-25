import numpy as np

def criterio_linhas(A):
    n = A.shape[0]
    alpha = 0.0
    for i in range(n):
        soma = np.sum(np.abs(A[i])) - np.abs(A[i, i])
        alpha = max(alpha, soma / np.abs(A[i, i]))
    return alpha


# A: matriz dos coeficientes | b: termos independentes | chute: aproximacao inicial
# erro: precisao desejada | N: numero maximo de iteracoes
def jacobi(A, b, chute, erro=10**(-5), N=1000):
    alpha = criterio_linhas(A)
    if alpha >= 1:
        print(f"Aviso: criterio das linhas nao satisfeito (alpha = {alpha:.4f}).")

    n = b.size
    x = np.copy(chute).astype(float)
    swap = np.zeros(n)

    for k in range(1, N + 1):
        for i in range(n):
            soma = np.sum(A[i] * x) - A[i, i] * x[i]   # soma dos termos j != i
            swap[i] = (b[i] - soma) / A[i, i]

        dif = np.linalg.norm(swap - x)                 # criterio de parada: ||x^(k+1) - x^(k)||
        print(f"Iteracao {k}: x = {swap}, erro = {dif:.2e}")

        if dif < erro:
            return swap, k
        x = np.copy(swap)

    return swap, N


# ----------------------------------------------------------------------
#   5x -  y + 2z + 2w =  3
#   2x - 4y +  z -  w = -2
#    x + 2y + 4z +  w =  6
#   -x +  y + 2z + 6w =  4
# ----------------------------------------------------------------------
A = np.array([[ 5.0, -1.0, 2.0,  2.0],
              [ 2.0, -4.0, 1.0, -1.0],
              [ 1.0,  2.0, 4.0,  1.0],
              [-1.0,  1.0, 2.0,  6.0]])

b = np.array([3.0, -2.0, 6.0, 4.0])

chute = np.zeros(4)   # X0 = [0 0 0 0]^t

solucao, iteracoes = jacobi(A, b, chute, erro=10**(-5))

print("\nResultado")
print(f"Solucao:    x = {solucao[0]:.6f}, y = {solucao[1]:.6f}, "
      f"z = {solucao[2]:.6f}, w = {solucao[3]:.6f}")
print(f"Iteracoes:  {iteracoes}")