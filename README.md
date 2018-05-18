# First Order Ambisonics A-to-B Encoder
Graphical User Interface (GUI) in Matlab for encoding soundfield recordings taken with tetrahedral arrays.

# Why?
Allows you to encode the soundfield outside a DAW. B-format files can then be used in Unity, WebAudio experiences or 360Videos with 3D sound. If you have Octave I believe the script without the GUI will still work. (todo) We found this easier than routing channels in a Reaper or Nuendo.

# Issues
* No equalization filters implemented yet?
* Error check for 4 track import failed, was commented out.
* error occurs when closing import window before loading file
* normalization uncertainty

# ordering
* ACN = [W Y Z X]
* FuMa = [W X Y Z]

# refs
* http://pcfarina.eng.unipr.it/Public/B-format/A2B-conversion/A2B.htm
* https://cycling74.com/forums/ambisonics-methods-for-encoding-a-format-to-b-format
* https://ccrma.stanford.edu/software/openmixer/manual/ambisonics_mode
* others
