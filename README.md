![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# Tiny Tapeout Verilog Project: Digital Temperature Monitor

This is an educational project for undergraduate engineering students with the objective of exposing them to real-world product design. In the process, the students learn a wide variety of engineering principles including product design, digital system design, mixed-signal modeling, digital design using Verilog, design verification, ASIC design flow, FPGA design flow, and documentation using gitHub.

This project implements a digital temperature monitor by connecting a temperature sensor ([LM70](docs/datasheet-LM70-TI-tempSensor.pdf) [`docs/datasheet-LM70-TI-tempSensor.pdf`]) and a three-segment display to measure and display a range of $0-99^\circ C$ or $0-99^\circ F$ with an accuracy of $\pm 2^\circ C$.

![Block diagram of the complete system.](docs/tt06-blockdiag.png)

## Project Description

- [Read the documentation for project](docs/info.md)


## Acknowledgement 

Thanks to [Prinyasu Sahoo](https://github.com/Priyansu122) for the [Tiny Tapeout](https://tinytapeout.com/) conversion of this project, [Silicon University](https://www.silicon.ac.in) for financial and infrastructure support, and previous students for their efforts to bring this project to a tapeout state.

# What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.


## Verilog Projects

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Optionally, add a testbench to the `test` folder. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://docs.google.com/document/d/1aUUZ1jthRpg4QURIIyzlOaPWlmQzr-jBn3wZipVUPt4)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Edit [this README](README.md) and explain your design, how it works, and how to test it.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@matthewvenn](https://twitter.com/matthewvenn)

# Helpful Info
- [Discord link clarifying I/O](https://discordapp.com/channels/1009193568256135208/1212524847708774460)
- ena pin is an option for user to use, not mandotary. [See doscord link](https://discordapp.com/channels/1009193568256135208/1212524847708774460)
- Don't need `wokiid`, just follow the `tt-06 template`
- PCB clock speed (6Hz - 66MHz) [See clock specs here](https://tinytapeout.com/specs/clock/)
- Shipping to India is fine.
- Boards are tested for functionality before shipping.

# Resources
- [Payment App](https://app.tinytapeout.com/prepurchase) [ [Discord Ref](https://discordapp.com/channels/1009193568256135208/1009193568256135211/1222255345230151841) ]
- [How to locally harden (rtl2gds) your design](https://docs.google.com/document/d/1aUUZ1jthRpg4QURIIyzlOaPWlmQzr-jBn3wZipVUPt4/edit#heading=h.wwc5ldl01nl5)
- [A good reference for doc](https://github.com/scorbetta/tt06-scorbetta-goa/blob/main/docs/info.md)

# Tasks

