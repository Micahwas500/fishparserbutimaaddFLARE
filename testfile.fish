#!/usr/bin/env fish

function _print_help
    echo 'Usage: csv2json [OPTIONS] [FILE ...]

Options:
    -h, --help
        Print this help'
end
function _get_file
	for value in (string split ',' $line)
		echo " \
		{}
		" | \
		curl \
		--request POST "$url" \"
	end
end
# _process_line gets $line as an argument
function _process_line -a url
    # Split the line with seperator ',', and loop over each value in the line
    for url in (string split ',' $fullurls)
        echo $url
    end
end

function _process_file -a file
    # Split the file by newlines to get an list of lines, then store it in the
    # variable `$lines`.
    # 
    # Note that we also use `string trim` to get rid of trailing whitespace.
    set lines (string trim (string split '\n' < $file)) 

    for line in $lines # We can iterate through our list of lines
        _process_line $line
    end
end

function testfile
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
        _process_file $file
    end

    return 0
end


testfile $argv