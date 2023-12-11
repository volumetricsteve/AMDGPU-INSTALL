# AMDGPU-INSTALL
This unwraps and installs the amdgpu driver for non-debian linux distros
12/11/2023
AMD-APPSDK 3.0 (3.0.130.136-Final)
AMD-Catalyst 15.11 (A version I found that might be final for its series)

We've launched into the future, it's 2023.  I've been... a little busy.

I want to bring the machine back to life.  After doing some digging, I found that the R9 Nano is still supported, sort of, by the latest AMD driver, but it looks like ROCm sort of absorbed OpenCL responsibilities, and -those- aren't really supported on the R9 Nano...or something.
Anyway, it's a mess and probably not worth the trouble.  I worry that I'm going to run into kernel compatibility issues as so much time has passed with the Older AMD Catalyst/APP SDK combo.  It looks like to enable OpenCL 2.0, the "Omega" driver is needed as well.

AMD looks to have done a truly remarkable job of scrubbing the internet of older versions of Catalyst, but I was able to get google to cough up a link that led to a part of their site you can't get to otherwise... not unlike basicially every other part of their site.

I did manage to find Catalyst 15.11, it's "Crimson" instead of "Omega" but maybe it'll work.  Maybe OpenCL 2.0 matters, maybe it doesn't.  We'll see.

I'll throw these downloads up on this github.  If this all works together, I can finally carve all this up into a custom driver for my system that might be useful for others with older AMD cards that also want OpenCL, graphics, on what I assume will be a very specific range of kernel versions and also want a non-RHEL/SuSe/Ubuntu package.

So if exactly these 4-ish things matter to you A LOT:

OpenCL 2.0
Graphics  (maybe vulkan?  maybe opengl?)
On a yet to be determined Kernel Version (maybe 5.x, maybe 6.x?)
non-RHEL/SuSe/Ubuntu package

Then stay tuned, I guess.
