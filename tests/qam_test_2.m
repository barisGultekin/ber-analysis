clc, clear, close all;


% Define constants
symbol_duration = 50e-6;
Fs = 100e3;
f = 40e3;
sample_duration = 1.0 / Fs;
n = symbol_duration / sample_duration;
M = 8;

% Define symbol
symbol = 1 + 1j * 0;

% Generate carrier
carrier = zeros(1, n, 2);
for i = 1:n
 omega = 2 * pi * f * (i - 1) * sample_duration;
 carrier(i, 1) = cos(omega);
 carrier(i, 2) = sin(omega);
end

% Define 8-QAM constellation
constellation = [1j+1, 1j-1, -1j+1, -1j-1, 1j+3, 1j-3, -1j+3, -1j-3];

% Generate signal
signal = zeros(1, n);
for i = 1:n
 signal(i) = constellation(i) * carrier(i, 1) - constellation(i) * carrier(i, 2);
end

% Create a constellation diagram object
constDiagram = comm.ConstellationDiagram('SamplesPerSymbol', n, 'SymbolsToDisplaySource', 'Property', 'SymbolsToDisplay', 100);

% Display the constellation diagram
constDiagram(signal)
