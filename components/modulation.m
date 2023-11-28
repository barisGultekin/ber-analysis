clc, clear, close all;

% Parameters
m = 8;          % Modulation order
k = log2(m);    % Number of bits per symbol
n = 6000;       % Number of bits to process

dataIn = randi([0 1], n, 1);

%% 8-QAM Modulation

% Built-in QAM
dataInSymbols_builtin = bit2int(dataIn, k);
signal_QAM_builtin = qammod(dataInSymbols_builtin, m, 'bin');

% Custom QAM
dataInSymbols_custom = zeros(n/k, 1);
signal_QAM_custom = complex(zeros(n/k, 1));
signal_QAM_custom_const = complex(zeros(n/k, 1));

lookup_table = [-3 -1 1 3];

for i = 1:n/k
    bits = dataIn((i-1)*k+1 : i*k);

    symbol = 0;
    for j = 1:k
        symbol = symbol + bits(j) * 2^(k-j);
    end

    dataInSymbols_custom(i) = symbol;

    I = mod(symbol, sqrt(8)) - (sqrt(8)-1)/2;
    Q = floor(symbol/sqrt(8)) - (sqrt(8)-1)/2;

    I_const = 2 * (mod(symbol, 4) - 1.5);  % Real parts: -3, -1, 1, 3
    Q_const = 2 * ((2 * (symbol >= 4) - 1));  % Imaginary parts: -1i or 1i

    signal_QAM_custom_const(i) = complex(I_const, Q_const);
    signal_QAM_custom(i) = complex(I, Q);
end

% Plot
% Plot
figure(1)

% Built-in QAM
subplot(211);
scatter(real(signal_QAM_builtin), imag(signal_QAM_builtin), 'ro');
title('QAM Modulation (Built-in)');
xlabel('Real Value');
ylabel('Imaginary Value');
grid on;


% Custom QAM
subplot(212);
scatter(real(signal_QAM_custom_const), imag(signal_QAM_custom_const), 'bo');
title('QAM Modulation (Custom)');
xlabel('Real Value');
ylabel('Imaginary Value');
grid on;


%% Demodulate Built-in QAM Signal

% Demodulate the built-in QAM signal
received_symbols_builtin = qamdemod(signal_QAM_builtin, m, 'bin');

% Convert symbols to bits
received_bits_builtin = int2bit(received_symbols_builtin, k);

% Reshape the received bits to a column vector
received_bits_builtin = received_bits_builtin(:);

%% Demodulate Custom QAM Signal

% Demodulate the custom QAM signal
received_symbols_custom = qamdemod(signal_QAM_custom, m, 'bin');

% Convert symbols to bits
received_bits_custom = int2bit(received_symbols_custom, k);

% Reshape the received bits to a column vector
received_bits_custom = received_bits_custom(:);

%% Compare Results

% Compare the received bits from built-in and custom demodulation
bit_error_rate_builtin = biterr(dataIn, received_bits_builtin) / length(dataIn);
bit_error_rate_custom = biterr(dataIn, received_bits_custom) / length(dataIn);

fprintf('Bit Error Rate (Built-in): %.4f\n', bit_error_rate_builtin);
fprintf('Bit Error Rate (Custom): %.4f\n', bit_error_rate_custom);

