# SimpleSpringBone
A bone that automatically shakes when the position moves for Godot 4.0.

## What is this?
A simple module that works with Game Engene Godot 4.0 or later that adds spring-like bone behavior.

## How does it work?
1. Add an object(SpringBone) that makes simple oscillation to the TargetBone position (pos0).
2. The Target Bone's ParentBone(like Bone6) keeps looking towards the SpringBone.
3. Add SpringBones to all children of the bone you want to shake.

> Here's an example targeting Bone7.

![example_fig](https://github.com/coati-time/SimpleSpringBone/blob/main/example/example_fig.png)

> Example added to Bone01~Bone07.

https://user-images.githubusercontent.com/81456447/197332605-0a8a0a0b-4707-4abe-b2f7-52592778c86d.mp4

## How to install this?
1. Download this repository and add simple_spring_bone to your Godot project's addons folder”.
2. Enable SpringBone from "Project > Project Settings > Plugins".

## How to use this?
1. Add a SpringBone node to the Skeleton3D branch.
2. Specify the target bone and check active.

![add_springbone_node](https://user-images.githubusercontent.com/81456447/197333771-7d012a44-45ff-42d6-a4c0-a7d2d9fae2f5.png)

![make_active](https://user-images.githubusercontent.com/81456447/197333833-8cbcb9a2-4b17-4278-9a53-baec61ae5938.png)

## Known issues.
https://github.com/coati-time/SimpleSpringBone/issues
