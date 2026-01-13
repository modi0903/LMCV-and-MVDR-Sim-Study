% ~1e-16 should be the expected result (essentially 0)
% helps prove that beamformer math is correct and no hidden numerical bugs
% first failsafe if this fails no point going forward
clc; clear;
addpath(genpath('common'));
% Parameters
lambda = 1;
M = 8;
d = lambda/2;
theta_des = 20*pi/180;
sigma2 = 0.01;

array = ula_array(M,d,lambda);
a_des = steering_vector_ula(array,theta_des);

% Generate snapshots
N_snap = 300;
X = zeros(M,N_snap);
for n = 1:N_snap
    s = (randn+1j*randn)/sqrt(2);
    X(:,n) = a_des*s + sqrt(sigma2/2)*(randn(M,1)+1j*randn(M,1));
end
R = (X*X')/N_snap;

% Beamformers
w_mvdr = mvdr_beamformer(R,a_des);
w_lcmv = lcmv_beamformer(R,a_des,1);

fprintf('||w_mvdr - w_lcmv|| = %.2e\n', norm(w_mvdr-w_lcmv));

