# Whisper Demo
The purpose of this project is to evaluate OpenAI's Whisper library for transcribing audio into text for use in Automatic Speech
Recognition (ASR) applications.

**Reference:** https://github.com/openai/whisper

This project is intended to be built as a Docker container and run via Docker Compose.  Both the Dockerfile and docker-compose.yml
files are available in the project root directory.

Whisper models are persisted in a Docker Volume, so that they do not need to be re-downloaded each time the container starts up,
because the models can be [rather large](https://github.com/openai/whisper#available-models-and-languages).

_**IMPORTANT:** Whisper must be run on a GPU! Although whisper can run on a CPU, it will run excessively slow regardless of speed or
number of cores.  Make sure a GPU is installed and available to Docker before running Whisper (see prerequsities section for more
details). An Nvidia GPU with CUDA support is strongly preferred as it offers the best performance for Whisper
[as explained here](https://www.reddit.com/r/MachineLearning/comments/10xp54e/p_get_2x_faster_transcriptions_with_openai/)._

## Prerequisites
1. Nvidia GPU is available with sufficient VRAM for the chosen model (~5GB for medium model).  Refer to the OpenAI Whisper
[documentation](https://github.com/openai/whisper#available-models-and-languages) for specific requirements.
2. Nvidia drivers are installed on the host machine (not in WSL)
3. Nvidia CUDA toolkit is installed and available.  Refer to
[this Gist](https://gist.github.com/kingand/ff301bc5b740abb43cd69350d9578d9d)
for more infromation.

## Build
1. Build the Docker container
    ```
    docker build -t kingand/whisper-demo .
    ```

## Run
1. Create an `.env` file next to `docker-compose.yml` to specify the input and output directories
    ```
    INPUT_DIR=/path/to/input/audio
    OUTPUT_DIR=/path/to/output/text
    ```
2. Ensure the both the input and output directories exist on the host machine with the appropriate permissions for Docker to access
3. Start up the container(s) via Docker Compose
    ```
    docker compose up
    ```

Transcription will begin automatically upon container startup using the whisper model and verbosity settings specified in
`docker-compose.yml` (see `command` section).

To change which Whisper model is used for transcription, modify the `command` section of `docker-compose.yml` before running
`docker compose up`.

Docker Compose will automatically shut down the containers when the transcription is complete.

## Benchmark
A benchmark script is also available in this project, which repeats the transcription using each Whisper model.

To run the benchmark, modify the `command` section of `docker-compose.yml` to specify `benchmark.sh` instead of
`transcribe.sh` before running `docker compose up`.

_**WARNING:** Larger models require a significant amount of VRAM.  If sufficient VRAM is not available, the container will hang and
may cause Docker to become unstable as well.  Consult OpenAI's
[documentation](https://github.com/openai/whisper#available-models-and-languages) and ensure sufficient VRAM is available before
running the benchmark.  If needed, larger models can be excluded from the benchmark by commenting them out in `benchmark.sh`.  In
this case, the container will need to be rebuilt to pick up the changes to `benchmark.sh`._
