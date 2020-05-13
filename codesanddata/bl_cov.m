function sig = bl_cov(X,method)
switch(method)
    case 1
        sig=cov(X);
    case 2
        sig=robustcov(X);
    case 3
        sig=ewma_cov(X);
    case 4
        sig=covCor(X);    
end
end