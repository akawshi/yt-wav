## 何これ

[yt-dlp](https://github.com/yt-dlp/yt-dlp) で wav ファイルを作成するプログラムです。ダブルクリックで動作します  
Linux 向けで Windows では動作を想定していません。また, 確認ダイアログに zenity を使用しています  
yt-dlp や ffmpeg などのセットアップは各自で調べて済ませておいてください  

## sh ファイル

yt-wav.sh では [zenity](https://help.gnome.org/users/zenity/stable/index.html.ja) のインストールが必要です。`sudo apt install zenity` や `sudo pacman -S zenity` などでインストールしてください（インストール方法はパッケージマネージャによって異なります）  
sh ファイルには実行権限を与えてください

## 免責

プログラムの使用による損失, または使用によって生じた法律上のいかなるトラブルも, 制作者は責任を負わないものとします  
使用は自己責任でおこなってください  
