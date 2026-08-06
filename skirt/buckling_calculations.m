	      % input model parameters (all dimensions in m's)
Len = 10.5     % cylinder height
Rad = 1.6275   % cylinder shell mid-shell radius
Dia = 2*Rad    % diameter
thk = .025     % cylinder shell thickness
fa1 = Rad/thk  % frequently used ratio

               % input material properties
E_m = 2.09E11  % Elastic modulus, in Pa
nu_ = 0.28    % Poisson's ratio		      
fa2 = (1-nu_^2) % frequently used factor

               % buckling mode geometry factors
m_ = 1.E-2         % the number of axial half waves in the mode
n_ = 1.E-2         % the number of circumferential full waves
gam = 1       % buckling knock-down factor

               % structural properties
              % is the wall flexural stiffness per unit width (Eq.3)
D_ = E_m*thk^3/(12*fa2)
              % curvature parameter (Eq.4)
Z_ = Len^2/(Rad*thk)*sqrt(fa2)
              % buckling aspect ratio (Eq.5)
bet = n_*Len/(m_*pi*Rad)
fa3 = m_^2 * (1+bet^2)^2 % frequently used factor
              % buckling coefficient  (Eq.2)
k_x = fa3 + (12/pi^4)*(gam*Z_)^2/fa3

              %  buckling line load of a simply supported cylinder 
              % under axial compression
              % based on Donnell’s shell theory (Eq.1)
N_x = k_x*(pi/Len)^2*Dia
             % total buckling load
F_x = (2*pi*Rad)*N_x

              % cross check w/ reduced form
             % critical buckling stress (Eq.7)
s_x = gam*E_m/sqrt(3*fa2)*1/fa1
             % transverse cross-sectional area
ar_ = pi*Dia*thk
             % calculation of percentage difference
             % between the two 
abs(s_x*ar_ - F_x)/F_x
abs(s_x*ar_ - F_x)/(s_x*ar_)
