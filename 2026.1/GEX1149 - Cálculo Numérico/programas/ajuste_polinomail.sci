//Ajuste polinomial
p = 2; //Grau do Polinômio
//n = 8; //Número de Pontos

x = [-1 0 1 2 3 3.5 4 4.5 5];
y = [2 1 -1 0 1 2 3 4 4]

[m,n]= size(x);

X = zeros(n, p+1);
for i=1:n
	X(i,1)=1;
	for j=1:p
		X(i,j+1) = x(i)^j;
	end
end
X=X
A=X'*X
C=X'*y'
//Eliminação de Gauss/Jordan/Matriz Inversa
B=inv(A)*C
//R^2
for i=1:n
    s = 
end
