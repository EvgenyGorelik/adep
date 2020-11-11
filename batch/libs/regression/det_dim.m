function [dim,offset] = det_dim(amps,timestamps,t0)
% input: amps - calculated amplitudes, timestamps - timestamps of the
% amplitudes, t0 - theoretical start of the diffusion
% output: dim - regression fitting value for dimension, offset - y axis offset
[~,dim,offset]=elr(log(amps), log(timestamps-t0));
dim = -dim*2;
end

