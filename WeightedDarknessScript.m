
% Weighted Darkness of Greyscale Picture

SumColumns = sum(Icomp);
SumImage = sum(SumColumns);
WeightedDarkness = SumImage/(255*(width(Icomp)*length(Icomp)))

% 0.35 = 0.4068 * (X)
% (X) = 0.35/0.4068
% (X) = 0.86 = ScaledSensitivityBinarization coefficient

% 0 = 0.4068 * (X)
% (X) = 0/0.4068
% (X) = 0.86 = ScaledSensitivityBinarization coefficient

% solve x=0.4487*0.86^(0.5) ??

WDAP = [0.4068, 0.4487, 0.3578, 0.4297, 0.4776, 0.4777, 0.4174, 0.3052, 0.4359, 0.5068, 0.5275, 0.5257, 0.4063, 0.4329, 0.3841, 0.3965, 0.3053, 0.3602, 0.3521, 0.3389, 0.2847, 0.3932, 0.3114, 0.3423, 0.4202, 0.3661, 0.3184];