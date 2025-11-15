#!/bin/bash


# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ffmpeg が同じフォルダにある場合、そのパスを優先的に通す
export PATH="$SCRIPT_DIR:$PATH"

# 必要なコマンドがあるか確認
if ! command -v zenity &> /dev/null; then
  echo "zenity が見つかりません。インストールしてください。"
  echo "sudo pacman -S zenity"
  exit 1
fi

if ! command -v yt-dlp &> /dev/null; then
  zenity --error --text="yt-dlp が見つかりません。\nインストールしてください。\nhttps://github.com/yt-dlp/yt-dlp"
  exit 1
fi

# URL入力ダイアログ
URL=$(zenity --entry --title="yt-dlp wav 変換" --text="URLを入力してください:")
[ -z "$URL" ] && exit 0

# 保存先ディレクトリ選択
OUTPUT_DIR=$(zenity --file-selection --directory --title="出力先ディレクトリを選択してください")
[ -z "$OUTPUT_DIR" ] && exit 0

# ファイル名入力
FILENAME=$(zenity --entry --title="ファイル名" --text="ファイル名を入力してください（拡張子不要）:" --entry-text="song")
[ -z "$FILENAME" ] && exit 0

# 実行
(
  yt-dlp -x \
    --audio-format wav \
    -o "${OUTPUT_DIR}/${FILENAME}.%(ext)s" \
    --postprocessor-args "ffmpeg:-acodec pcm_s16le -bitexact" \
    "$URL"
  echo "100"
) | zenity --progress --title="ダウンロード中..." --percentage=0 --auto-close

# 完了メッセージ
zenity --info --text="完了しました！\n出力ファイル: ${OUTPUT_DIR}/${FILENAME}.wav"
