from PIL import Image
import os

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
]
headSpeaker = [
]
bodyType = [
]
bodyComponent = [
]

counter = 0

def createImage(a, b, counter):
  image01 = Image.open(headType[a]).convert("RGBA")
  image02 = Image.open(headTop[b]).convert("RGBA")
  '''
  image03 = Image.open(headVision[c]).convert("RGBA")
  image04 = Image.open(headSpeaker[d]).convert("RGBA")
  image05 = Image.open(bodyType[e]).convert("RGBA")
  image06 = Image.open(bodyComponent[f]).convert("RGBA")
  '''


  intermediate = Image.alpha_composite(image01, image02)
  '''
  intermediate2 = Image.alpha_composite(intermediate, image03)
  intermediate3 = Image.alpha_composite(intermediate2, image04)
  intermediate4 = Image.alpha_composite(intermediate3, image05)
  intermediate5 = Image.alpha_composite(intermediate4, image06)
  '''

  name = os.path.join(script_dir, "result/" + str(counter) + ".png")
  
  intermediate.save(name)


for a in range(len(headType)):
  for b in range(len(headTop)):
    createImage(a, b, counter)
    counter = counter + 1

'''
for a in range(4):
  for b in range(4):
    for c in range(4):
      for d in range(4):
        for e in range(4):
          for f in range(2):
            createImage(a,b,c,d,e,f,counter)
             counter = counter + 1
'''    