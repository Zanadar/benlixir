# Benlixir

This module decodes [bencode](https://en.wikipedia.org/wiki/Bencode). Its designed to be used as part of a bittorrent client or library of some sort. 

## What I learned
I had implemented something similair to this in `Go`, which was relatively straightforward. In `Elixir`, all looping has to be done through recursion, and so this was a fun exercise in that topic. I built it using TDD. 

Essentially, the main entry point of the code is `Benlixir.Decoder.decode("becodede string")`.  This function kicks off a recusive loop which nibbles away at our input string and passes along a main `map`. This master data structure is slowly filled in by a number of subfunctions and recursive calls. Pattern matching makes this really nice, as our remaining string is properly dispatched to specific type decoding functions for `int`, `map`, `list`, and `string` based on the patterns of the string. Pattern matching also simplifies the recursion of the subfunctions by matching on, for example `"e"<>rest` to terminate a map represented in the bencode string.

## To be done
- Implement decoding, including for `.torrent` files
- Experiment with HiPE compilation
- Package for Hex, including docs
