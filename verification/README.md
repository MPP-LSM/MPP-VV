## 1. Description

The MATALB scripts provided in the subdirectories perform verification of the
[MPP library](https://github.com/MPP-LSM/MPP) via Method of Manufactured Solutions (MMS).
MMS is a technique for verifying complex codes when 
analytical solutions are unavailable.


## 2. Installation instructions


### 2.1. Compiler requirments

The code requires:

- C compiler
- Fortran compiler
- Git
- CMake
- PETSc
- MPP

Set the following environment variables for installing PETSc and MPP:

- `CC`     : Sequential C compiler
- `CXX`    : Sequential C++ compiler
- `FC`     : Sequential Fortran compiler

### 2.2. Install PETSc

Before installing the MPP library, one needs to install
[PETSc](http://www.mcs.anl.gov/petsc/).

```
cd <directory-of-choice>

# The verison of PETSc that is compatiable with the MPP library
PETSC_VERSION=v3.8.3

# Clone PETSc
git clone https://bitbucket.org/petsc/petsc petsc_$PETSC_VERSION

cd petsc_$PETSC_VERSION

# Use the version of PETSc that is compatiable with the MPP library
git checkout $PETSC_VERSION

# Define an environment variable that stores the path to PETSc directory.
# This variable will be used in compile the MPP library. Additionally,
# this would used for running the MATLAB scripts.
export PETSC_DIR=$PWD

# Set PETSC_ARCH (architecture) variable (e.g. darwin-gcc5.4.0)
export PETSC_ARCH=<some-value>


# Configure PETSc
./configure            \
PETSC_ARCH=$PETSC_ARCH \
--with-cc=$CC          \
--with-cxx=$CXX        \
--with-fc=$FC          \
--download-mpich       \
--download-fblaslapack 

# Build PETSc
make PETSC_DIR=$PETSC_DIR PETSC_ARCH=$PETSC_ARCH all

# Test installation of PETSc
make PETSC_DIR=$PETSC_DIR PETSC_ARCH=$PETSC_ARCH test
```

### 2.3. Install MPP library

```
cd <directory-of-choice>

# Clone the MPP
git clone https://github.com/MPP-LSM/MPP

cd MPP

# This would used for running the MATLAB scripts.
export MPP_DIR=$PWD

# Configure MPP
make config

# Install MPP
make install

# Test installation of MPP
make test
```

### 2.5. Run the MATLAB scripts


1. Download MATLAB code for model verification
```
git clone https://github.com/MPP-LSM/MPP-VV

```

2. Launch MALTAB and change directory to the MPP-VV directory
```
>> cd <MPP-VV-directory>/verification
```

3. Define variables that are define path to PETSc, PFLTORAN, and MPP directories.
```
>> PETSC_DIR ='<directory-of-PETSc>';
>> MPP_DIR   ='<directory-of-mpp>';
>>
>> addpath(genpath(pwd))
>> addpath([PETSC_DIR '/share/petsc/matlab/'])
>> MPP_EXEC_DIR = [MPP_DIR '/local/bin'];
```

4. Run verification problems

```
% Run VSFM 1D unsaturated flow problem
>> mms_vsfm_driver('problem_type',0,'mpp_exec_dir',MPP_EXEC_DIR)

% Run VSFM 1D fully saturated flow problem
>> mms_vsfm_driver('problem_type',1,'mpp_exec_dir',MPP_EXEC_DIR)

% Run 1D soil-plant continuum problem with verbosity turned on
>> mms_spac_driver('mpp_exec_dir',MPP_EXEC_DIR,'verbose',1)

% Run 1D TH problem and save the plots as pdf
>> mms_th_driver('mpp_exec_dir',MPP_EXEC_DIR,'save_plots',1)

% Run 3D thermal diffusion problem and save the data as mat file
>> mms_thermal_driver('mpp_exec_dir',MPP_EXEC_DIR, 'save_data',1)

```




