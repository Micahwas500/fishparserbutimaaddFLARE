#!/usr/bin/env fish

function _print_help
    echo '
Usage: csv2json [OPTIONS] [FILE ...]
I hope this works well! Thanks to hackclub for helping me learn FISH!

Options:
    -h, --help
        Print this help'
end
# checks flags via argparse, sets flag as fail if no flag, if help is set then print help message!
# i think i understand it now 🤓
function csv2json
    argparse h/help -- $argv
    or set -f failure true # set a failure flag, but otherwise fail silently.

    # check if we've failed
    if set -q failure
        _print_help
        return 1
    end

    # check if the user requested help 
    # im commenting this so i can understand the code!
    if set -q _flag_h
        _print_help
        return 0
    end
    # leaves all BUT the files path thankfully tank you club de hakor!
    set files $argv
    
    # reads line whilst echoing!

    # loops!
    # checks line count now (sets lines and r)
    for file in $files
        set lines (string trim (string split '\n' < $file))
        for line in $lines
            echo $line
        end
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