import subprocess


def list(title, width, height, text, extra_buttons, columns, data):
    result = subprocess.run([
        "zenity", "--list",
        "--title=" + title,
        "--width=" + str(width),
        "--height=" + str(height),
        "--text=" + text,
        *["--extra-button=" + b for b in extra_buttons],
        *["--column=" + c for c in columns],
        *data
    ], stdout=subprocess.PIPE, text=True)
    return result.stdout[:-1]
