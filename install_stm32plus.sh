#!/bin/bash
#=========================
# stm32plseのインストール
#=========================

# このスクリプトはcloneしてから実行すること
set -eu
SCRIPT_DIR=$(cd $(dirname $0); pwd)

sudo apt-get -y install scons 1> /dev/null  &&  echo 'sconsのインストールが完了しました'

cp "$SCRIPT_DIR"/stm32plus_nostlthrow_git.patch /tmp
cd /tmp 

if [ -e stm32plus ]; then
  echo "Delete old stm32plus files"
  rm -rf stm32plus
fi

#git clone https://github.com/spiralray/stm32plus.git -b can-support
git clone https://github.com/andysworkshop/stm32plus.git
#patch -b stm32plus/lib/include/stl/string < stm32plus_nostlthrow.patch
cd stm32plus
git apply ../stm32plus_nostlthrow_git.patch

scons mode=small mcu=f1md hse=12000000 -j4 examples=no 1> /dev/null && echo 'OK'
scons mode=small mcu=f1hd hse=12000000 -j4 examples=no 1> /dev/null && echo 'OK'
scons mode=small mcu=f1md hse=8000000 -j4 examples=no  1> /dev/null && echo 'OK'
scons mode=small mcu=f1hd hse=8000000 -j4 examples=no  1> /dev/null && echo 'OK'

scons mode=small mcu=f4 hse=25000000 -j4 float=hard examples=no 1> /dev/null  &&  echo 'OK'
scons mode=small mcu=f4 hse=8000000 -j4 float=hard examples=no  1> /dev/null  &&  echo 'OK'
scons mode=small mcu=f4 hse=12000000 -j4 float=hard examples=no 1> /dev/null  &&  echo 'OK'

scons mode=small mcu=f429 hse=8000000 -j4 float=hard examples=no 1> /dev/null  &&  echo 'OK'

echo 'stm32plseのビルドが完了しました'

if [ -e ~/workspace/stm32plus ]; then
  echo "Delete old stm32plus files"
  rm -rf ~/workspace/stm32plus
fi

mkdir -p ~/workspace
mv ./lib ~/workspace/stm32plus

cd  ~/workspace/stm32plus/build

#To be compatible with old stm32plus

cp -r small-f1hd-8000000e small-f1hd-8000000
cp -r small-f1hd-12000000e small-f1hd-12000000
cp -r small-f1md-8000000e small-f1md-8000000
cp -r small-f1md-12000000e small-f1md-12000000
cp -r small-f4-8000000e-hard small-f4-8000000-hard
cp -r small-f4-25000000e-hard small-f4-25000000-hard
cp -r small-f429-8000000e-hard small-f429-8000000-hard

cd small-f1hd-8000000
cp libstm32plus-small-f1hd-8000000e.a libstm32plus-small-f1hd-8000000.a

cd ../small-f1hd-12000000
cp libstm32plus-small-f1hd-12000000e.a libstm32plus-small-f1hd-12000000.a

cd ../small-f1md-8000000
cp libstm32plus-small-f1md-8000000e.a libstm32plus-small-f1md-8000000.a

cd ../small-f1md-12000000
cp libstm32plus-small-f1md-12000000e.a libstm32plus-small-f1md-12000000.a

cd ../small-f4-8000000-hard
cp libstm32plus-small-f4-8000000e-hard.a libstm32plus-small-f4-8000000-hard.a

cd ../small-f4-25000000-hard
cp libstm32plus-small-f4-25000000e-hard.a libstm32plus-small-f4-25000000-hard.a

cd ../small-f429-8000000-hard
cp libstm32plus-small-f429-8000000e-hard.a libstm32plus-small-f429-8000000-hard.a