; docformat = 'rst'

function ucomp_calibration_steps_ut::init, _extra=e
  compile_opt strictarr

  if (~self->UCoMPutTestCase::init(_extra=e)) then return, 0

  self->addTestingRoutine, 'ucomp_calibration_steps'

  return, 1
end


pro ucomp_calibration_steps_ut__define
  compile_opt strictarr

  define = {ucomp_calibration_steps_ut, inherits UCoMPutTestCase}
end
