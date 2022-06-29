import os
from PIL import Image

# Default Path
scriptDir = os.path.dirname(__file__)

# Array of Trait Files
background = [
  os.path.join(scriptDir, "traits/background/1.png")
]
headType = [
  os.path.join(scriptDir, "traits/headType/1.png"),
  os.path.join(scriptDir, "traits/headType/2.png")
]
headTop = [
  os.path.join(scriptDir, "traits/headTop/1.png"),
  os.path.join(scriptDir, "traits/headTop/2.png")
]
headVision = [
  os.path.join(scriptDir, "traits/headVision/1.png"),
]
headSpeaker = [
  os.path.join(scriptDir, "traits/headSpeaker/1.png"),
]
bodyType = [
  os.path.join(scriptDir, "traits/bodyType/1.png"),
]
bodyComponent = [
  os.path.join(scriptDir, "traits/bodyComponent/1.png"),
]

counter = 0

def createImage(a, b, c, d, e, f, g, counter):
  # Open & convert image
  image00 = Image.open(background[a]).convert("RGBA")
  image01 = Image.open(headType[b]).convert("RGBA")
  image02 = Image.open(headTop[c]).convert("RGBA")
  image03 = Image.open(headVision[d]).convert("RGBA")
  image04 = Image.open(headSpeaker[e]).convert("RGBA")
  image05 = Image.open(bodyType[f]).convert("RGBA")
  image06 = Image.open(bodyComponent[g]).convert("RGBA")

  # Combine all traits
  intermediate0 = Image.alpha_composite(image00, image01)
  intermediate1 = Image.alpha_composite(intermediate0, image02)
  intermediate2 = Image.alpha_composite(intermediate1, image03)
  intermediate3 = Image.alpha_composite(intermediate2, image04)
  intermediate4 = Image.alpha_composite(intermediate3, image05)
  intermediate5 = Image.alpha_composite(intermediate4, image06)

  # Save Image
  intermediate5.save(
    os.path.join(scriptDir, "result/" + str(counter) + ".png")
  )

for a in range(len(background)):
  for b in range(len(headType)):
    for c in range(len(headTop)):
      for d in range(len(headVision)):
        for e in range(len(headSpeaker)):
          for f in range(len(bodyType)):
            for g in range(len(bodyComponent)):
              createImage(a, b, c, d, e, f, g, counter)
              counter = counter + 1