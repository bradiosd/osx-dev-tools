# Video to MP3 Converter

Interactive bash script to convert video files to MP3 audio with optimized compression for smallest file sizes.

## Features

- 📋 **Interactive video selection** - Lists all videos with modification dates
- 🆕 **Newest first** - Videos sorted by modification time
- 📦 **Three quality presets**:
  - **64kbps mono** - Smallest size, ideal for speech/meetings/podcasts
  - **96kbps mono** - Small size, good quality for speech
  - **128kbps stereo** - Balanced quality for music/general use
- 🏷️ **Automatic naming** - Outputs include bitrate and timestamp
- 📁 **Relative paths** - Works from any directory
- ♻️ **Batch conversion** - Convert multiple videos in one session

## Requirements

- **ffmpeg** - Automatically prompts installation via Homebrew if missing
- **macOS** or Linux

## Directory Structure

```
video-analysing/
├── convert-video-to-mp3.sh
├── video/              # Place video files here
└── mp3/                # MP3 files output here
```

## Usage

### Basic Usage

1. Place your video files in the `video/` directory
2. Run the script:
   ```bash
   ./convert-video-to-mp3.sh
   ```

3. Select a video from the numbered list
4. Choose quality preset (1-3)
5. Wait for conversion to complete

### Running from Anywhere

The script uses relative paths based on its location, so you can run it from any directory:

```bash
/path/to/video-analysing/convert-video-to-mp3.sh
```

### Output Format

Converted files are named: `[original-name] [bitrate] [timestamp].mp3`

Example:
```
B2B Mastermind Monday 9th Feb 64k 20260212143021.mp3
```

Timestamp format: `YYYYMMDDHHMMSS` (Year-Month-Day Hour-Minute-Second)

## Supported Video Formats

- MP4 (.mp4)
- M4V (.m4v)
- MOV (.mov)
- AVI (.avi)
- MKV (.mkv)
- WMV (.wmv)
- FLV (.flv)

## Quality Presets Comparison

For a 44-minute video:

| Preset | Bitrate | Channels | File Size | Best For |
|--------|---------|----------|-----------|----------|
| Option 1 | 64kbps | Mono | ~21MB | Speech, meetings, podcasts |
| Option 2 | 96kbps | Mono | ~32MB | Higher quality speech |
| Option 3 | 128kbps | Stereo | ~43MB | Music, general audio |

## Installation

If ffmpeg is not installed, the script will show an error. Install it with:

```bash
brew install ffmpeg
```

## Tips

- **For meetings/calls**: Use Option 1 (64kbps mono) for smallest files
- **For music**: Use Option 3 (128kbps stereo) for better quality
- **Batch conversion**: The script allows converting multiple videos without restarting
- Press **0** to exit at any time

## Example Session

```
Found 2 video file(s)

Select a video to convert to MP3 (sorted by newest first):

1) B2B Mastermind Monday 9th Feb.m4v [2026-02-10 10:31]
2) Team Meeting Jan 15.mp4 [2026-01-15 14:22]

Enter the number of the video to convert (or 0 to exit): 1

Converting: B2B Mastermind Monday 9th Feb.m4v

Choose conversion quality:
1) Smallest size - 64kbps mono (best for speech)
2) Small size - 96kbps mono (good for speech)
3) Balanced - 128kbps stereo (music/general use)

Enter choice (1-3, default: 1): 1
Using 64kbps mono (smallest size)...
Output: B2B Mastermind Monday 9th Feb 64k 20260212143021.mp3

✓ Conversion complete!
File size: 21.5MB

Convert another video? (y/n, default: n):
```
