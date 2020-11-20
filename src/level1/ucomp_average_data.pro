; docformat = 'rst'

;+
; Average data.
;
; :Params:
;   file : in, required, type=object
;     `ucomp_file` object
;   primary_header : in, required, type=strarr
;     primary header
;   data : in, required, type="fltarr(nx, nx, nexts)"
;     extension data
;   headers : in, requiredd, type=list
;     extension headers as list of `strarr`
;
; :Keywords:
;   run : in, required, type=object
;     `ucomp_run` object
;-
pro ucomp_average_data, file, primary_header, data, headers, run=run
  compile_opt strictarr

  ; TODO: implement
  mg_log, 'not implemented', name=run.logger, /warn
end
