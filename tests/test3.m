clc, clear, close all;

n = 60;
dataIn = randi([0 1], 1, n);

M = 8;
k = log2(M);

Fs = 30e3;
fc = 1e3;
d = 0.01;

t = 0 : 1/Fs : d - (1/Fs);

%PSK

S_psk = zeros(8, length(t));

for i = 1 : M
    temp = cos(2*pi*fc*t + (i-1)*2*pi/M);
    for j = 1 : length(t)
        S_psk(j) = temp(j); % square wave multiplier?
    end 
end

psk = [];

for i = 1:n
    psk = [psk, S_psk(i)];
end



