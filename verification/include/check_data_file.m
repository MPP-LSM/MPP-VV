function check_data_file(data_file, variables)
% CHECK_data_file(data_file, variables) Check if the data file exists and
% it contains all required variables

% Does the MPP directory containing exectables exists?
[status,~]=system(['ls -l ' data_file]);
if (status ~= 0)
    error([ 'Following filename does not exist: ' data_file]);
end

load (data_file);

% Check if all the varaibles do exist
for ii = 1:length(variables)
    if ~exist(variables{ii})
        error([variables{ii} ' not found in ' data_file]);
    end
end

end