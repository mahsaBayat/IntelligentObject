# Intelligent Object

## Overview

The key aim of this project is to apply multimedia data processing and analysis techniques to a real world example. Given a video of an object with labelled markers, it was required to capture the objects’ movements, add externals objects and animations as well as interactivity between them.


## Languages

*	Processing
* Java

## Example Scenes from the Input Video

![Example scenes of the input video.](https://github.com/mahsaBayat/IntelligentObject/blob/master/InputVideo.png)

## Example Scenes from the Output Video
<p align="center">
  <img src="https://github.com/mahsaBayat/IntelligentObject/blob/master/rsz_121.png" alt="Example scenes of the output video."/>
  <img src="https://github.com/mahsaBayat/IntelligentObject/blob/master/rsz_2.png" alt="Example scenes of the output video." />
  <img src="https://github.com/mahsaBayat/IntelligentObject/blob/master/rsz_3.png" alt="Example scenes of the output video." />
</p>

## Implementation
<strong>Motion Capture</strong>
<p align="justify">
To segment motions of the monkey, all the red pixels of the monkey frames were stored in one array list. The red pixels were distinguished by their red value being greater than 160 and their green value being less than 140. In each frame, this array list was then passed to a function that calculates the average of all the pixels and returns the center of them. The center coordinates are essentially the monkey’ chest coordinates.
The center coordinates and the red pixelsárray list, were then passed to a function which categorizes the red pixels into left arm, right arm, left leg and right leg. This function iterates through all the extracted red pixels. Using the chest coordinates and the four corners of the monkey frames, red pixels are divided into quadrants and are added into their corresponding array list. Finally, the center of all four lists of red pixels are calculated.
This algorithm, eventually creates 5 clusters with the coordinates of the corresponding red pixels, one for each red section in the monkey frame.
</p>

<strong>Replace Background and Marionette</strong>
<p align="justify">
Both the background and the monkey video were loaded as Movie objects to save their frames first. Once the frames were stored, they were loaded as PImage objects. In order not to exceed the length of the initial monkey movie, the background frames were drawn only if the frame counter was less than 953, which was the total number of frames for the monkey video.
Using five clusters that were created in the segmentation section, a cat image was drawn to replace the previous monkey object. The replacement images were drawn using particular offsets.
</p>

<strong>Intelligent Objects and Sound Tracks</strong>
<p align="justify">

###### Mice:
One group of intelligent objects are the mice. These objects are generated on mouse click and have random directions. If they collide with the main object, they will be destroyed and an image indicating a scratch mark will be loaded and a cat sound will be played on the spot. The collision detection algorithm will consider an imaginary triangular boundary around the main cat object. If the top left pixel of the mouse objects falls into this boundary, then a collision will be detected.

###### Balloons:
The other group of intelligent objects being used are the balloons that are generated if a key is pressed. The coordinates of these objects are based on the chest values of the main cat object with particular offsets to make them appear on each side of the cat. Since the chest values are used, the movement pattern of the balloons is exactly like the cat.

###### Score:
Each time a mouse collides with the cat object, the score will dynamically be incremented by one. The score is displayed on an image loaded from the sketch path.

###### Lucky Coins:
For the number of scores, one lucky coin will be drawn on the screen and a soundtrack of a coin dropping will be played. Each of the coins are 50 pixels apart from each other.
</p>



