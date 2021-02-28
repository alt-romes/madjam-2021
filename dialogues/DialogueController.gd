extends Node


onready var dialogue_box = get_node("Control/Box")
onready var dialogue_text = dialogue_box.get_node("MarginContainer/Text")
onready var dialogue_text_animp = dialogue_text.get_node("AnimationPlayer")
onready var voice_player = dialogue_text.get_node("AudioStreamPlayer")

func _ready():
	dialogue_box.visible = false # hide ui box
	
func _process(delta):
	
	if Input.is_action_just_pressed("player_interact"):
		_on_Dialogue_dialogue_interact(current_dialogue, voice)

# Internal state

var current_dialogue : Dialogue = null
var current_sentence : int = 0
var voice : AudioStream = null


# Private functions

func _start_new_dialogue(dialogue : Dialogue, voice : AudioStream):
	# Reset dialogue state
	current_dialogue = dialogue
	current_sentence = 0
	voice_player.stream = voice
	# Show ui box
	dialogue_box.visible = true
	# Display first sentence
	_display_next_sentence()

func _display_next_sentence():
	if !dialogue_text_animp.is_playing():
		dialogue_text.percent_visible = 0	
		if (current_dialogue.has_sentence(current_sentence)):
			# Dialogue has more sentences to display
			dialogue_text.text = current_dialogue.get_sentence(current_sentence)
			current_sentence += 1
			dialogue_text_animp.play("Text Animation")
			voice_player.play()
		else:
			
			# Dialogue has ended			
			_end_dialogue()

func _end_dialogue():
	voice_player.stop()
	dialogue_box.visible = false
	current_dialogue = null
	# perhaps signal player
	# emit_signal("dialogue_ended") ?


# Events

# warning-ignore:unused_signal
signal dialogue_interact
signal dialogue_cancel

func _on_Dialogue_dialogue_interact(dialogue : Dialogue, voice : AudioStream):	
	
	if dialogue == null:
		return
				
	if current_dialogue == null:
		_start_new_dialogue(dialogue, voice)		
	elif current_dialogue == dialogue:
		_display_next_sentence()


func _on_Dialogue_dialogue_cancel():
	_end_dialogue()	
