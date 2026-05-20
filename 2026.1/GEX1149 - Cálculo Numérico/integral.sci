a=0;
b=1;
n=8
h=(b-a)/n

function u=fun_f(x);
    u=exp(-x^2);
endfunction

x=zeros(n+1);
y=zeros(n+1);
for i=1:n+1
    x(i)=a+(i-1)*h;
    y(i)=fun_f(x(i));
end
S=zeros(n+1,2)
for i=1:n+1
    S(i,1)=x(i);
    S(i,2)=y(i);
end
//x=x
//y=y
S=S
soma=y(1)+y(n+1);
for i=2:n
    soma=soma+2*y(i);
end

Integral=h*soma/2
