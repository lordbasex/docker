#!/usr/bin/python

import os
import sys
import whisper
import torch
import json
import datetime

if torch.cuda.is_available():
  device = torch.device("cuda:0")
  print("GPU")
  print(torch.cuda.current_device())
  print(torch.cuda.device(0))
  print(torch.cuda.get_device_name(0))
else:
  device = torch.device("cpu")
  print("CPU")

t0 = datetime.datetime.now()
print(f"Load Model at {t0}")
model = whisper.load_model('medium')
t1 = datetime.datetime.now()
print(f"Loading took {t1-t0}")
print(f"started at {t1}")

audio = sys.argv[1]

# Check if path exits
if os.path.exists(audio) :
  print(f"filename: {audio}")
else :
  print("NOT ARGUMENT")
  audio = demo0.wav

language = "es"
output = model.transcribe(audio, language=language, temperature=0.0)

# show time elapsed after transcription is complete.
t2 = datetime.datetime.now()
print(f"ended at {t2}")
print(f"time elapsed: {t2 - t1}")

with open(audio+"_transcription.json", "w", encoding="utf-8") as f:
    f.write(json.dumps(output))
