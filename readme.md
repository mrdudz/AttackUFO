
## Attack UFO

![screenshot](img/attackufo.png)

This is a crude hack to make the japanese arcade game "Attack UFO" work on the
(european) VIC20. it kindof works and can be played, but its nowhere near
perfect, and probably not really playable.


as of now, the game needs RAM in bank0 and uses cartridge ROM in bank 1/2/3/5


you can start it in VICE like this:

 sdl2-xvic -VICflipx -VICflipy -VICrotate -memory all -cart2 ufo2-2000.prg -cart6 ufo2-6000.prg -cartA ufo2-A000.prg



- F7 - insert coins

- F1 - START one player game

- Joystick left/right/fire - guess what :)


gpz 10/12/2017
