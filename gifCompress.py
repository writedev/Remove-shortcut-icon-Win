import os
import subprocess
from pathlib import Path
#  __________________________________________________________
# |                                                          |
# |I have use this python file only for compress my gif file |
# |__________________________________________________________|

def compress_gifs(folder_path: str):
    folder = Path(folder_path)
    gifs = list(folder.glob("*.gif"))

    if not gifs:
        print("⚠️ No gif file find in this folder.")
        return

    print(f"🎞️ Compression of {len(gifs)} GIF(s) in {folder_path}...\n")

    for gif in gifs:
        temp_output = gif.with_name(f"temp_{gif.name}")

        # Commande ffmpeg
        cmd = [
            "ffmpeg", "-y",
            "-i", str(gif),
            "-vf", (
                "fps=15,scale=800:-1:flags=lanczos,"
                "split[s0][s1];"
                "[s0]palettegen=max_colors=256[p];"
                "[s1][p]paletteuse=dither=bayer:bayer_scale=1:diff_mode=rectangle"
            ),
            str(temp_output)
        ]

        try:
            subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            os.replace(temp_output, gif)  # replace original file
            print(f"✅ {gif.name} file compressed.")
        except subprocess.CalledProcessError:
            print(f"❌ Erreur lors de la compression de {gif.name}.")
            if temp_output.exists():
                temp_output.unlink()  # delete temp file

    print("\n🎉 Compression finish !")

if __name__ == "__main__":
    dossier = input("📁 Enter your folder with gif file.").strip()
    compress_gifs(dossier)
