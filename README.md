# SPI_Vhdl_40bits

A SPI module is used to send 40-bit frames to control and configure the TMC5130A stepper motor power driver.

The main purpose of this VHDL component is to translate a 40-bit frame into the SPI protocol.

The 'SPI_5_CS' component can control 5 drivers on the same SPI bus. This is achieved through a multiplexer that selects the correct CS using the 'cs_multiplex_selector' port (3 bits).

![Captura de pantalla 2024-04-25 102229](https://github.com/angelsz15/SPI_Vhdl_40bits/assets/167806623/fd31e6ce-a98a-4c4b-8dce-9bb7cddbdf3e)

Before continuing to discuss the flags that characterize the component, we will define what the sending cycle is. A sending cycle is completed when the SPI sends the same 40-bit frame twice. It is sent twice so that the slave can confirm the frame and respond in the next CS cycle.

Between sending (1st Frame) and confirmation (2nd Frame), the CLK and CS signals remain at the logical 'HIGH' level for an arbitrary period of time.
