function check_PETSc_MATLAB()
% check_PETSc_MATLAB Checks if PetscBinaryRead is available

% Is PETSc's MATLAB function available?
if ~exist('PetscBinaryRead')
    error(['PetscBinaryRead not found. ' char(10) ...
        'Before calling this function, make sure you add the path to ' ...
        'PETSc matlab directory by ' char(10) char(10) ...
        'addpath <PETSc-directory>/share/petsc/matlab']);
end
