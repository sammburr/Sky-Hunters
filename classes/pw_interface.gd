class_name PWInterface # Player World Interface
extends StaticBody3D

var value : float
var incremenet : float

var input_type : Player.InputType

func increase_value():
	assert(false, "This method is abstract, you need to implement a method!")

func decrease_value():
	assert(false, "This method is abstract, you need to implement a method!")
