#!/bin/sh

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p /mnt/output-transcriptions/$TIMESTAMP/

touch /mnt/output-transcriptions/$TIMESTAMP/transcription-$1-$TIMESTAMP.log

transcribe()  {
    local begin=$(date +%s)
    printf "[$(date)] ($1) Beginning transcription\n" > /mnt/output-transcriptions/$2/transcription-$1-$2.log
    local resultCode=$(whisper --model $1 --verbose $3 --language en --task transcribe \
        --model_dir=/mnt/whisper-models \
        --output_dir=/mnt/output-transcriptions/$2 \
        /mnt/input-audio/* >> /mnt/output-transcriptions/$2/transcription-$1-$2.log 2>&1)
    local end=$(date +%s)
    # Reference for elapsed time calculation: https://stackoverflow.com/a/22141974
    local elapsedSecs=$(($end-$begin))
    local elapsedTime="$(($elapsedSecs / 3600))h $((($elapsedSecs % 3600) / 60))m $(($elapsedSecs % 60))s"
    if [ $resultCode -ne 0]
    then
        printf "[$(date)] ($1) Transcription failed after $elapsedTime\n" >> /mnt/output-transcriptions/$2/transcription-$1-$2.log
        return 1
    fi
    printf "[$(date)] ($1) Transcription completed in $elapsedTime\n" >> /mnt/output-transcriptions/$2/transcription-$1-$2.log
    return 0
}

transcribe $1 $TIMESTAMP $2

if [$? -ne 0]
then
    exit 1
fi
exit 0
