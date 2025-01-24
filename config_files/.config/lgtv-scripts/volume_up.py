import subprocess

def volume_up():
    try:
        subprocess.run(
            ["/Users/traag222/.local/bin/lgtv", "volumeUp", "--name", "LG_C2", "--ssl"],
            check=True
        )
        print("Volume increased successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    volume_up()
