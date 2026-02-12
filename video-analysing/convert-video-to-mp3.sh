#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Directory paths relative to script location
VIDEO_DIR="$SCRIPT_DIR/video"
MP3_DIR="$SCRIPT_DIR/mp3"

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Install it with: brew install ffmpeg"
    exit 1
fi

# Check if video directory exists
if [ ! -d "$VIDEO_DIR" ]; then
    echo "Error: Video directory not found at $VIDEO_DIR"
    exit 1
fi

# Create mp3 directory if it doesn't exist
mkdir -p "$MP3_DIR"

# Find all video files with their modification times
temp_files=()
temp_times=()
while IFS= read -r -d '' file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        mod_time=$(stat -f "%m" "$file")
    else
        mod_time=$(stat -c "%Y" "$file")
    fi
    temp_files+=("$file")
    temp_times+=("$mod_time")
done < <(find "$VIDEO_DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.mkv" -o -iname "*.wmv" -o -iname "*.flv" \) -print0)

# Sort files by modification time (newest first)
videos=()
video_dates=()
while IFS= read -r idx; do
    file="${temp_files[$idx]}"
    videos+=("$file")
    # Get modification time in readable format
    if [[ "$OSTYPE" == "darwin"* ]]; then
        mod_date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file")
    else
        mod_date=$(stat -c "%y" "$file" | cut -d'.' -f1 | sed 's/\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\) \([0-9]\{2\}:[0-9]\{2\}\).*/\1 \2/')
    fi
    video_dates+=("$mod_date")
done < <(
    for i in "${!temp_times[@]}"; do
        echo "$i ${temp_times[$i]}"
    done | sort -rn -k2 | cut -d' ' -f1
)

# Check if any videos were found
if [ ${#videos[@]} -eq 0 ]; then
    echo "No video files found in $VIDEO_DIR"
    exit 1
fi

echo "Found ${#videos[@]} video file(s)"
echo ""
echo "Select a video to convert to MP3 (sorted by newest first):"
echo ""

# Create display array with filenames and dates
display_options=()
for i in "${!videos[@]}"; do
    filename=$(basename "${videos[$i]}")
    display_options+=("$filename [${video_dates[$i]}]")
done

# Display the list with numbers
PS3=$'\nEnter the number of the video to convert (or 0 to exit): '
select display_choice in "${display_options[@]}"; do
    # Get the actual video file from the selected index
    video_file="${videos[$((REPLY-1))]}"
    if [ "$REPLY" == "0" ]; then
        echo "Exiting..."
        exit 0
    fi
    
    if [ -n "$video_file" ]; then
        # Get the filename without path and extension
        filename=$(basename "$video_file")
        base_name="${filename%.*}"
        
        echo ""
        echo "Converting: $filename"
        echo ""
        echo "Choose conversion quality:"
        echo "1) Smallest size - 64kbps mono (best for speech)"
        echo "2) Small size - 96kbps mono (good for speech)"
        echo "3) Balanced - 128kbps stereo (music/general use)"
        echo ""
        read -p "Enter choice (1-3, default: 1): " quality_choice
        
        quality_choice=${quality_choice:-1}
        
        # Determine bitrate label and ffmpeg parameters
        case $quality_choice in
            1)
                bitrate_label="64k"
                echo "Using 64kbps mono (smallest size)..."
                ffmpeg_params="-vn -acodec libmp3lame -b:a 64k -ac 1"
                ;;
            2)
                bitrate_label="96k"
                echo "Using 96kbps mono (small size)..."
                ffmpeg_params="-vn -acodec libmp3lame -b:a 96k -ac 1"
                ;;
            3)
                bitrate_label="128k"
                echo "Using 128kbps stereo (balanced)..."
                ffmpeg_params="-vn -acodec libmp3lame -b:a 128k"
                ;;
            *)
                bitrate_label="64k"
                echo "Invalid choice. Using default (64kbps mono)..."
                ffmpeg_params="-vn -acodec libmp3lame -b:a 64k -ac 1"
                ;;
        esac
        
        # Generate timestamp (YYYYMMDDHHMMSS)
        timestamp=$(date +%Y%m%d%H%M%S)
        
        # Create output filename with bitrate and timestamp
        output_name="${base_name} ${bitrate_label} ${timestamp}.mp3"
        output_path="$MP3_DIR/$output_name"
        
        echo "Output: $output_name"
        echo ""
        
        # Run ffmpeg with the selected parameters
        ffmpeg -i "$video_file" $ffmpeg_params "$output_path" -y
        
        if [ $? -eq 0 ]; then
            filesize=$(du -h "$output_path" | cut -f1)
            echo ""
            echo "✓ Conversion complete!"
            echo "Output file: $output_path"
            echo "File size: $filesize"
        else
            echo ""
            echo "✗ Conversion failed!"
            exit 1
        fi
        
        echo ""
        read -p "Convert another video? (y/n, default: n): " continue_choice
        if [[ ! $continue_choice =~ ^[Yy]$ ]]; then
            echo "Exiting..."
            exit 0
        fi
        
        echo ""
        echo "Select another video to convert:"
        echo ""
    else
        echo "Invalid selection. Please try again."
    fi
done
