import subprocess

def volume_down():
    try:
        subprocess.run(
            ["/Users/traag222/.local/bin/lgtv", "volumeDown", "--name", "LG_C2", "--ssl"],
            check=True
        )
        print("Volume decreased successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    volume_down()
