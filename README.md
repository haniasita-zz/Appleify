# Appleify
**A Windows batch script for bulk converting FLAC and WMA files to ALAC and MP3 respectively using FFMPEG**

The purpose of this script is to easily prepare an existing music library with FLAC and WMA files for importing into iTunes, by converting them to ALAC and MP3 (192kbs) respectively. Carries metadata and artwork during the process. Uses ffmpeg.exe from gyan.dev [ffmpeg-2021-05-05-git-7c451b609c-essentials_build.7z](https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z).

# Usage
- Put the script in a folder with ffmpeg.exe and run it
- Press S and paste a folder path containing audio files
- The script will list any found files and go back to the selection menu
- Press C to start converting the files, and Y to confirm
- The script will start processing files one by one, moving the original files to it's own folder, under "Originals"
- Once the script is done, the provided library should have all of it's FLAC and WMA files replaced with ALAC and MP3 files, with correct folder structures and metadata

# Notes
- This script will not work with files who contain percentage signs or exclamation marks. This is a limitation of Batch.
