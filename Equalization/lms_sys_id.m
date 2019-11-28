%--------------------------------------------------------------------------
% Company: ETMC Exponenta                                                  
% Engineer: Kiselnikov Andrei                                              
%                                                                       
% Revision 0.01 - File Created 15.11.2019                                  
% This example provided strictly for educational purposes!
%
% Brief : LMS filter script
%--------------------------------------------------------------------------

clear all
close all

% Paremeters --------------------------------------------------------------
% Num of data points
N=2000;
% Input signal
input_signal = randn(N,1);
% Explore system (fir filter)
b = [-0.0349249458233189, ...
    -0.0370641891927234,  ...
    0.0209236117413746,   ...
    0.136805534741694,    ...
    0.256227903132472,    ... % try differnt values
    0.307102999793201,    ...
    0.256227903132472,    ...
    0.136805534741694,    ...
    0.0209236117413746,   ...
    -0.0370641891927234,  ...
    -0.0349249458233189];
a = 1;
% System order is a total amount of filter coeff
sys_order = length(b);
% Noise magnitude limit
noise_factor = 0.05;
%Convergence multiplier
mu = 0.1;
%--------------------------------------------------------------------------

% Paremeters --------------------------------------------------------------
% Estimation of signal passed throught explore system
%y = lsim(transfer_function,input_signal);
y = filter (b,1,input_signal);
% Adding noise to signal
tmp = randn(N,1);
tmp_sh = [tmp(10:end)' tmp(1:9)']';
y_n = y+tmp.*noise_factor;
%--------------------------------------------------------------------------

% LMS algorithm performing ------------------------------------------------
%Adaptive filter coefficient initial array
w = zeros (sys_order,1);
% Error fitting array, it defined as array only for saving fitting results
e_f = zeros (N-sys_order,1);
% Resulting Error,  it defined as array special for saving fitting results
e_r = zeros (N-sys_order,1);
% Adaptive filter output
y_a = zeros (N-sys_order,1);

for i = sys_order : N 
	u = tmp_sh(i:-1:i+1-sys_order);
    y_a(i+1-sys_order)= w' * u; 
    e_f(i+1-sys_order) = y_n(i) - y_a(i+1-sys_order);
	w = w + mu * u *  e_f(i+1-sys_order);
end 
%--------------------------------------------------------------------------
% Resulting error curve ---------------------------------------------------
for i = sys_order : N 
	u = input_signal(i:-1:i+1-sys_order);
    y_a(i+1-sys_order)= w' * u; 
    e_r(i+1-sys_order) = y(i)-y_a(i+1-sys_order);
end 
%--------------------------------------------------------------------------

% Visualization -----------------------------------------------------------
% Estimated points and system points
subplot (2,2,1);
plot(b, 'ko')
hold on
plot(w, 'r*')
legend('System weights','Estimated weights')
title("Estimated weights by "+N+" samples") ;

% Method error curve
subplot (2,2,2);
plot(e_f);
title("Error behavior with noise factor: "+noise_factor);

%Estimated system output vs actual system output
subplot (2,2,3);
plot(y_a,'b');
hold on
plot(y(sys_order:end),'r');
legend('Actual system','Estimated system')
title("Output comparison: "+noise_factor);

% Resulting error
subplot (2,2,4);
plot(e_r);
title("Estimated system error, noise factor: "+noise_factor);
%--------------------------------------------------------------------------
