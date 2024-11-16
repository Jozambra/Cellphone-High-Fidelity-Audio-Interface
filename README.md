This application is a port of the XMOS USB Audio software initially intended for the XUF216 family.

The port is intended for the custom hardware design detailed in the Hardware branch of this repository; it corresponds to a USB docking station based around the TPS25832QWRHBRQ1 USB-C PD controller chip
and the XUF208-256-TQ64-C10 uC acting as a USB to I2S bridge.

The audiohw.xc file must be changed in accordance to the specific requirements of the DAC being used; the Cirrus Logic WM8524CGEDT_R can be configure using simple GPIO lines. For a detailed description
of the I2C configurations please refer to the references below:

REFERENCES:

AN01027: Porting the XMOS USB 2.0 Audio Reference Software onto XU208 custom hardware
https://www.xmos.com/download/AN01027:-Porting-the-XMOS-USB-2_0-Audio-Reference-Software-onto-XU208-custom-hardware(1_0_0rc1).pdf

USB Audio SW:
https://www.xmos.com/develop/usb-multichannel-audio/

XTC tools guide:
https://www.xmos.com/documentation/XM-014363-PC/html/intro/index.html

