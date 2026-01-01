#!/bin/bash

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ffmpeg が同じフォルダにある場合、そのパスを優先
export PATH="$SCRIPT_DIR:$PATH"

# 必要コマンド確認
if ! command -v zenity &> /dev/null; then
  echo "zenity が見つかりません。"
  exit 1
fi

if ! command -v yt-dlp &> /dev/null; then
  zenity --error --text="yt-dlp が見つかりません。\nhttps://github.com/yt-dlp/yt-dlp"
  exit 1
fi

# URL入力
URL=$(zenity --entry --title="yt-dlp wav 変換" --text="URLを入力してください:")
[ -z "$URL" ] && exit 0

# 出力先
OUTPUT_DIR=$(zenity --file-selection --directory --title="出力先ディレクトリを選択してください")
[ -z "$OUTPUT_DIR" ] && exit 0

# ファイル名
FILENAME=$(zenity --entry --title="ファイル名" --text="ファイル名を入力してください（拡張子不要）:" --entry-text="song")
[ -z "$FILENAME" ] && exit 0

# wav生成
(
  yt-dlp -x \
    --audio-format wav \
    -o "${OUTPUT_DIR}/${FILENAME}.%(ext)s" \
    --postprocessor-args "ffmpeg:-acodec pcm_s16le -bitexact" \
    "$URL"
  echo "100"
) | zenity --progress --title="ダウンロード中..." --percentage=0 --auto-close

zenity --info --text="完了しました！\n出力ファイル: ${OUTPUT_DIR}/${FILENAME}.wav"

# ==============================
# cinema-video.json 作成確認
# ==============================
zenity --question --title="cinema-video.json" \
  --text="cinema-video.json を自動生成しますか？"
if [ $? -ne 0 ]; then
  exit 0
fi

# メタデータ取得
META_JSON=$(yt-dlp --dump-single-json "$URL")

VIDEO_ID=$(yt-dlp --print "%(id)s" "$URL")
TITLE=$(yt-dlp --print "%(title)s" "$URL")
AUTHOR=$(yt-dlp --print "%(uploader)s" "$URL")
DURATION=$(yt-dlp --print "%(duration)s" "$URL")

JSON_PATH="${OUTPUT_DIR}/cinema-video.json"

cat > "$JSON_PATH" <<EOF
{
    "videoID": "$VIDEO_ID",
    "title": "$TITLE",
    "author": "$AUTHOR",
    "duration": $DURATION,
    "offset": ,
    "configByMapper": true
}
EOF

zenity --info --title="cinema-video.json 作成完了" \
  --text="cinema-video.json を生成しました。\n\n⚠ offset の設定をお忘れなく"
