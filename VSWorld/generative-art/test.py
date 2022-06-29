from PIL import Image

group1 = [
  r"/home/harpoon/Desktop/cardinal/generative-art-nft/images/traits/a1.png",
  r"/home/harpoon/Desktop/cardinal/generative-art-nft/images/traits/a2.png"
]
group2 = [
  r"/home/harpoon/Desktop/cardinal/generative-art-nft/images/traits/b1.png",
  r"/home/harpoon/Desktop/cardinal/generative-art-nft/images/traits/b2.png"
]

counter = 0

def createImage(a,b,counter):
  first = group1[a]
  second = group2[b]

  image01 = Image.open(first).convert("RGBA")
  image02 = Image.open(second).convert("RGBA")


  intermediate = Image.alpha_composite(image01, image02)

  name = "/home/harpoon/Desktop/cardinal/generative-art-nft/images/result/" + str(counter) + ".png"
  intermediate.save(name)


for a in range(2):
  for b in range(2):
    createImage(a,b,counter)
    counter = counter + 1