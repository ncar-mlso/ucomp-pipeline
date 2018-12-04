; docformat = 'rst'

;+
; Produce L1 engineering plots.
;
; :Keywords:
;   run : in, required, type=object
;     `ucomp_run` object
;-
pro ucomp_l1_engineering_plots, run=run
  compile_opt strictarr

  mg_log, 'producing engineering plots...', name=run.logger_name, /info

  ucomp_wave_type_histogram, filepath(string(run.date, format='(%"%s.wave_types.png")'), $
                                      subdir=ucomp_decompose_date(run.date), $
                                      root=run->config('engineering/basedir')), $
                             run=run
end