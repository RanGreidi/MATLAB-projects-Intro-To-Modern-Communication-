%% 1.1
[v_m,fs] = audioread('in-the-air.wav');
Ts=1/fs;
N=length(v_m);
t = 0:Ts:(N-1)*Ts;
f = linspace(-fs/2,fs/2,N);
V_m = fftshift(fft(v_m)) /sqrt(N);

figure 
subplot(2,1,1);
plot(t,v_m)
xlabel('t[sec]', 'FontSize', 11);
ylabel('v_m', 'FontSize', 11);

subplot(2,1,2);    
plot(f,V_m)
xlabel('f[Hz]', 'FontSize', 11);
ylabel('V_m frequency domain', 'FontSize', 11);

bandwidth=1.1*10^4;
%% 1.2 FM modulation
fc=15*10^3;

v_FM = fmmod(v_m,fc,fs,10^4);

%% 1.3 noise creation
z=0.02*randn(1,N);
x_r=v_FM + z';
X_r = fftshift(fft(x_r)) /sqrt(N);

figure 
subplot(2,1,1);
plot(t,x_r)
xlabel('t[sec]', 'FontSize', 11);
ylabel('x_r', 'FontSize', 11);

subplot(2,1,2);    
plot(f,X_r)
xlabel('f[Hz]', 'FontSize', 11);
ylabel('X_r frequency domain', 'FontSize', 11);
                         
%% demodulation

%x_r=bandpass(x_r,[(15-1.1)*10^3 (15+1.1)*10^3],fs);
%x_r=bandpass(x_r,[(-15-1.1)*10^3 (-15+1.1)*10^3],fs);
%x_r = lowpass(x_r,150);

x_d=fmdemod(x_r,fc,fs,10^4);
X_d = fftshift(fft(x_d)) /sqrt(N);

figure
plot(f,X_d)
hold on    
plot(f,V_m)
xlabel(' ', 'FontSize', 11);
ylabel(' ', 'FontSize', 11);
legend('X_d','V_m')

xcorr(x_d,v_m,0,'coeff')
