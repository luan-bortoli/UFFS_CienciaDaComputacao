x0=3
e=10^(-5)
erro=1.0
n=0
function u=fun_f(x);
    u=x*log10(x)-1;
endfunction
function u=fun_g(x);
    u=log10(x)+1/log(10);
endfunction
while erro>e
    n=n+1;
    x1=x0-fun_f(x0)/fun_g(x0);
    erro=abs(x1-x0);
    x0=x1;
end
xn=x0
n=n
erro=erro
