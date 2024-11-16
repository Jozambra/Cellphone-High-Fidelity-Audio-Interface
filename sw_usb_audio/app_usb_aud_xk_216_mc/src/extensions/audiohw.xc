
#include <xs1.h>
#include <assert.h>
#include <platform.h>
#include "xua.h"
#include "app_usb_aud_xk_216_mc.h"
#include "gpio_access.h"
#include "i2c.h"
#include "cs4384.h"
#include "cs5368.h"
#include "../../shared/cs2100.h"
#include "dsd_support.h"


//Port Definition

port p_F22_5MHz = XS1_PORT_1D; 
port p_F24_5MHz = XS1_PORT_4D; //treat as bit 2 0b0010
port p_DAC_MUTE = XS1_PORT_4C; //treat as bit 3 0b0100 red led on bit 2 0b001
port p_BLUE_LED = XS1_PORT_1L; 
port p_GRN_LED = XS1_PORT_1A; 

int temp;

void wait_us(int microseconds)
{
    timer t;
    unsigned time;
    t :> time;
    t when timerafter(time + (microseconds * 100)) :> void;
}

void AudioHwInit()
{
    //Put DAC in standby
    p_DAC_MUTE :> temp;
    p_DAC_MUTE <: temp & 0b1011; 

    //Select 24.5 MHz clock
    p_F22_5MHz <: 0; 

    p_F24_5MHz :> temp;
    p_F24_5MHz <: temp | 0b0010;
    
    wait_us(1000); //Wait for clock to stabilize

    // Set DAC to Operational Mode
    p_DAC_MUTE :> temp;
    p_DAC_MUTE <: temp | 0b0100; 

    p_BLUE_LED  <: 0;
    p_GRN_LED <: 1;
    p_DAC_MUTE :> temp;
    p_DAC_MUTE <: temp & 0b1101;

}

/* Configures the external audio hardware for the required sample frequency.*/
void AudioHwConfig(unsigned samFreq, unsigned mClk, unsigned dsdMode, unsigned sampRes_DAC, unsigned sampRes_ADC)
{
     //Put the  DAC in standby

    p_DAC_MUTE :> temp;
    p_DAC_MUTE <: temp & 0b1011; 

    //Select clock source accoring to samplingF of input

    if ((samFreq % 44100) == 0)
    {
        //select 22.5 MHz clock
        p_F24_5MHz :> temp;
        p_F24_5MHz <: temp & 0b1101;
        wait_us(1000);
        p_F22_5MHz <: 1;

        //Indicate sampling F with LEDs
        p_GRN_LED <: 0;
        p_BLUE_LED  <: 1;
        p_DAC_MUTE :> temp;
        p_DAC_MUTE <: temp & 0b1101;

    }
    else
    {
        //select 24.5 MHz clock
        p_F22_5MHz <: 0; 
        wait_us(1000);
        p_F24_5MHz :> temp;
        p_F24_5MHz <: temp | 0b0010;

        //Indicate sampling F with LEDs
        p_BLUE_LED  <: 0;
        p_GRN_LED <: 1;
        p_DAC_MUTE :> temp;
        p_DAC_MUTE <: temp & 0b1101;
    }

    /* Allow MCLK to settle and restart dac*/
    wait_us(10000);
    p_DAC_MUTE :> temp;
    p_DAC_MUTE <: temp | 0b0100; 

}