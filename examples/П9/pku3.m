
%Неизменяемая часть
K_L = 1;
T_L = 2.2e-4;
K_x = 4.7e-4;
T_x = 1.25e-3;
E_x = 0.2;
K_gp = 3131;
K4 = 1.2e5;
K5 = 1;
K6 = 1.16e-3;
K7 = 2e-4;

W1 = tf([K_L],[T_L 1]);
W2 = tf([K_x], [ T_x^2 2*E_x*T_x 1]);
W3 = tf([K_gp], [1 0]);
W4 = tf([K4], [1 0]);
W5 = tf([K5], [1 0]);
W6 = tf([K6], [1]);

W123 = feedback(W1*W2*W3, 1);
W123 = minreal(W123);
W46 = feedback(W4, W6);
W465 = feedback( W46*W5, 1);
Wob = W123*W465;
Wobo = feedback(Wob, 1/W5);
Wobo=Wobo*K7;
Wobo = minreal(Wobo);
Wobo;

Wobo_ = feedback(Wobo, 1);


% pku creation
 

kj=5256136985801138300000000;

wj1=tf(1,[1 1e5]);
wj2=tf(1,[1 4.677e4]);
wj3=tf(1,[1 2.137e4]);
wj4=tf(1,[1 1e4]);
wj5=tf(1,[1 7981]);
wj6=tf(1,[1 0.5953]);


% PKY transfer fcn
Wj = wj1*wj2*wj3*wj4*wj5*wj6*kj;
Wj = minreal(Wj)
Wj1=feedback(Wj,1);
step(Wj1);

W_pku = Wj/Wobo;
W_pku = minreal(W_pku);
zpk(W_pku)





