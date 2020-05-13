
function significance = indep_features(X,Y)

UniqueClass = unique(Y);

ClassA = (Y == UniqueClass(1));
ClassB = (Y == UniqueClass(2));
nA     = sum(double(ClassA));
nB     = sum(double(ClassB));

significance = ...
    abs(mean(X(ClassA,:)) - mean(X(ClassB,:)))  ./  ...
    sqrt(var(X(ClassA,:)) ./ nA + var(X(ClassB,:)) ./ nB);
end





