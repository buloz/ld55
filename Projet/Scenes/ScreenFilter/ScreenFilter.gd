extends ColorRect




func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	material.set_shader_parameter("screenLoadScale", 0.0)

func hideFilter(hiding: bool):
	if hiding:
		material.set_shader_parameter("screenLoadScale", 1.0)
	else:
		material.set_shader_parameter("screenLoadScale", 0.0)

func start(open: bool, callable: Callable = Callable()):
	var tween = create_tween()
	var from: float
	var to: float
	
	if open:
		from = 0.0
		to = 1.0
	else:
		from = 1.0
		to = 0.0
	
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(func(x: float): material.set_shader_parameter("screenLoadScale", x), from, to, 2.0)
	tween.tween_callback(callable)
	
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if animate:
		#if open:
			#loadedStep += delta * 0.5
			#if loadedStep > 1.0:
				#loadedStep = 1.0
				#animate = false
		#else:
			#loadedStep -= delta * 0.5
			#if loadedStep < 0.0:
				#loadedStep = 0.0
				#animate = false
		#
		#material.set_shader_parameter("screenLoadScale", loadedStep)
		#
