function depth = null_depth(w, a_int)
    depth = 20*log10(abs(w' * a_int));
end
