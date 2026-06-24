N = 20;
a = 1;
b = 3;
yo = 0;
h = (b-a) / N;

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
y(2)=-h;

function [u]=fun_g(x) // solução exata
    u = -0.5*x^2+0.3/x^2+x^3/5;
endfunction

alfa=1;
beta=2*h^2+3*h-2;
gama=1-3*h; 

for i=1:N+1
    x(i)=a+(i-1)*h;
    alfa(i)=x(i)^2;
    beta(i)=-(2*x(i)^2+h*x(i)+4*h^2);
    gama(i)=x(i)^2+h*x(i);
    F(i)=h^2*x(i)^3;
    z(i) = fun_g(x(i)); //solução exata
end

for i=2:N;
    y(i+1)=(F(i)-alfa(i)*y(i-1)-beta(i)*y(i))/gama(i);
    
end
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
