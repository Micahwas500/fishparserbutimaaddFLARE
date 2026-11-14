#!/usr/bin/env fish

function _print_help
    echo 'Usage: csv2json [OPTIONS] [FILE ...]

Options:
    -h, --help
        Print this help'
end
# i am so smart
function _get_url
	echo what link do you have? 
    read -l templink
        echo "your link is $templink"
        set -a -g link $templink
        echo 'do you want another link? (true/false)'
        read -l repeatlink
        if test "$repeatlink" = "true"
            _get_url
            end
    end
# this gets files/filenames and appends them!
function _fetch_filesyay
    # Split the line with seperator ',', and loop over each value in the line
    for url in $link
        echo "downloading $url"
        set counter (math $counter + 1)
        set -l filename "downloadedfile_$counter.csv"
        curl -L -o "$filename" "$url"
        set -a -g files "$filename"
    end
end
# _process_line gets $line as an argument
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
    argparse h/help u/url -- $argv
    or set -f failure true # set a failure flag, but otherwise fail silently.

    # check if we've failed
    if set -q failure
        _print_help
        return 1
    end
    if set -q _flag_u
        _get_url
        set -g counter 0
        _fetch_filesyay
        end
    # check if the user requested help
    if set -q _flag_h
        _print_help
        return 0
    end

    # as argparse goes through $argv, it removes all the options but leaves
    # arguments behind, which are our files.
    set -a files $argv
    for file in $files # <- do this for every file we get on the command line
        _process_file $file
    end

    return 0
end


testfile $argv