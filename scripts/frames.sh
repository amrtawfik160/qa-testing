#!/usr/bin/env bash
# Turn a QA recording into images an agent can read.
# Usage: frames.sh <video> [out_dir] [fps]
# Writes: frame_NNNN.png at <fps> (default 2), each stamped with its timestamp,
# changes_NNNN.png for every scene change, and sheet_NN.png contact sheets (4x3).
set -euo pipefail
video="$1"; out="${2:-${video%.*}_frames}"; fps="${3:-2}"
mkdir -p "$out"
stamp="drawtext=text='%{pts\:hms}':x=10:y=10:fontsize=28:fontcolor=white:box=1:boxcolor=black@0.6"
ffmpeg -loglevel error -y -i "$video" -vf "fps=$fps,$stamp" "$out/frame_%04d.png"
ffmpeg -loglevel error -y -i "$video" -vf "select='gt(scene,0.08)',$stamp" -vsync vfr "$out/changes_%04d.png"
ffmpeg -loglevel error -y -i "$video" -vf "fps=$fps,$stamp,scale=640:-1,tile=4x3:padding=4" "$out/sheet_%02d.png"
dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$video")
echo "duration=${dur}s frames=$(ls "$out"/frame_*.png | wc -l) changes=$(ls "$out"/changes_*.png 2>/dev/null | wc -l) sheets=$(ls "$out"/sheet_*.png | wc -l) dir=$out"
