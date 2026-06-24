N = 50;
a = 0;
b = 1;
yo = 1;
h = (b-a)/N;

x=zeros(N+1, 1);
y=zeros(N+1, 1);
z=zeros(N+1, 1);
e=zeros(N+1, 1);
F=zeros(N+1, 1);
alfa=zeros(N+1, 1);
beta=zeros(N+1, 1);
gama=zeros(N+1, 1);

y(1)=yo;
z(1)=yo;
e(1)=0;
y(N+1)=2;

function [u]=fun_g(x) // solução exata
    u = ((exp(3)+exp(2)-4)*exp(x)+(4-exp(1)-exp(3))*exp(2*x)+(exp(2)-exp(1))*exp(3*x))/(2*exp(1)*(exp(1)-1));
endfunction

for i=1:N+1
    x(i)=a+(i-1)*h;
    alfa(i)=1;
    beta(i)=-2+3*h+2*h^2;
    gama(i)=1-3*h;
    F(i)=h^2*exp(3*x(i));
    z(i) = fun_g(x(i)); //solução exata
end

A=zeros(N-1,N-1);
for i=1:N-1
    A(i,i)=beta(i+1);
end
for i=1:N-2
    A(i,i+1)=gama(i+1);
    A(i+1,i)=alfa(i+2);
end
B=zeros(N-1,1);
B(1,1)=F(2)-alfa(2)*y(1);
B(N-1,1)=F(N)-gama(N)*y(N+1);
for i=2:N-2
    B(i,1)=F(i+1);
end
//Gauss-Seidel
A=A
B=B
W=inv(A)*B;
for i=2:N
    y(i)=W(i-1);
end
W=W
e=abs(z-y);//solução exata - solução calculada
s=zeros(N+1, 4);
for i=1:N+1
    s(i,1) = x(i);
    s(i,2) = y(i);
    s(i,3) = z(i);
    s(i,4) = e(i);
end
s=s
figure;
plot(x,z,'r',x,y,'*');

figure
plot(x,e,'*')
