% eye_diagram_qam.m - Eye Diagram for 8-QAM Modulation

clc; clear; close all;

% Parameters
M = 8;
constPoints = [-3+1j, -3-1j, -1+1j, -1-1j, 3+1j, 3-1j, 1+1j, 1-1j];
numSymbols = 1e4;
samplePerSymbol = 8;

% Modulation
symbols = randi([0, M-1], numSymbols, 1);
modulatedSignal = constPoints(symbols + 1);

% Upsample and apply pulse shaping (e.g., using a raised cosine filter)
txSignal = upsample(modulatedSignal, samplePerSymbol);
pulseShape = rcosdesign(0.25, 6, samplePerSymbol); % Roll-off factor 0.25, span 6 symbols

% Append zeros to flush filter - make sure to append a COLUMN of zeros
txSignal = [txSignal; zeros(6*samplePerSymbol, 1)]; % Corrected line
txSignal = filter(pulseShape, 1, txSignal);

% Eye Diagram
eyediagram(txSignal(samplePerSymbol*6+1:end), 2*samplePerSymbol, samplePerSymbol);
title('Eye Diagram for 8-QAM');