# SimpleSpringBone
A bone that automatically shakes when the position moves for Godot 4.0.

## What is this?
A simple module that works with Game Engene Godot 4.0 or later that adds spring-like bone behavior.

## How does it work?
1. Add an object (SpringBone) that makes simple oscillation to the TargetBone position (pos0).
2. The Target Bone's ParentBone(like Bone6) keeps looking towards the SpringBone.
3. Add SpringBones to all children of the bone you want to shake.

> Here's an example targeting Bone7.

![example_fig](https://github.com/coati-time/SimpleSpringBone/blob/main/example/example_fig.png)

> Example added to Bone01~Bone07.

https://user-images.githubusercontent.com/81456447/197332605-0a8a0a0b-4707-4abe-b2f7-52592778c86d.mp4

