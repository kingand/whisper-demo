#!/bin/sh
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p /mnt/output-transcriptions/benchmark/$TIMESTAMP/

touch /mnt/output-transcriptions/benchmark/$TIMESTAMP/benchmark-$TIMESTAMP.log

transcribe()  {
    local begin=$(date +%s)
    printf "[$(date)] ($1) Beginning transcription\n" >> /mnt/output-transcriptions/benchmark/$2/transcription-$1-$2.log
    local resultCode=$(whisper --model $1 --verbose $3 --language en --task transcribe \
        --model_dir=/mnt/whisper-models \
        --output_dir=/mnt/output-transcriptions/benchmark/$2/$1 \
        /mnt/input-audio/* > /mnt/output-transcriptions/benchmark/$2/transcription-$1-$2.log 2>&1)
    local end=$(date +%s)
    # Reference for elapsed time calculation: https://stackoverflow.com/a/22141974
    local elapsedSecs=$(($end-$begin))
    local elapsedTime="$(($elapsedSecs / 3600))h $((($elapsedSecs % 3600) / 60))m $(($elapsedSecs % 60))s"
    if [ $resultCode -ne 0]
    then
        printf "[$(date)] ($1) Transcription failed after $elapsedTime\n" >> /mnt/output-transcriptions/benchmark/$2/benchmark-$2.log
        return 1
    fi
    printf "[$(date)] ($1) Transcription completed in $elapsedTime\n" >> /mnt/output-transcriptions/benchmark/$2/benchmark-$2.log
    return 0
}

RETURN_CODE=0
RETURN_CODE=$RETURN_CODE+$(transcribe "tiny" $TIMESTAMP "False")
RETURN_CODE=$RETURN_CODE+$(transcribe "base" $TIMESTAMP "False")
RETURN_CODE=$RETURN_CODE+$(transcribe "small" $TIMESTAMP "False")
RETURN_CODE=$RETURN_CODE+$(transcribe "medium" $TIMESTAMP "False")
RETURN_CODE=$RETURN_CODE+$(transcribe "large-v2" $TIMESTAMP "False")

if [$RETURN_CODE -ne 0]
then
    exit 1
fi
exit 0