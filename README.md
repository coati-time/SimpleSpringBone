# SimpleSpringBone
A bone that automatically shakes when the position moves for Godot 4.0.

## What is this?
A simple module that works with Game Engene Godot 4.0 or later that adds spring-like bone behavior.

## How does it work?
1. Add an object (SpringBone) that makes simple oscillation to the target bone position (pos0).
2. The Target Bone's ParentBone(Bone6) keeps looking towards the SpringBone.

> Here's an example targeting Bone7.

![example_fig](https://github.com/coati-time/SimpleSpringBone/blob/main/example/example_fig.png)
