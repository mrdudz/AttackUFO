
test: ufo.inc ufo2000.asm ufo6000.asm ufoA000.asm ufoE000.asm
	acme -f cbm -o ufo2-2000.prg -DKERNALPATCH=1 -DBREAKPATCH=1 ufo2000.asm
	acme -f cbm -o ufo2-6000.prg -DKERNALPATCH=1 -DBREAKPATCH=1 ufo6000.asm
	acme -f cbm -o ufo2-A000.prg -DKERNALPATCH=1 -DBREAKPATCH=1 ufoA000.asm
	acme -f cbm -o ufo2-E000.prg -DKERNALPATCH=1 -DBREAKPATCH=1 ufoE000.asm
	sdl2-xvic -VICflipx -VICflipy -VICrotate -memory all -kernal ufo2-E000.prg  -cart2 ufo2-2000.prg -cart6 ufo2-6000.prg -cartA ufo2-A000.prg

test1: ufo.inc ufo2000.asm ufo6000.asm ufoA000.asm ufoE000.asm
	acme -f cbm -o ufo1-2000.prg -DKERNALPATCH=1 -DBREAKPATCH=0 ufo2000.asm
	acme -f cbm -o ufo1-6000.prg -DKERNALPATCH=1 -DBREAKPATCH=0 ufo6000.asm
	acme -f cbm -o ufo1-A000.prg -DKERNALPATCH=1 -DBREAKPATCH=0 ufoA000.asm
	acme -f cbm -o ufo1-E000.prg -DKERNALPATCH=1 -DBREAKPATCH=0 ufoE000.asm
	sdl2-xvic -VICflipx -VICflipy -VICrotate -memory all -kernal ufo1-E000.prg -cart2 ufo1-2000.prg -cart6 ufo1-6000.prg -cartA ufo1-A000.prg
test2: ufo.inc ufo2000.asm ufo6000.asm ufoA000.asm ufoE000.asm
	acme -f cbm -o ufo4-2000.prg -DKERNALPATCH=0 -DBREAKPATCH=1 ufo2000.asm
	acme -f cbm -o ufo4-6000.prg -DKERNALPATCH=0 -DBREAKPATCH=1 ufo6000.asm
	acme -f cbm -o ufo4-A000.prg -DKERNALPATCH=0 -DBREAKPATCH=1 ufoA000.asm
	acme -f cbm -o ufo4-E000.prg -DKERNALPATCH=0 -DBREAKPATCH=1 ufoE000.asm
	sdl2-xvic -VICflipx -VICflipy -VICrotate -memory all -kernal ufo4-E000.prg -cart2 ufo4-2000.prg -cart6 ufo4-6000.prg -cartA ufo4-A000.prg
test3: ufo.inc ufo2000.asm ufo6000.asm ufoA000.asm ufoE000.asm
	acme -f cbm -o ufo3-2000.prg -DKERNALPATCH=0 -DBREAKPATCH=0 ufo2000.asm
	acme -f cbm -o ufo3-6000.prg -DKERNALPATCH=0 -DBREAKPATCH=0 ufo6000.asm
	acme -f cbm -o ufo3-A000.prg -DKERNALPATCH=0 -DBREAKPATCH=0 ufoA000.asm
	acme -f cbm -o ufo3-E000.prg -DKERNALPATCH=0 -DBREAKPATCH=0 ufoE000.asm
	sdl2-xvic -VICflipx -VICflipy -VICrotate -memory all -kernal ufo3-E000.prg  -cart2 ufo3-2000.prg -cart6 ufo3-6000.prg -cartA ufo3-A000.prg

clean:
	$(RM) ufo1-2000.prg ufo1-6000.prg ufo1-A000.prg ufo1-E000.prg
	$(RM) ufo2-2000.prg ufo2-6000.prg ufo2-A000.prg ufo2-E000.prg
	$(RM) ufo3-2000.prg ufo3-6000.prg ufo3-A000.prg ufo3-E000.prg
	$(RM) ufo4-2000.prg ufo4-6000.prg ufo4-A000.prg ufo4-E000.prg
