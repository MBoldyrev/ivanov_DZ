w=0.1:0.1:10000;
clc;

Kl=1;
Tl=2.2*10^-4;
Kx=4.7*10^-4;
Ex=0.2;
%Всего 3 варианта Tx
%Для M1-M18 Tx: 7 * 10^-4, 1.1*10^-3, 1.2*10^-3
%Для M19-27 Tx: 0.69 * 10^-3, 1.15 * 10^-3, 1.25 * 10^-3
Tx=0.69*10^-3;
Kgp1=353.4;
Kdv=1275.5;
Ip=0.1;
Il=0.002;

W7=tf([Kl],[Tl 1]);
W8=tf([Kx],[Tx^2 2*Ex*Tx 1]);
W10=tf([Kgp1],[1 0]);
W15=tf([Kdv],[1 0]);
W33=3.6*10^-3;
W34=tf([1],[1 0]);
W35=Ip;
W37=Il;

W_78=Series(W7,W8);
W_710=Series(W_78,W10);
W_1=FeedBack(W_710,1);

W_2=FeedBack(W15,W33);

W_3=W35*W37;

W2_6=Series(W_2,W34);
W_2_=FeedBack(W2_6,1);

W_1_2_=Series(W_1,W_2_);
W341=1/W34;
W_1_=FeedBack(W_1_2_,W341);

Wnr=Series(W_1_, W_3);

zpk(Wnr);

figure(1);
bode(Wnr);
grid;
hold;

figure(2); 
  step(feedback(Wnr, 1), 8);
grid;

figure(3);
[u, t]=gensig('sin', 2*pi/1200, 3*2*pi/1200, 0.00001);
sys=tf([1], [0 1]);
H=[sys; FeedBack(Wnr, 1)];
lsim(H, u, t);
hold on;

Tg=5*10^-3;
Kv=6000;

wg=(2*pi)/Tg;
lgwg = log10(wg);
wn=0.14*wg;
lgwn=log10(wn);
wv=7*wg;
lgwv=log10(wv);

lgW_1=0.5;
lgW_2=1.4;
lgW_31=5;
lgW_3=5.2;
lgW_4=5.4;
lgW_5=5.6;
lgW_6=5.8;

w_1=10^lgW_1;
w_2=10^lgW_2;
w_31=10^lgW_31;
w_3=10^lgW_3;
w_4=10^lgW_4;
w_5=10^lgW_5;
w_6=10^lgW_6;


Wg=zpk([-wn],[-w_1 -w_2 -w_31 -w_3 -w_4 -w_5 -w_6], Kv*w_1*w_2*w_31*w_3*w_4*w_5*w_6/wn);

Wpku=Wg/Wnr;
tf(Wpku)
zpk(Wpku);

figure(4);
bode(Wnr,Wg,Wpku);
grid;
hold on;

figure(5);
step(feedback(Wpku*Wnr, 1), 0:1e-4:6e-3);
grid;
hold on;

figure(6);
[u, t]=gensig('sin', 2*pi/1200, 3*2*pi/1200, 0.00001);
sys=tf([1], [0 1]);
H=[sys; feedback(series(Wpku,Wnr),1)];
lsim(H, u, t);
hold on;
