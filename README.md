> [!NOTE]
> This repository is archived because the lead time until end of the provisioning process is too long (> 4 hours).
> There are also issues with bitlocker decrypting the volume eventual consistencies, reinstalling windows not actually deleting files from the old install and the general SSD wear doing a system reset.  
> We now receive a new computer, and perform a clean install of windows, and manually register (once) Autopilot information using powershell (3 lines of code memorized)

# e-power OOBE

Given a Windows client in OOBE, get ASAP to the desktop!

OOBE = Out of the box -experience, the computer setup after new Windows installation
ASAP = As soon as possible

## Usage

1. Copy the files `e-power.cat` and `e-power.ppkg` to an USB stick
1. Insert the stick into the target computer
1. Observe OOBE starts provisioning the computer as dictated by the PPKG file

## Configuration

### Requirements

1. Install Windows Configuration Designer
    1. https://www.microsoft.com/store/productId/9NBLGGH4TX22
2. Clone this repository

### Configure

Open the folder `src` in the Windows Configuration Designer tool.
