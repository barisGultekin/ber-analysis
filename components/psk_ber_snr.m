% psk_ber_snr.m - 8-PSK BER Analysis against SNR

clc; clear; close all;

% Parameters
M = 8;
theta = (0:7) * (2 * pi / M);
constPoints = exp(1j * theta);
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

% Theoretical BER Calculation for 8-PSK
ber_theoretical = (1/log2(M)) * qfunc(sqrt(2*log2(M)*SNR)*sin(pi/M));

% Plotting Theoretical vs Simulated BER vs SNR
figure;
semilogy(SNR_dB, ber_theoretical, 'b-', 'LineWidth', 2);
hold on;
semilogy(SNR_dB, ber_simulated, 'rx-');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('Theoretical vs Simulated BER vs SNR for 8-PSK');
legend('Theoretical', 'Simulated');
grid on;
