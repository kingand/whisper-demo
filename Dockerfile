# Using official Debian base image from https://hub.docker.com/_/debian
FROM debian:latest

# Install Python 3 and PIP
RUN apt update && apt install -y python3 && apt install -y python3-pip

# Install Whisper dependencies
RUN apt install -y ffmpeg
RUN pip install -U torch torchvision torchaudio

# Install OpenAI Whisper
RUN pip install -U openai-whisper

# Install whisper-demo
ADD bin /opt/whisper-demo/bin
RUN chmod +x /opt/whisper-demo/bin/*
#ENTRYPOINT ["/opt/whisper-demo/bin/transcribe.sh"]
