MAIN_FILE = src/Main.elm
OUTPUT_FILE = src/elm.js
BINARY = ./bin/elm

.PHONY: production

production:
	rm -rf elm-stuff && $(BINARY) make --output=$(OUTPUT_FILE) --optimize $(MAIN_FILE)

debug:
	rm -rf elm-stuff && $(BINARY) make --output=$(OUTPUT_FILE) --debug $(MAIN_FILE)

dev:
	rm -rf elm-stuff && $(BINARY) make --output=$(OUTPUT_FILE) $(MAIN_FILE)
  
