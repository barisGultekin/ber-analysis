% 8-PSK BER Analysis

clc; clear; close all;

%% Parameters

M = 8;
theta = (0:7) * (2 * pi / 8);
constPoints = exp(1j * theta);
numSymbols = 1e5;

%% Modulation

symbols = randi([0, M-1], numSymbols, 1);
modulatedSignal = constPoints(symbols + 1);

%% BER Analysis over a range of Eb/N0 values

EbN0_dB = 0:5;
EbN0 = 10.^(EbN0_dB/10);
ber_simulated = zeros(size(EbN0));

for k = 1:length(EbN0)

    % Noise
    noiseVariance = 1/(2*log2(M)*EbN0(k));
    noisySignal = modulatedSignal + sqrt(noiseVariance)*(randn(size(modulatedSignal)) + 1j*randn(size(modulatedSignal)));

    % Demodulation
    demodulatedSymbols = zeros(numSymbols, 1);
    for i = 1:numSymbols
        [~, closestPointIndex] = min(abs(noisySignal(i) - constPoints));
        demodulatedSymbols(i) = closestPointIndex - 1;
    end

    % Calculate BER
    numErrors = sum(demodulatedSymbols ~= symbols);
    ber_simulated(k) = numErrors / numSymbols;
    
end

%% Theoretical BER Calculation for 8-PSK

ber_theoretical = (1/log2(M)) * qfunc(sqrt(2*log2(M)*EbN0)*sin(pi/M));

%% Plotting Theoretical vs Simulated BER

figure;
semilogy(EbN0_dB, ber_theoretical, 'b-', 'LineWidth', 2);
hold on;
semilogy(EbN0_dB, ber_simulated, 'rx-');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('Theoretical vs Simulated BER for 8-PSK');
legend('Theoretical', 'Simulated');
grid on;
