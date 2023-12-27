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

% ... [Previous sections of your code] ...

%% Plot Noisy Constellation Diagram with Colored Symbols Based on Decision Regions

figure;
hold on;

customColor = [0.5, 0.6, 0.7]; % A mix of red, green, and blue

% Define colors for each constellation point
colors = ['r', 'g', 'b', 'c', 'm', 'r', 'y', 'w']; % Example set of colors

% Draw decision boundaries (approximate for rectangular 8-QAM)
x_min = min(real(constPoints)) - 2;
x_max = max(real(constPoints)) + 2;
y_min = min(imag(constPoints)) - 2;
y_max = max(imag(constPoints)) + 2;

% Vertical lines
for x = [-2, 0, 2]
    line([x x], [y_min y_max], 'Color', 'w', 'LineStyle', '--');
end

% Horizontal lines
for y = [-2, 0, 2]
    line([x_min x_max], [y y], 'Color', 'w', 'LineStyle', '--');
end

% Plot each noisy signal point
for i = 1:numSymbols
    originalSymbol = symbols(i);
    demodulatedSymbol = demodulatedSymbols(i);
    
    symbolStyle = 'o'; % Default: within decision region
    if originalSymbol ~= demodulatedSymbol
        symbolStyle = 'x'; % Exceeded decision region
    end
    
    color = colors(originalSymbol + 1);
    plot(real(noisySignal(i)), imag(noisySignal(i)), [color, symbolStyle], 'MarkerEdgeColor', color);
end

title('Noisy Constellation Diagram with Colored Symbols');
xlabel('Real');
ylabel('Imaginary');
axis([x_min x_max y_min y_max]);
grid on;

% ... [Rest of your code] ...

