
subplot(1,2,1)
x = linspace(0,4,100);
y = tanh(-x);
z = 1./(1+exp(x));
plot(x,y,'r'); hold on; plot(x,z,'b');
legend('tanh','sig'); xlabel('x')

subplot(1,2,2)
% xx = linspace(0,3,100);
yy = 1-(tanh(-x).^2);
zz = z.*(1-z);
plot(x,yy,'r'); hold on; plot(x,zz,'b');
legend("tanh'","sig'"); xlabel('x')
