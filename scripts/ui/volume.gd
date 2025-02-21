extends Label

@onready var vol_slider: HSlider = $"../VolSlider"

func _ready():
	# Connect the value_changed signal to the _on_value_changed method
	vol_slider.value_changed.connect(_on_value_changed)
	_on_value_changed(vol_slider.value)

func _on_value_changed(value):
	text = "Volume: " + str(int(value * 100))
