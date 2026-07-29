% these formulations have been aken from NASA-TM-X-73306-Astronautics-Structures-Manual-Volume-II_2.pdf
% section C: Buckling of Shells 
% C1 Cylinders (pg 842)
mu= 0.3 % poisson's ratio
E= 2.09E5
r= 1627.5
t= 25
r_t= r/t
phi= 1/16*sqrt(r_t)
% eqn 2, calculation of factor gamma
gamma= 1-0.901*(1-exp(-phi))
%eqn 1, critical buckling load 
sigma_cr_eta= gamma*E*(t/r)/sqrt(3*(1-mu^2))
%critical load
csa= 2*pi*r*t
F_cr_eta= sigma_cr_eta*csa
