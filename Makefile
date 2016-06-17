lint:
	pod lib lint

test:
	set -o pipefail && xcodebuild test -workspace Example/HLClock.xcworkspace -scheme HLClock-Example -sdk iphonesimulator9.3 ONLY_ACTIVE_ARCH=NO | xcpretty

travis: lint test
