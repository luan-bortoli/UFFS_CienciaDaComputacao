N = 80;
a = 0;
b = 2;
yo = 2;
h = 0.025;

x=zeros(N+1, 1);
y=zeros(N+1, 1);
z=zeros(N+1, 1);
e=zeros(N+1, 10);
x(1)=a;
y(1)=yo;
z(1)=yo;
e(1)=0;

function [u]=fun_f(x,y)
    u = 4 - 2 * x
endfunction
function [u]=fun_g(x) // solução exata
    u = -x^2 + 4 * x + 2
endfunction

for i=1:N;
    x(i+1) = x(i)+h;
    k1=h*fun_f(x(i),y(i));
    k2=h*fun_f(x(i)+h/2,y(i)+k1/2);
    k3=h*fun_f(x(i)+h/2,y(i)+k2/2);
    k4=h*fun_f(x(i+1),y(i)+k3);
    y(i+1) = y(i)+(k1+2*k2+2*k3+k4)/6;
    z(i+1) = fun_g(x(i+1)); //solução exata
    e(i+1) = abs(y(i+1)-z(i+1));
end

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

