function main()
% Automated Data Evaluation Program for FRAP Experiments
% ADEP Batch Version

addpath('./libs/center_detection/');
addpath('./libs/fitting/');
addpath('./libs/gui/');
addpath('./libs/routines/');
addpath('./libs/options/');
addpath('./libs/log/');
addpath('./libs/parameters/');
addpath('./libs/noise_filter/');
addpath('./libs/profile_creation/');
addpath('./libs/image_detection/');
addpath('./libs/regression/');
addpath('./libs/utils/');
adep_batch()
end