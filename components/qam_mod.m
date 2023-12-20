% 8-QAM Modulation & Demodulation Schemes

clc; clear; close all;

%% Parameters

constPoints = [-3+1j, -3-1j, -1+1j, -1-1j, 3+1j, 3-1j, 1+1j, 1-1j];
numSymbols = 100;
symbols = randi([0 7], numSymbols, 1);

%% Modulation

modulatedSignal = constPoints(symbols + 1);

%% Add Noise

noiseVariance = 0.8;
noisySignal = modulatedSignal + sqrt(noiseVariance/2)*(randn(size(modulatedSignal)) + 1j*randn(size(modulatedSignal)));

%% Demodulation

demodulatedSymbols = zeros(numSymbols, 1);
for i = 1:numSymbols
    [~, closestPointIndex] = min(abs(noisySignal(i) - constPoints));
    demodulatedSymbols(i) = closestPointIndex - 1;
end
demodulatedSignal = constPoints(demodulatedSymbols + 1);

%% BER Analysis

numErrors = sum(demodulatedSymbols ~= symbols);
BER = numErrors / numSymbols;
disp(['Bit Error Rate (BER): ', num2str(BER)]);

%% Plots

% Constellation Diagrams
figure(1);
subplot(311);
plot(real(constPoints), imag(constPoints), 'bo');
hold on;
plot(real(modulatedSignal), imag(modulatedSignal), 'rx');
title('Original Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis([-4 4 -4 4]);
grid on;

subplot(312);
plot(real(noisySignal), imag(noisySignal), 'rx');
title('Noisy Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis([-4 4 -4 4]);
grid on;

subplot(313);
plot(real(demodulatedSignal), imag(demodulatedSignal), 'rx');
title('Demodulated Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis([-4 4 -4 4]);
grid on;

% Original and Demodulated Symbols
figure(2);
plot(1:numSymbols, symbols, 'bo-', 1:numSymbols, demodulatedSymbols, 'rx');
legend('Original Symbols', 'Demodulated Symbols');
title('Comparison of Original and Demodulated Symbols');
xlabel('Symbol Index');
ylabel('Symbol Value');
grid on;
