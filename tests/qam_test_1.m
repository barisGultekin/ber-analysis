% EE451 Communication Systems II Project | Group - 18

% 8-QAM Tests

clc, clear, close all;

Fs = 1200;
d = 1;
t = 0 : 1/Fs : d - (1/Fs);
f = 100;

M = 8;
k = log2(M);

x = cos(2*pi*f*t);

%% modulation

% quantization
x_quantized = round(x * (M - 1));

% quantized signal to binary data
dataIn = dec2bin(x_quantized + 1, k);

% bits to symbols
symbols = zeros(1, length(dataIn)/k);

for i = 1:length(symbols)
 bits = dataIn((i-1)*k + 1 : i*k);
 symbol = 0;
 for j = 1:k
 symbol = symbol + bits(j) * 2^(k-j);
 end
 symbols(i) = symbol;
end

% binary data to constellation points
constellation = [1j+1, 1j-1, -1j+1, -1j-1, 1j+3, 1j-3, -1j+3, -1j-3];
constSymbols = constellation(symbols - min(symbols) + 1);

% modulate symbols

sp = 2e-3; % symbol period
f = 3000; % carrier frequency
Qn = 1000; % symbols per second

t = 0 : sp/Qn : sp;
Y = zeros(1, length(constSymbols));

for i = 1:length(constSymbols)
 Y((i-1)*length(t) + 1 : i*length(t)) = constSymbols(i) .* cos(2 * pi * f * t) + constSymbols(i) .* sin(2 * pi * f * t);
end


