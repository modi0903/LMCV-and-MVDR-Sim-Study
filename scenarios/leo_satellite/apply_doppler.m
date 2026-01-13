function h_d = apply_doppler(h, n, rate)
%Abstracts Doppler as phase rotation
%n- snapshot index
%rate- phase rotation rate (rad per snapshot)
    phase = exp(1j * rate * n);
    h_d = h * phase;
end
