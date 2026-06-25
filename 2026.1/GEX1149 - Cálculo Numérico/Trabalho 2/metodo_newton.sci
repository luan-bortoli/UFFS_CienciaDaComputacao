x0=2
e=10^(-6)
erro=1.0
n=0

function u=fun_f(x);
    u=x^3+2*x^2-3*x-1
endfunction
function u=fun_g(x);
    u=3*x^2+4*x-3
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
