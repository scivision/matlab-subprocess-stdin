program main
use, intrinsic :: iso_fortran_env, only : stdin=>input_unit
implicit none

real :: a, b

read(stdin, *) a, b

print '(f10.3)', a+b

end program
