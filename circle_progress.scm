(define (create-circle-progress inImage drawable)
  (let*
	 (	(tmp-layer 0)
		(pie-count 7)
		(rotated-point '())
		(step 0)
		(ang-step 0)
		(points (make-vector 12))
		(height (car (gimp-image-height inImage)))
		(width (car (gimp-image-width inImage)))
	  )
	(gimp-image-undo-group-start inImage)
	
	(vector-set! points 0 0)
	(vector-set! points 1 0)
	
	(vector-set! points 2 (/ width 2))
	(vector-set! points 3 0)
	
	(vector-set! points 4 width)
	(vector-set! points 5 0)
	
	(vector-set! points 6 width)
	(vector-set! points 7 (/ height 2))
	
	(vector-set! points 8 width)
	(vector-set! points 9 height)
	
	(vector-set! points 10 0)
	(vector-set! points 11 height)
	(set! ang-step (/ 360 pie-count))
	(while (< step pie-count)
	    (set! tmp-layer (car (gimp-layer-copy drawable TRUE)))
	    (gimp-image-add-layer inImage tmp-layer -1)
	    (gimp-image-set-active-layer inImage tmp-layer)
	    
	    (if (= step 1)
		(begin
		  (set! rotated-point (rotate-point (dtr (- ang-step 45)) width 0 (/ width 2) (/ height 2)))
		  (vector-set! points 6 (car rotated-point))
		  (vector-set! points 7 (cadr rotated-point))
			(vector-set! points 4 (/ width 2))
			(vector-set! points 5 (/ height 2))
	    ))
	    (if (> step 1)
		(begin
		  (set! rotated-point (rotate-point (dtr (- (* step ang-step) 45)) width 0 (/ width 2) (/ height 2)))
			(vector-set! points 6 (car rotated-point))
			(vector-set! points 7 (cadr rotated-point))
	    ))
	    (if (> (* step ang-step) 135)
		(begin
			(vector-set! points 8 (car rotated-point))
			(vector-set! points 9 (cadr rotated-point))
	    ))
		(if (> (* step ang-step) 225)
		(begin
			(vector-set! points 10 (car rotated-point))
			(vector-set! points 11 (car rotated-point))
	    ))
		(if (> (* step ang-step) 315)
		(begin
			(vector-set! points 0 (car rotated-point))
			(vector-set! points 1 (cadr rotated-point))
	    ))


	    (gimp-free-select inImage 12 points CHANNEL-OP-REPLACE TRUE FALSE 0)
	    (gimp-desaturate-full tmp-layer DESATURATE-AVERAGE)
	    (gimp-selection-none inImage)
	    (set! step (+ step 1))
	)
	(gimp-image-undo-group-end inImage)
	)
)

(define (dtr a)           ; Degrees to Radians
 (let* ( )
 (* (* 4 (atan 1.0)) (/ a 180.0))))
  
(define (rtd a)           ; Radians to Degrees
  (let* ( ) 
  (/ (* a 180.0) (* 4 (atan 1.0)))))

(define (rotate-point rad x y cx cy)
    (let* ( )
	(list 
        (+ (- (* (- x cx) (cos rad)) (* (- y cy) (sin rad))) cx)
        (+ (+ (* (- x cx) (sin rad)) (* (- y cy) (cos rad))) cy))
    )
)
    

(script-fu-register
   "create-circle-progress"
    "Circle progress"
	 "Make progress from image"
	  "Oleg"
	   "Copyleft, use it at your own sweet will"
	    "May 24, 2012"
		 "RGB* GRAY* INDEXED*"
		  SF-IMAGE      "The image"     0
		   SF-DRAWABLE   "The layer"     0
			 )
(script-fu-menu-register "create-circle-progress" "<Image>/Filters/User's scripts")

