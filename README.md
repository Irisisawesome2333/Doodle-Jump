# Doodle-Jump
This is the implementation of the popular mobile game Doodler jump using MIPS assembly.
## Author
Irisisawesome2333
## Installation and Setup
1. Download the MARS v4.5 from [here](http://courses.missouristate.edu/kenvollmar/mars/download.htm)
2. Open the file doodlejump-2.s in MARS
3. Set up display:
   - Tools > Bitmap display 
   - Set: 
     - Unit Width in Pixels to 8
     - Unit Height in Pixels to 8
     - Display Width in Pixels to 256
     - Display Height in Pixels to 256
     - Base address for display to 0x10008000 ($gp)
     - Click on Connect to MIPS
4. Set up keyboard:
   - Tools > Keyboard and Display MMIO Simulator
   - Click on Connect to MIPS
5. Run > Assemble
6. Run > Go
7. Input:
   - s to start or restart
   - j to move left
   - k to move right
## Game features
1. Random platform generator
2. Game over/restart 
3. Moving blocks(doodler will die if it jumps on them)
4. Fancy graphics(colorful doodler, moving clouds, etc...)
5. Background music(a music piece of the little star)
6. Scoreboard on the upper-left corner
7. Dynamic on-screen notifications("wow", "nice", "great")when player achieves 5 scores, 10scores, 15scores respectively
## Game pictures
![start](https://user-images.githubusercontent.com/88410617/133480779-954d2f4b-aba8-4f07-be6b-5252d07c22bb.jpg)
![playing](https://user-images.githubusercontent.com/88410617/133480797-fc343b3a-a722-48aa-8aba-972cb14741c7.jpg)
![wow](https://user-images.githubusercontent.com/88410617/133480812-71593717-08ab-49ae-982d-f388972b4940.jpg)
![ending](https://user-images.githubusercontent.com/88410617/133480820-47151bdd-3878-4fca-9fd8-dec348279dc9.jpg)





  
