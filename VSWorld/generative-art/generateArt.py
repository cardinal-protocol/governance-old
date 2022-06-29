import os
from PIL import Image

script_dir = os.path.dirname(__file__)

headType = [
  os.path.join(script_dir, "traits/headType/1.png"),
  os.path.join(script_dir, "traits/headType/2.png")
]
headTop = [
  os.path.join(script_dir, "traits/headTop/1.png"),
  os.path.join(script_dir, "traits/headTop/2.png")
]
headVision = [
  os.path.join(script_dir, "traits/headVision/1.png"),
]
headSpeaker = [
  os.path.join(script_dir, "traits/headSpeaker/1.png"),
]
bodyType = [
  os.path.join(script_dir, "traits/bodyType/1.png"),
]
bodyComponent = [
  os.path.join(script_dir, "traits/bodyComponent/1.png"),
]

counter = 0

def createImage(a, b, c, d, e, f, counter):
  image01 = Image.open(headType[a]).convert("RGBA")
  image02 = Image.open(headTop[b]).convert("RGBA")
  image03 = Image.open(headVision[c]).convert("RGBA")
  image04 = Image.open(headSpeaker[d]).convert("RGBA")
  image05 = Image.open(bodyType[e]).convert("RGBA")
  image06 = Image.open(bodyComponent[f]).convert("RGBA")

  intermediate = Image.alpha_composite(image01, image02)
  intermediate2 = Image.alpha_composite(intermediate, image03)
  intermediate3 = Image.alpha_composite(intermediate2, image04)
  intermediate4 = Image.alpha_composite(intermediate3, image05)
  intermediate5 = Image.alpha_composite(intermediate4, image06)

  name = os.path.join(script_dir, "result/" + str(counter) + ".png")

  intermediate5.save(name)

for a in range(len(headType)):
  for b in range(len(headTop)):
    for c in range(len(headVision)):
      for d in range(len(headSpeaker)):
        for e in range(len(bodyType)):
          for f in range(len(bodyComponent)):
            createImage(a, b, c, d, e, f, counter)
            counter = counter + 1