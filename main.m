% EE451 Communication Systems II Project
% P18 – BER Performance Analysis of Modulation and Demodulation through 8-PSK and 8-QAM Schemes

% Efe Öğüşlü, 2702060XX
% Ali Barış Gültekin, 270206017

clear; clc; close all;

EbNo = 0:14; % Range of Eb/No values (SNR) [dB]
M = 8;       % Modulation order

pskBerTheoretical = berawgn(EbNo, "psk", M, "nondiff");
qamBerTheoretical = berawgn(EbNo, "qam", M, "nondiff");

n = 100;     % Number of bits to processs
numErrs = 0; % Number of errors
numBits = 0; % Number of bits

% k = log2(M); % Number of bits per symbol

%% PSK

pskBerSimulated = zeros(1,length(EbNo)); % Preallocate a vector

for idx = 1:length(EbNo)
    while numErrs < 100
        % Generate binary data
        dataIn1 = randi([0 1],n,1);
        % Modulate using 8-PSK
        txSig = pskmod(dataIn1,M);
        % Pass through AWGN channel
        rxSig = awgn(txSig,EbNo(idx));
        % Demodulate signal
        dataOut1 = pskdemod(rxSig,M);
        % Calculate number of bit errors
        numErrs = numErrs + biterr(dataIn1, dataOut1);
        % Increment the number of bits
        numBits = numBits + n;
    end
    % Calculate the BER
    pskBerSimulated(idx) = numErrs/numBits;
    % Reset the number of errors and bits
    numErrs = 0;
    numBits = 0;
end

figure(1);
title("8-PSK");
semilogy(EbNo, 10*log10(pskBerTheoretical),'r');
hold on;
semilogy(EbNo, 10*log10(pskBerSimulated),'b');
legend('Theoretical PSK BER','Simulated PSK BER');
grid on;

%% QAM

qamBerSimulated = zeros(1,length(EbNo)); % Preallocate a vector

for idx = 1:length(EbNo)
    while numErrs < 100
        % Generate binary data
        dataIn2 = randi([0 1],n,1);
        % Modulate using 8-PSK
        txSig = pskmod(dataIn2,M);
        % Pass through AWGN channel
        rxSig = awgn(txSig,EbNo(idx));
        % Demodulate signal
        dataOut2 = pskdemod(rxSig,M);
        % Calculate number of bit errors
        numErrs = numErrs + biterr(dataIn2, dataOut2);
        % Increment the number of bits
        numBits = numBits + n;
    end
    % Calculate the BER
    qamBerSimulated(idx) = numErrs/numBits;
    % Reset the number of errors and bits
    numErrs = 0;
    numBits = 0;
end

figure(2);
title("8-QAM");
semilogy(EbNo, 10*log10(qamBerTheoretical),'r');
hold on;
semilogy(EbNo, 10*log10(qamBerSimulated),'b');
legend('Theoretical QAM BER','Simulated QAM BER');
grid on;

% Create a new figure for the comparison plots
figure(3);
title("Message Signal vs Original Signal");

%% Message Signal vs Received Signal

% PSK comparison
subplot(2,1,1);
stem(dataIn1, 'b'); % Original signal
hold on;
stem(dataOut1, '--r'); % Modulated signal
legend('Original Signal', 'Modulated Signal');
xlabel('Time');
ylabel('Amplitude');
title('PSK Modulation');

% QAM comparison
subplot(2,1,2);
stem(dataIn2, 'b'); % Original signal
hold on;
stem(dataOut2, '--r'); % Modulated signal
legend('Original Signal', 'Modulated Signal');
xlabel('Time');
ylabel('Amplitude');
title('QAM Modulation');