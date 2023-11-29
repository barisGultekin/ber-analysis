% EE451 Communication Systems II Project | Group - 18

% 8-PSK Modulation

clc, clear, close all;

%% Parameters and Data
M = 8;
k = log2(M);
n = 6000;

% Generate random binary data
dataIn = randi([0, 1], 1, n);

% Convert bits to symbols
symbols = zeros(1, length(dataIn)/k);

for i = 1:length(symbols)
 bits = dataIn((i-1)*k + 1 : i*k);
 symbol = 0;
 for j = 1:k
 symbol = symbol + bits(j) * 2^(k-j);
 end
 symbols(i) = symbol;
end

%% Modulation

% Define the constellation points for 8-PSK
constellation = exp(1j * (0:M-1) * 2 * pi / M);

% Map the binary data to the constellation points
symbols = constellation(symbols + 1);

% Modulate symbols
sp = 2e-3;
f = 3000;
Qn = 1000;

t = 0:sp/Qn:sp;
m_original = zeros(1, length(symbols)*length(t));

for i = 1:length(symbols)
 m_original((i-1)*length(t) + 1 : i*length(t)) = symbols(i) .* cos(2 * pi * f * t) + symbols(i) .* sin(2 * pi * f * t);
end

%% Plotting
% Waveform
tt = t;
figure;
plot(tt, m_original(1:length(tt)));
title('Waveform for 8-PSK Modulation');
xlabel('Time (sec)');
ylabel('Amplitude (volt)');
grid on;

% Constellation
figure;
scatter(real(symbols), imag(symbols));
title('Constellation Diagram for 8-PSK Modulation');
xlabel('In-Phase');
ylabel('Quadrature');
grid on;
