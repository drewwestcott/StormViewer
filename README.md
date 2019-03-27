# StormViewer
100 Days of Swift Day 49 Challenge

## Challenge
Using UserDefaults to store a count of the number of times an image is viewed.

***Assumption***
Upon App first launch the images will be read in from the bundle and stored in an array as an Image model which holds the name of the file/image and a counter. Future launches will load in this array from UserDefaults so that the count can be maintained.

## Outcome
Realised that each launch would also need to check if the same images were in the bundle and deal with any additional or deleted images to ensure the App would not crash by relying on data stored in UserDefaults
