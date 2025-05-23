# Weekly Scripting Challenge

I started this repository after losing motivation on a Qt project. While working with Qt, I realized I wasn’t learning as much as I wanted, so I decided to shift my focus. 
Instead of tackling another large project, I committed to writing a new script each week to become more fluent with my operating system (macOS) and improve how I interact with it through automation and scripting.

Over time, I adapted some of these scripts into SwiftBar plugins, allowing me to integrate them directly into the macOS menu bar for quick access.
I also use crontab to automate certain scripts, running them on a schedule without manual execution.

## Structure
	•	scripts/ – Standalone scripts written weekly
	•	swiftbar-plugins/ – Adapted versions of scripts for SwiftBar

## Goals
	•	Become more fluent with macOS through scripting
	•	Improve automation and system interaction skills
	•	Build a useful set of tools for daily workflow

## Usage

Most scripts are standalone and should run on macOS without additional dependencies. 
SwiftBar plugins should be placed in the appropriate directory (~/Library/Application Support/SwiftBar/Plugins) and made executable (chmod +x script.sh).

## Future Plans
	•	Expand beyond macOS-specific scripts
	•	Explore different scripting languages for variety
	•	Continue refining existing scripts into more polished tools

## AI Support
  I've used claude.ai to assist with learning and commentation/documentation, as well as automating boring and repetitive tasks.

## Lessions Learned
	•	Learned about creating, saving, and pulling data from json files
	•	Learned about how macOS stores data usage
	•	Learned ALOT about bash.

 ## Examples

### Network tracker as a Swiftbar addon
<img width="327" alt="Screenshot 2025-03-21 at 20 57 55" src="https://github.com/user-attachments/assets/72a35ab8-92d3-429f-9c43-62038f5589d8" />

## Known Issues
If both the internet usage script and internet usage plugin save to the same log file, something breaks and usage is no longer logged.
When Swiftbar is started without an internet connection, the Internet Usage Tracker refers to the backup log instead of the main one.
