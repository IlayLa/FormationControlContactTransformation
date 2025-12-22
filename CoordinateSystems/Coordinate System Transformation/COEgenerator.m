function [sma,ecc,inc,raan,aop,aota] = COEgenerator(Rp,minh,maxh,mine,maxe)
    nocollisionflag = 0;
    while ~nocollisionflag
        sma = Rp + minh + (maxh-minh)*rand;
        ecc = mine + (maxe-mine)*rand;
        nocollisionflag = sma*(1-ecc) >= (Rp + minh);
    end
    inc = pi*rand;
    raan = 2*pi*rand;
    aop = 2*pi*rand;
    aota = pi*rand;    
end