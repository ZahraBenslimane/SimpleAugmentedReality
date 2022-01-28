function dGx = dGausse(S)
% a fonction [dGx,dGy] = dGausse(S) à qui on passe l’écart type sigma de
% la gaussienne et qui renvoie la dérivée du masque gaussien sur X et sur Y.
x= -3*S:1:3*S;
y= -3*S:1:3*S;
dGx=zeros(length(x));
for i=1:1:length(x)
    for j=1:1:length(x)
        dGx(j,i)= ( -x(i)/(2*pi*S^4) )* exp(- (x(i)^2 +y(j)^2)/(2*S^2));
    end
end
end
