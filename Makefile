lint:
	pod lib lint --allow-warnings

test:
	set -o pipefail && xcodebuild test -workspace Example/HLClock.xcworkspace -scheme HLClock-Example -sdk iphonesimulator9.3 ONLY_ACTIVE_ARCH=NO | xcpretty

travis: lint test
