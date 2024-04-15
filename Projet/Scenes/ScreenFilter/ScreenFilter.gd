extends ColorRect

var loadedStep: float = 0.0
var animate: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	material.set_shader_parameter("screenLoadScale", 0.0)
	get_tree().create_timer(0.5).timeout.connect(self.start)

func start():
	animate = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animate:
		loadedStep += delta * 0.5
		if loadedStep > 1.0:
			loadedStep = 1.0
			animate = false
		
		material.set_shader_parameter("screenLoadScale", loadedStep)
		
