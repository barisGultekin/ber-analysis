% 8-PSK Modulation & Demodulation Schemes

clc, clear, close all;

%% Parameters

theta = (0:7) * (2 * pi / 8);
constPoints = exp(1j * theta);

numSymbols = 100;
symbols = randi([0 7], numSymbols, 1);

%% Modulation

modulatedSignal = constPoints(symbols + 1);

noiseVariance = 1; % Adjust this for different noise levels
noisySignal = modulatedSignal + sqrt(noiseVariance/2)*(randn(size(modulatedSignal)) + 1j*randn(size(modulatedSignal)));

%% Demodulation

demodulatedSymbols = zeros(numSymbols, 1);
for i = 1:numSymbols
    [~, closestPointIndex] = min(abs(noisySignal(i) - constPoints));
    demodulatedSymbols(i) = closestPointIndex - 1;
end

%% Simulated BER Analysis

numErrors = sum(demodulatedSymbols ~= symbols);
ber_simulated = numErrors / numSymbols;
disp(['Bit Error Rate (BER) for 8-PSK: ', num2str(ber_simulated)]);

%% Plots

% Constellation Diagrams
figure(1)

subplot(311);
plot(real(constPoints), imag(constPoints), 'bo');
hold on;
plot(real(modulatedSignal), imag(modulatedSignal), 'rx');
title('Original 8-PSK Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

subplot(312);
plot(real(noisySignal), imag(noisySignal), 'rx');
title('Noisy 8-PSK Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

subplot(313);
plot(real(constPoints(demodulatedSymbols + 1)), imag(constPoints(demodulatedSymbols + 1)), 'rx');
title('Demodulated 8-PSK Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

% Original and Demodulated Symbols
figure(2)
plot(1:numSymbols, symbols, 'bo-', 1:numSymbols, demodulatedSymbols, 'rx');
legend('Original Symbols', 'Demodulated Symbols');
title('Comparison of Original and Demodulated Symbols for 8-PSK');
xlabel('Symbol Index');
ylabel('Symbol Value');
grid on;
