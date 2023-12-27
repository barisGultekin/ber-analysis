% 8-PSK Modulation & Demodulation Schemes

clc, clear, close all;

%% Parameters

theta = (0:7) * (2 * pi / 8);
constPoints = exp(1j * theta);

numSymbols = 100;
symbols = randi([0 7], numSymbols, 1);

%% Modulation

modulatedSignal = constPoints(symbols + 1);

noiseVariance = 0.6; % Adjust this for different noise levels
noisySignal = modulatedSignal + sqrt(noiseVariance/2)*(randn(size(modulatedSignal)) + 1j*randn(size(modulatedSignal)));

%% Demodulation

demodulatedSymbols = zeros(numSymbols, 1);
for i = 1:numSymbols
    [~, closestPointIndex] = min(abs(noisySignal(i) - constPoints));
    demodulatedSymbols(i) = closestPointIndex - 1;
end

%% Simulated BER Analysis

numErrors = sum(demodulatedSymbols ~= symbols);
ber_simulated = numErrors / numSymbols;
disp(['Bit Error Rate (BER) for 8-PSK: ', num2str(ber_simulated)]);

%% Plots

% Constellation Diagrams
figure(1)

subplot(311);
plot(real(constPoints), imag(constPoints), 'bo');
hold on;
plot(real(modulatedSignal), imag(modulatedSignal), 'rx');
title('Original 8-PSK Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

subplot(312);
plot(real(noisySignal), imag(noisySignal), 'rx');
title('Noisy 8-PSK Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

subplot(313);
plot(real(constPoints(demodulatedSymbols + 1)), imag(constPoints(demodulatedSymbols + 1)), 'rx');
title('Demodulated 8-PSK Constellation Diagram');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

% Original and Demodulated Symbols
figure(2)
plot(1:numSymbols, symbols, 'bo-', 1:numSymbols, demodulatedSymbols, 'rx');
legend('Original Symbols', 'Demodulated Symbols');
title('Comparison of Original and Demodulated Symbols for 8-PSK');
xlabel('Symbol Index');
ylabel('Symbol Value');
grid on;

% ... [Previous sections of your code: Parameters, Modulation, Demodulation, and BER Analysis] ...

%% Plot Noisy Constellation Diagram with Correct Decision Regions for 8-PSK

figure;
hold on;

% Define colors for each constellation point
colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k', 'w']; % Example set of colors

% Determine plot limits and extend decision boundaries
plotRadius = 2; % Extend lines beyond the unit circle
angles = theta + pi/8; % Mid-point angles for decision boundaries

% Draw decision boundaries
for k = 1:length(angles)
    endPoint = plotRadius * exp(1j * angles(k));
    line([0 real(endPoint)], [0 imag(endPoint)], 'Color', 'w', 'LineStyle', '--');
end

% Plot original constellation points as filled circles
for k = 1:length(constPoints)
    plot(real(constPoints(k)), imag(constPoints(k)), 'o', 'MarkerEdgeColor', colors(k), 'MarkerFaceColor', colors(k));
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

title('Noisy 8-PSK Constellation Diagram with Correct Decision Regions');
xlabel('Real');
ylabel('Imaginary');
axis square;
grid on;

% ... [Rest of your code] ...

