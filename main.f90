program main
use, intrinsic :: iso_fortran_env, only : stdin=>input_unit, real64
implicit none

real(real64) :: a, b

read(stdin, *) a, b

print *, a+b

end program
