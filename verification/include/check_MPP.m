function check_MPP(mpp_exec_dir, exec_name)
% CHECK_MPP(mpp_exec_dir, exec_name) Checks if the MPP directory containing
% exectables (mpp_exec_dir) and the executable (exec_name) exists

% Does the MPP directory containing exectables exists?
[status,~]=system(['ls ' mpp_exec_dir]);
if (status ~= 0)
    error([ 'Following directory does not exist: ' mpp_exec_dir]);
end

% Does the exectable exists?
[status,~]=system(['ls ' mpp_exec_dir '/' exec_name]);
if (status ~= 0)
    error([ 'Following executable not found: ' mpp_exec_dir '/' exec_name]);
end

