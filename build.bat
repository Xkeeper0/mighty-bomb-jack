@REM asm6f_32.exe mighty-bomb-jack.asm bin\mbj.nes -n
@REM asm6f_32.exe -dREV_A mighty-bomb-jack.asm bin\mbj-rev-a.nes -n
@REM fc /b bin\mbj.nes "bin\Mighty Bomb Jack (Japan).nes"
@REM fc /b bin\mbj-rev-a.nes "bin\Mighty Bomb Jack (Japan) (Rev A).nes"

tools\asm6f_32.exe mighty-bomb-jack.asm bin\mbj.nes
tools\asm6f_32.exe -dREV_US mighty-bomb-jack.asm bin\mbj-us.nes
fc /b bin\mbj.nes "bin\Mighty Bomb Jack (Japan).nes"
fc /b bin\mbj-us.nes "bin\Mighty Bomb Jack (USA).nes"
