-module(frequency).

% Frequenz-Vergabe
% - gen-server, der eine Menge von Frequenzen verwaltet
% - man kann sich eine freie Frequenz geben lassen
%   (kann sein, daß keine frei ist)
% - man kann Frequenz zurückgeben
%   (muß eine von den verwalteten Frequenzen sein)
% Bonus: darf nur Frequenz zurückgeben, die man 
% vorher bekommen hat
