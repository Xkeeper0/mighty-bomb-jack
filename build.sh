#!/bin/sh

REVJP="73c3931cd37401c34079b3cce95888f10ba3d93174021132e59285e3c188d276"
REVJPA="a72c76ce8e233cdb83f5b45f96cf4acec3e5227371e8f0739b1280829bc3e020"
REVUS="8676274043b39ad72f6402d4d5d339590f029f0cc23624745bc8dda7038f150d"

compareHash() {
	echo $1 $2 | sha256sum --check > /dev/null 2>&1
}

build() {
	tools/asm6f mighty-bomb-jack.asm "$@"
	if [ $? -ne 0 ] ; then
		echo 'Build failed!'
		exit 1
	fi
}


build bin/mbj-jp.nes
if compareHash $REVJP 'bin/mbj-jp.nes' -eq 0 ; then
	echo 'Matched JP ROM.'
fi
build -dREV_A bin/mbj-jp-rev-a.nes
if compareHash $REVJPA 'bin/mbj-jp-rev-a.nes' -eq 0 ; then
	echo 'Matched JP Rev A ROM.'
fi
build -dREV_US bin/mbj-us.nes
if compareHash $REVUS 'bin/mbj-us.nes' -eq 0 ; then
	echo 'Matched US ROM.'
fi

