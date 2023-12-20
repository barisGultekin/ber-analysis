% 8-QAM BER Analysis

clc; clear; close all;

%% Parameters

M = 8;

constPoints = [-3+1j, -3-1j, -1+1j, -1-1j, 3+1j, 3-1j, 1+1j, 1-1j];
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

%% Theoretical BER Calculation

ber_theoretical = 2*(1 - 1/sqrt(M)) * qfunc(sqrt(3*log2(M)*EbN0/(M-1)));

%% Plotting Theoretical vs Simulated BER

figure;
semilogy(EbN0_dB, ber_theoretical, 'b-', 'LineWidth', 2);
hold on;
semilogy(EbN0_dB, ber_simulated, 'rx-');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('Theoretical vs Simulated BER for 8-QAM');
legend('Theoretical', 'Simulated');
grid on;
