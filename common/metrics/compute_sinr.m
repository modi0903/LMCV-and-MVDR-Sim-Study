function sinr = compute_sinr(w, h_sig, H_int, sigma2)
%h_sig desired channel vector
%H_int interferer channel matrix (each column one interferer)
    signal_power = abs(w' * h_sig)^2;
    interference_power = 0;
    for k = 1:size(H_int,2)
        interference_power = interference_power + abs(w' * H_int(:,k))^2;
    end
    noise_power = sigma2 * (w' * w);
    sinr = real(signal_power / (interference_power + noise_power));
end
