close all, clear all, clc; 

x = linspace(-1,1,255);
f_x = 255 ./(1 + exp(-1 * (x )*1));
g_x = 255 ./(1 + exp(-1 * (x )*4));
h_x = (-255 ./(1 + exp(-1 * (x )*4))+255);
hold on 
plot(x,f_x)
plot(x,g_x)
%plot(x,h_x)
legend()
hold off