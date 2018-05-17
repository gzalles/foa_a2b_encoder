# FOA A2B Encoder
GUI in Matlab for encoding soundfield recordings

# Why
Allows you to encode the soundfield outside a DAW. B-format files can then be used in Unity, WebAudio experiences or 360Videos with 3D sound. No more worrying about routing signals inside your DAW. 

If you have Octave I believe the script without the GUI will still work. (todo)

# Reference image
![ambeo](img/ambeo.jpg)

# Issues
* No equalization filters implemented yet.
* Error check for 4 track import failed, was commented out.
* Error occurs when closing import window before loading file
* Normalization global/local not updated. 

# ordering
* ACN = [W Y Z X]
* FuMa = [W X Y Z]

# Refs
* http://pcfarina.eng.unipr.it/Public/B-format/A2B-conversion/A2B.htm
* https://cycling74.com/forums/ambisonics-methods-for-encoding-a-format-to-b-format
* https://ccrma.stanford.edu/software/openmixer/manual/ambisonics_mode
* others
