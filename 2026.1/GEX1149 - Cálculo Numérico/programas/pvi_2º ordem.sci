N = 10;
a = 0;
b = 1;
yo = -3;
h = (b-a) / N;

x=zeros(N+1, 1);
y=zeros(N+1, 1);
z=zeros(N+1, 1);
e=zeros(N+1, 1);
F=zeros(N+1, 1);

y(1)=yo;
z(1)=yo;
e(1)=0;
y(2)=-5*h/2+y(1);

function [u]=fun_g(x) // solução exata
    u = -3*exp(x)-exp(2*x)/2+exp(3*x)/2
endfunction

alfa=1;
beta=2*h^2+3*h-2;
gama=1-3*h; 

for i=1:N+1
    x(i)=a+(i-1)*h;
    F(i)=h^2*exp(3*x(i));
    z(i) = fun_g(x(i)); //solução exata
end

for i=2:N;
    y(i+1)=(F(i)-alfa*y(i-1)-beta*y(i))/gama;
    
end
e=abs(z-y);
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
