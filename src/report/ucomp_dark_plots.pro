; docformat = 'rst'

pro ucomp_dark_plots, dark_info, dark_images, run=run
  compile_opt strictarr

  mg_log, 'making dark plots', name=run.logger_name, /info

  n_darks = n_elements(dark_info.times)
  if (n_darks eq 0L) then begin
    mg_log, 'no darks to plot', name=run.logger_name, /info
    goto, done
  endif

  ; save original graphics settings
  original_device = !d.name

  ; setup graphics device
  set_plot, 'Z'
  device, get_decomposed=original_decomposed
  tvlct, original_rgb, /get
  device, decomposed=0, $
          set_resolution=[800, 4 * 300]

  tvlct, 0, 0, 0, 0
  tvlct, 255, 255, 255, 1
  tvlct, 255, 0, 0, 2
  tvlct, 0, 0, 255, 3
  tvlct, r, g, b, /get

  color            = 0
  background_color = 1
  camera0_color    = 2
  camera1_color    = 3

  tarr_min =  9.0 < floor(min([dark_info.t_c0arr, dark_info.t_c1arr]))
  tarr_max = 11.0 > ceil(max([dark_info.t_c0arr, dark_info.t_c1arr]))
  tpcb_min = 25.0 < floor(min([dark_info.t_c0pcb, dark_info.t_c1pcb]))
  tpcb_max = 27.0 > ceil(max([dark_info.t_c0pcb, dark_info.t_c1pcb]))

  start_time = 06   ; 24-hour time in observing day
  end_time   = 19   ; 24-hour time in observing day
  end_time  >= ceil(max(dark_info.times))

  charsize = 2.0
  symsize = 0.75

  ; plot of temperatures T_C{0,1}ARR and T_C{0,1}PCB per dark

  !p.multi = [0, 1, 4]

  plot, [dark_info.times], [dark_info.t_c0arr], /nodata, $
        title='Dark sensor array temperatures', charsize=charsize, $
        color=color, background=background_color, $
        xtitle='Time [HST]', $
        xstyle=1, xrange=[start_time, end_time], xticks=end_time - start_time, $
        ytitle='Temperature [C]', $
        ystyle=1, yrange=[tarr_min, tarr_max]
  oplot, [dark_info.times], [dark_info.t_c0arr], $
         psym=6, symsize=symsize, $
         linestyle=0, color=camera0_color
  oplot, [dark_info.times], [dark_info.t_c1arr], $
         psym=6, symsize=symsize, $
         linestyle=0, color=camera1_color

  xyouts, 0.95, 0.75 + 0.80 * 0.25, /normal, $
          'camera 0', alignment=1.0, color=camera0_color
  xyouts, 0.95, 0.75 + 0.75 * 0.25, /normal, $
          'camera 1', alignment=1.0, color=camera1_color

  plot, [dark_info.times], [dark_info.t_c0pcb], /nodata, $
        title='Dark PCB temperatures', charsize=charsize, $
        color=color, background=background_color, $
        xtitle='Time [HST]', $
        xstyle=1, xrange=[start_time, end_time], xticks=end_time - start_time, $
        ytitle='Temperature [C]', $
        ystyle=1, yrange=[tpcb_min, tpcb_max]
  oplot, [dark_info.times], [dark_info.t_c0pcb], $
         psym=6, symsize=symsize, $
         linestyle=0, color=camera0_color
  oplot, [dark_info.times], [dark_info.t_c1pcb], $
         psym=6, symsize=symsize, $
         linestyle=0, color=camera1_color

  xyouts, 0.95, 0.50 + 0.80 * 0.25, /normal, $
          'camera 0', alignment=1.0, color=camera0_color
  xyouts, 0.95, 0.50 + 0.75 * 0.25, /normal, $
          'camera 1', alignment=1.0, color=camera1_color


  ; plot intensity (mean or median?) vs temperature

  n_dims = size(dark_images, /n_dimensions)
  dims = size(dark_images, /dimensions)

  if (n_darks gt 1L) then begin
    cam0_dark_means  = mean(dark_images[*, *, *, 0, *], dimension=n_dims)
    cam1_dark_means  = mean(dark_images[*, *, *, 1, *], dimension=n_dims)
    cam0_dark_stddev = stddev(dark_images[*, *, *, 0, *], dimension=n_dims)
    cam1_dark_stddev = stddev(dark_images[*, *, *, 1, *], dimension=n_dims)
  endif else begin
    cam0_dark_means  = mean(dark_images[*, *, *, 0])
    cam1_dark_means  = mean(dark_images[*, *, *, 1])
    cam0_dark_stddev = stddev(dark_images[*, *, *, 0])
    cam1_dark_stddev = stddev(dark_images[*, *, *, 1])
  endelse

  ; max_dark_stddev = max(abs([cam0_dark_stddev, cam0_dark_stddev]))
  ; dark_min    = min(dark_images, max=dark_max)
  ; dark_range  = [dark_min - max_dark_stddev, dark_max + max_dark_stddev]

  dark_range  = [0.0, 1000.0]

  !p.multi = [4, 2, 4]

  plot, [dark_info.t_c0arr], [cam0_dark_means], /nodata, $
        charsize=charsize, title='Dark sensor temperature vs. counts', $
        psym=6, symsize=symsize, $
        color=color, background=background_color, $
        xtitle='Sensor array temperature [C]', $
        xstyle=1, xrange=[tarr_min, tarr_max], $
        ytitle='Counts [DN]/NUMSUM', $
        ystyle=1, yrange=dark_range, ytickformat='ucomp_dn_format'
  oplot, [dark_info.t_c0arr], [cam0_dark_means], $
         psym=6, symsize=symsize, $
         color=camera0_color
  oplot, [dark_info.t_c1arr], [cam1_dark_means], $
         psym=6, symsize=symsize, $
         color=camera1_color

  plot, [dark_info.t_c1pcb], [cam1_dark_means], /nodata, $
        charsize=charsize, title='Dark PCB temperature vs. counts', $
        psym=6, symsize=symsize, $
        color=color, background=background_color, $
        xtitle='PCB temperature [C]', $
        xstyle=1, xrange=[tpcb_min, tpcb_max], $
        ytitle='Counts [DN]/NUMSUM', $
        ystyle=1, yrange=dark_range, ytickformat='ucomp_dn_format'
  oplot, [dark_info.t_c0pcb], [cam0_dark_means], $
         psym=6, symsize=symsize, $
         color=camera0_color
  oplot, [dark_info.t_c1pcb], [cam1_dark_means], $
         psym=6, symsize=symsize, $
         color=camera1_color


  ; plot of dark means, std devs, quartiles by time per camera
  !p.multi = [1, 1, 4]

  plot, [dark_info.times], [cam0_dark_means], /nodata, $
        charsize=charsize, title='Dark mean counts (+/- 1 std dev) vs. time', $
        color=color, background=background_color, $
        xtitle='Time [HST]', $
        xstyle=1, xrange=[start_time, end_time], xticks=end_time - start_time, $
        ytitle='Counts [DN]/NUMSUM', $
        ystyle=1, yrange=dark_range, ytickformat='ucomp_dn_format'

  oplot, [dark_info.times], [cam0_dark_means], $
         psym=6, symsize=symsize, $
         linestyle=0, color=camera0_color
  oplot, [dark_info.times], [cam0_dark_means - cam0_dark_stddev], $
         psym=6, symsize=0.5 * symsize, $
         linestyle=1, color=camera0_color
  oplot, [dark_info.times], [cam0_dark_means + cam0_dark_stddev], $
         psym=6, symsize=0.5 * symsize, $
         linestyle=1, color=camera0_color
  ; TODO: plot vertical line from -stddev to +stddev?

  oplot, [dark_info.times], [cam1_dark_means], $
         psym=6, symsize=symsize, $
         linestyle=0, color=camera1_color
  oplot, [dark_info.times], [cam1_dark_means - cam1_dark_stddev], $
         psym=6, symsize=0.5 * symsize, $
         linestyle=1, color=camera1_color
  oplot, [dark_info.times], [cam1_dark_means + cam1_dark_stddev], $
         psym=6, symsize=0.5 * symsize, $
         linestyle=1, color=camera1_color
  ; TODO: plot vertical line from -stddev to +stddev?

  xyouts, 0.95, 0.00 + 0.80 * 0.25, /normal, $
          'camera 0', alignment=1.0, color=camera0_color
  xyouts, 0.95, 0.00 + 0.75 * 0.25, /normal, $
          'camera 1', alignment=1.0, color=camera1_color


  ; save plots image file
  output_filename = filepath(string(run.date, format='(%"%s.ucomp.darks.gif")'), $
                             subdir=ucomp_decompose_date(run.date), $
                             root=run->config('engineering/basedir'))
  write_gif, output_filename, tvrd(), r, g, b

  done:
  !p.multi = 0
  if (n_elements(original_rgb) gt 0L) then tvlct, original_rgb
  if (n_elements(original_decomposed) gt 0L) then device, decomposed=original_decomposed
  if (n_elements(original_device) gt 0L) then set_plot, original_device

  mg_log, 'done', name=run.logger_name, /info
end
