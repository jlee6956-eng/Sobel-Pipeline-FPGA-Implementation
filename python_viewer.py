from PIL import Image

def load_image(path):
    return Image.open(path)

def convert_to_grayscale(img, size=None):
    gray = img.convert("L")
    if size is not None:
        gray = gray.resize(size)
    return gray

def write_mem_file(gray_img, out_path):
    pixels = list(gray_img.getdata())

    with open(out_path, "w") as f:
        for pixel in pixels:
            f.write(f"{pixel:08b}\n")

def main():
    img = load_image("../Images/TEST_IMAGE_1.png")
    gray = convert_to_grayscale(img, size=(8, 8))
    write_mem_file(gray, "image.mem")
    print("Wrote image.mem")

if __name__ == "__main__":
    main()