# browser-testing-tools
[![Hippocratic License HL3-FULL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-FULL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/full.html)

Working on some basic tools that can be used to stress test your browser.
## basic-tab-opener.html
This simple embedded JS script opens many tabs quickly. This can cause your computer's memory to run out and possibly slow your computer down or cause crashes. Please dont run it unless you are prepared for that.
## autoplay-block-test.html
A simple HTML that plays a sound when it opens.
## autoplay-block-test.html
A copy of autoplay-block-test.html but it waits to simulate user input and therefore on older browsers bypasses autoplay restrictions.

## run-all-tests.sh
**WIP**

Oneline install

``` bash
curl https://raw.githubusercontent.com/DJTheron/browser-testing-tools/refs/heads/main/run-all-tests.sh | bash
```
when completed all you need to do is run it and it will run all the programs and give you feedback on the test results. I am in the process of learning playwright so hopefully then it will be complete.