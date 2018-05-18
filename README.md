# First Order Ambisonics A-to-B Encoder
Graphical User Interface (GUI) in Matlab for encoding soundfield recordings taken with tetrahedral arrays.

# Why?
Allows you to encode the soundfield outside a DAW. B-format files can then be used in Unity, WebAudio experiences or 360Videos with 3D sound. If you have Octave I believe the script (A2B_encoder.m) without the GUI will still work.

We find this is easier than routing channels in Reaper or Nuendo.

# Ordering and Normalization
* ACN = [W Y Z X] + SN3D Normalization
* FuMa = [W X Y Z] + MaxN Normalization

# Upgrades
* Implement equalization filters (Gerzon)
* Make error check for case = can't upload mono once 4-track is uploaded.
* Cannot upload multi-track if mono is uploaded.
* Clear all resets filename default.

# Refs
* http://pcfarina.eng.unipr.it/Public/B-format/A2B-conversion/A2B.htm
* https://cycling74.com/forums/ambisonics-methods-for-encoding-a-format-to-b-format
* https://ccrma.stanford.edu/software/openmixer/manual/ambisonics_mode
