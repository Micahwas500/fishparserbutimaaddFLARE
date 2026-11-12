#!/usr/bin/env fish

function _print_help
    echo "Usage: csv2json [OPTIONS] [FILE ...]"
options:
    -h, --help
        'HEY ITS ME ITS AMAZITY'
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
csv2json $argv
# reference!
# if CONDITION; COMMANDS_TRUE ...;
# [else if CONDITION2; COMMANDS_TRUE2 ...;]
# [else; COMMANDS_FALSE ...;]
# end