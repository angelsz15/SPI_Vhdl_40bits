# SPI_Vhdl_40bits

A SPI module is used to send 40-bit frames to control and configure the TMC5130A stepper motor power driver.

The main purpose of this VHDL component is to translate a 40-bit frame into the SPI protocol.

The 'SPI_5_CS' component can control 5 drivers on the same SPI bus. This is achieved through a multiplexer that selects the correct CS using the 'cs_multiplex_selector' port (3 bits).

![Captura de pantalla 2024-04-25 102229](https://github.com/angelsz15/SPI_Vhdl_40bits/assets/167806623/fd31e6ce-a98a-4c4b-8dce-9bb7cddbdf3e)
