
# Mighty Bomb Jack disassembly

This is a work-in-progress disassembly of _Mighty Bomb Jack_ for the NES/Famicom.

You can build the game by running `build.bat` or `build.sh`, or running the following commands:

* Japanese release: `tools\asm6f_64.exe mighty-bomb-jack.asm bin\mbj-jp.nes`
* Japanese revision A: `tools\asm6f_64.exe -dREV_A mighty-bomb-jack.asm bin\mbj-jp-rev-a.nes`
* USA: `tools\asm6f_64.exe -dREV_US mighty-bomb-jack.asm bin\mbj-us.nes`

More details to come.


## A note on opcode usage

In this disassembly, you will see pseudo-opcodes like `LDAc Memory, X`. These are macros that will either use absolute addressing (`LDA a:Memory,X`) or normal zero-page addressing depending on the build.

In other cases, you will see absolute addressing with `a:Memory` directly; in these cases, all revisions of the game use the non-zero page opcode.

I don't know why, either. It is not consistent at all.

----

Assembler used: [asm6f](https://github.com/freem/asm6f)
