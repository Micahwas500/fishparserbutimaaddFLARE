#!/usr/bin/env fish

function _print_help
    echo '
Usage: csv2json [OPTIONS] [FILE ...]
I hope this works well! Thanks to hackclub for helping me learn FISH!

Options:
    -h, --help
        Print this help message for you! 
    -u --url
        Makes it a url! *Mutually exclusive with Files!*'
end
# take a wild guess :)
function _process_urls! -a url
    set values (curl url )
#process line runs to remove the , and split it. It then prints the jsonness. Let me cook from here please (this can and, probably, WILL suck :p )
function _process_line -a line col_count
    set header $argv[3..]
    set values (string split ',' $line)
    for index in (seq 1 (math $col_count - 1))
        set col $header[$index]
        set value $values[$index]
        printf '    "%s": "%s",\n' $col $value # <- Note indent level 2
    end
    printf '    "%s": "%s"\n' $header[$col_count] $values[$col_count]
end
# nvm idk what to do from here :( sorry
# will use the code as template and add more onto it
function _process_file -a file
    # Split the file by newlines to get an list of lines, then store it in the
    # variable `$lines`.
    set lines (string trim (string split '\n' < $file))

    # Our header is the first line
    set header (string split ',' $lines[1])
    # We use this later with `seq` to index into `header`
    set col_count (count $header)

    # We need to skip line 1, since that's the header. We also need to skip the
    # last line, since it can't have a trailing comma.
    for line in $lines[2..-2]
        echo "  {" # <- Each line is a JSON object, with 1 level indent
        _process_line $line $col_count $header
        echo "  },"
    end

    echo "  {"
    _process_line $lines[-1] $col_count $header # Last line
    echo "  }"
end
# prints header!
function _print_header -a filename
    printf "<== %s ==>\n" $filename
end

# checks flags via argparse, sets flag as fail if no flag, if help is set then print help message!
# i think i understand it now 🤓> nvm lol, ts is hard

function csv2json
    argparse h/help -- $argv
    or set -f failure true # set a failure flag, but otherwise fail silently.

    # check if we've failed
    if set -q failure
        _print_help
        return 1
    end

    # check if the user requested help
    if set -q _flag_h
        _print_help
        return 0
    end

    # as argparse goes through $argv, it removes all the options but leaves
    # arguments behind, which are our files.
    set files $argv

    for file in $files # <- do this for every file we get on the command line
        # If we have more than 1 file, we need to print headers
        if test (count $files) -gt 1
            _print_header $file
        end

        echo "[" # <- Each CSV is a list of JSON objects

        _process_file $file

        echo "]"
    end

    return 0
end
csv2json $argv
    # reference!
# if CONDITION; COMMANDS_TRUE ...;
# [else if CONDITION2; COMMANDS_TRUE2 ...;]
# [else; COMMANDS_FALSE ...;]
# end
    # ref 2
# echo "How old are you?"

# Note: `-p ''` suppresses the default prompt that `read` uses.
# read -p '' age

# echo "Your're $age years old!"