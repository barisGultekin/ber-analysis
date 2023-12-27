% qam_ber_snr.m - 8-QAM BER Analysis against SNR

clc; clear; close all;

% Parameters
M = 8;
constPoints = [-3+1j, -3-1j, -1+1j, -1-1j, 3+1j, 3-1j, 1+1j, 1-1j];
numSymbols = 1e6;

% Modulation
symbols = randi([0, M-1], numSymbols, 1);
modulatedSignal = constPoints(symbols + 1);

% BER Analysis over a range of SNR values
SNR_dB = 0:15; % SNR values in dB
SNR = 10.^(SNR_dB/10); % Convert dB to linear scale
ber_simulated = zeros(size(SNR));

for k = 1:length(SNR)
    noiseVariance = 1/(2*SNR(k));
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

% Theoretical BER Calculation
ber_theoretical = 2*(1 - 1/sqrt(M)) * qfunc(sqrt(3*log2(M)*SNR/(M-1)));

% Plotting Theoretical vs Simulated BER vs SNR
figure;
semilogy(SNR_dB, ber_theoretical, 'b-', 'LineWidth', 2);
hold on;
semilogy(SNR_dB, ber_simulated, 'rx-');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('Theoretical vs Simulated BER vs SNR for 8-QAM');
legend('Theoretical', 'Simulated');
grid on;
