@tool
extends Node3D

@export var active = false
@export var target_bone = ""
@export var spring_k = 3.0
@export var mass = 1.0
@export var damping = 6.0

# Calculate the position after delta time using the following equation.
# ma = F (m:mass, a:acceleration, F:force)
# F =－kx (k: spring constant, x: position)

var skeleton: Skeleton3D = null
var err_count: int = 0
var active_flag = true
var pass_flag: bool
var target_bone_id: int
var parent_bone_id: int
var vel: Vector3
var pos0: Vector3
var parent_prev_pos: Vector3


func _ready():
	initialize_value()


func initialize_value():
	pass_flag = false
	target_bone_id = -1
	parent_bone_id = -1
	vel = Vector3(0,0,0)
	pos0 = Vector3(0,0,0)
	parent_prev_pos = Vector3(0,0,0)
	get_skeleton_recursive(get_parent())


# Climb the Node tree to find skeleton3D.
# SpringBone can attach anywhere on the skeleton branch.
func get_skeleton_recursive(node):
	if node == null:
		return
	if node is Skeleton3D:
		skeleton = node
		return
	else:
		return get_skeleton_recursive(node.get_parent())


# Move the self(SpringBone) back and forth like spring.
# delta: 1 frame time.
# pos0: The position where SpringBone tries to return to.
# acc: acceleration, i.e. velocity change per delta time.
# vel: velocity, i.e. position change per delta time.
# spring_k: pulling force per unit length of spring.
# damping: resistance force per unit velocity.
func act_spring(delta):
	# distance of pos0 and self(SpringBone).
	var dist = (pos0 - global_transform.origin).length()
	# If the distance is not 0, a force is applied and the velocity is updated.
	if dist >= 0.0001:
		var force = (pos0 - global_transform.origin) * spring_k
		var acc = force / mass
		vel += acc * delta
	# Minus the speed lost due to damping (like air resistance).
	vel -= vel * damping * delta
	# Update self position with velocity.
	global_transform.origin = global_transform.origin + vel
	# Make it inactive if the distance is too far.
	if dist >= 100000:
		active = false
		skeleton.clear_bones_global_pose_override()


# Orient the parent bone toward self(SpringBone).
func look_at_spring_bone(parent_pos:Vector3):
	# 1) Vector from ParentBone to pos0.
	var arc_from = pos0 - parent_pos
	# 2) Vector from ParentBone to self.
	var arc_to = global_transform.origin - parent_pos
	# Get the Quaternion of the angle 1) and 2) and update ParentBone with that Quatertion.
	var quat_from_to = Quaternion(arc_from,arc_to)
	skeleton.set_bone_pose_rotation(parent_bone_id,quat_from_to)


# Check the input value and if there is no problem, set initialize to true.
func check_input_values():
	# Since GDScript has no "try-except" syntax, use a "dictionary and if" instead.
	var errors = {}
	if !(skeleton is Skeleton3D):
		errors['skeleton'] = "SpringsBone should be skeleton3D's branches."
	else:
		target_bone_id = skeleton.find_bone(target_bone)
		if target_bone_id == -1:
			errors['root_tip_id'] = "Enter the tip bone name correctly."
		else:
			parent_bone_id = skeleton.get_bone_parent(target_bone_id)
			if parent_bone_id == -1:
				errors['parent_bone'] = "Enter the tip bone name correctly."
	# Pring only when the number of errors has changed.
	if len(errors) > 0 && err_count != len(errors):
		for key in errors:
			print("ERROR(%s): %s" % [key,errors[key]])
		err_count = len(errors)
		pass_flag = false
		return
	elif len(errors) > 0:
		pass_flag = false
		return
	else:
		err_count = len(errors)
		skeleton.reset_bone_poses()
		pass_flag = true
		return


func _process(delta):
	if skeleton == null:
		return
	
	# Initialize the value when switching active.
	if active != active_flag:
		active_flag = active
		initialize_value()

	# Check the input
	if !pass_flag:
		check_input_values()
		return

	# There are three types of Bone axis: Local(Bone itself), Skeleton(Object), and Global(World).
	# 1) get_bone_pose(): Get Transform3D in local coordinates relative to the parent bone.
	# 2) get_bone_global_pose(): Gets Transform3D relative to the Skeleton3D object. Note that it is Not global.
	# 3) Multiplying the object's global position by Transform3D of 2) gives the global Transform3D.
	var bone_transf_local = skeleton.get_bone_pose(target_bone_id) 			# 1)
	var bone_transf_obj = skeleton.get_bone_global_pose(target_bone_id)		# 2)
	var bone_transf_world = skeleton.global_transform * bone_transf_obj		# 3)

	# Get the global Transform3D of the parent bone.
	var parent_transf_world = skeleton.global_transform * skeleton.get_bone_global_pose(parent_bone_id)

	# When inactive SpringBone only follows the global position of TargetBone.
	if !active_flag:
		set_global_transform(bone_transf_world)
		return

	# Start point initialization.
	if pos0 == Vector3(0,0,0):
		pos0 = bone_transf_world.origin
	
	# Updated location of self(SpringBone).
	act_spring(delta)
	
	# Orient the parent bone toward the self(SpringBone).
	look_at_spring_bone(parent_transf_world.origin)
