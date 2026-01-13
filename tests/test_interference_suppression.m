%SINR alone doesnt cut it, need to decompose signal/intereference/noise, 
clc; clear;
addpath(genpath('../common'));
%% Setup
lambda = 1;
M = 8;
d = lambda/2;
array = ula_array(M, d, lambda);
theta_des = 20*pi/180;
theta_int = [-30 50]*pi/180;
sigma2 = 0.01;
%% Channels
h_sig = steering_vector_ula(array, theta_des);
H_int = zeros(M, length(theta_int));
for k = 1:length(theta_int)
    H_int(:,k) = steering_vector_ula(array, theta_int(k));
end
%% Covariance
N_snap = 300;
X = zeros(M, N_snap);
for n = 1:N_snap
    x = h_sig*(randn+1j*randn)/sqrt(2);
    for k = 1:size(H_int,2)
        x = x + H_int(:,k)*(randn+1j*randn)/sqrt(2);
    end
    x = x + sqrt(sigma2/2)*(randn(M,1)+1j*randn(M,1));
    X(:,n) = x;
end
R = (X*X')/N_snap;
%% Beamforming
a_des = h_sig;
w_mvdr = mvdr_beamformer(R, a_des);
C = [a_des, H_int];
f = [1; 0; 0];
w_lcmv = lcmv_beamformer(R, C, f);
%% Power breakdown
sig_mvdr = abs(w_mvdr'*h_sig)^2;
int_mvdr = sum(abs(w_mvdr'*H_int).^2);
sig_lcmv = abs(w_lcmv'*h_sig)^2;
int_lcmv = sum(abs(w_lcmv'*H_int).^2);
fprintf('MVDR: Interference = %.2f dB\n', 10*log10(int_mvdr));
fprintf('LCMV: Interference = %.2f dB\n', 10*log10(int_lcmv));
assert(int_lcmv < int_mvdr, 'LCMV does not suppress interference better');
