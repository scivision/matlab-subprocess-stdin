function build(src, exe)
narginchk(2,2)

if ~isfile(exe)
  [ret, msg] = system(['gfortran ', src, ' -o ', exe]);
  assert(ret == 0, msg)
end

assert(isfile(exe), ['cannot find ', exe])

end
