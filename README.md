# RPG System for Unity 3D, a global state manager based on RPG Maker by Ayoze Manuel Fernández Acosta
## Emulates RPG Maker Event system with multiples pages that activates depending on switches and variables
[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## What is it?

The RPG System library is the best friend for all those developers who has worked in RPG Maker and wants to use a similar event system in Unity 3D.
You can add the RPG Event component to any GameObject, and add page events like in RPG Maker. 
Each page can have multiples RPG Actions that can be triggered in many ways (Autorun, player or event touch, player interaction). And of course, each page has his own switches/variables condition in order to be active just like in RPG Maker.
There are a lot of default RPG Actions, like Show Text, change variables, play SFX... but you can add your own actions aswell!

## How to start

- Download repository (it uses Unity 6)
- Open TEST LEVEL to check how it works

## Features

- RPG Event component, which simulates classic events from RPG Maker
- Can save/load state
- Uses UniTask library to achieve an efficient allocation free async/await
- DoTween powered by UniTask
- Odin Inspector for nice editor UI (you will need license for it, but they have a free trial)
- 2D or 3D compatible
- Easy to extend with your own functionality

## NOTE

This library is production ready but still requiring UI work to make it more user friendly.
I also want to make this project a framework for any new project that wants to use this system.

## License

You are free to use the RPG System, but you will need license for Odin Inspector.

## Other features

2D pathfinding: https://github.com/h8man/NavMeshPlus
