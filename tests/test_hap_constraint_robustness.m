clc; clear;

addpath(genpath('../common'));
addpath(genpath('../scenarios/hap_relay'));

%% Load HAP parameters
params = hap_params();

array_bs = ula_array(params.M_bs, params.d, params.lambda);

%% Channels
[h_sig, H_int] = generate_hap_channels(array_bs, params);

%% Snapshot-based covariance
X = zeros(params.M_bs, params.N_snap);

for n = 1:params.N_snap
    x = h_sig*(randn+1j*randn)/sqrt(2);
    for k = 1:size(H_int,2)
        x = x + H_int(:,k)*(randn+1j*randn)/sqrt(2);
    end
    x = x + sqrt(params.sigma2/2) * ...
        (randn(params.M_bs,1)+1j*randn(params.M_bs,1));
    X(:,n) = x;
end

R = (X*X')/params.N_snap;

%% Beamforming
a_des = steering_vector_ula(array_bs, params.theta_des*pi/180);

w_mvdr = mvdr_beamformer(R, a_des);
w_lcmv = lcmv_beamformer(R, [a_des H_int], [1;0;0]);

%% Diagnostics
fprintf('cond(R) = %.2e\n', cond(R));

for k = 1:size(H_int,2)
    fprintf('Interferer %d null depth: MVDR = %.2f dB, LCMV = %.2f dB\n', ...
        k, null_depth(w_mvdr, H_int(:,k)), ...
           null_depth(w_lcmv, H_int(:,k)));
end

%% Assertions (soft, informational)
assert(cond(R) > 100, 'Covariance not sufficiently ill-conditioned');
assert(null_depth(w_lcmv, H_int(:,1)) < -100, ...
       'LCMV does not enforce deep nulls');
