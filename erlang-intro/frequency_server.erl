-module(frequency_server).

% Schreibe einen gen_server, der eine Menge von Frequenzen verwaltet.
% Operationen:
% - man kann sich eine freie Frequenz geben lassen (wenn's eine gibt)
% - man kann eine Frequenz auch wieder zurückgeben
% Bonus: Man kann nur Frequenzen zurückgeben, die man auch vorher
%        bekommen hat.