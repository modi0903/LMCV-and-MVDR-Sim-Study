function params = ris_params()
    params.lambda = 1;
    params.M_bs = 8;               % BS antennas
    params.N_ris = 16;             % RIS elements
    params.d = params.lambda/2;
    params.theta_bs_ris = 10;
    params.theta_ris_ue = -20;
    params.theta_int = [-40 35];
    params.sigma2 = 0.01;
    params.N_snap = 300;
end
