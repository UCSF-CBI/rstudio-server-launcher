# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# CONDITIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function error {
    local red
    local gray
    local bold
    local reset
    
    ON_ERROR=${ON_ERROR:-on_error}
    TRACEBACK_ON_ERROR=${TRACEBACK_ON_ERROR:-true}
    EXIT_ON_ERROR=${EXIT_ON_ERROR:-true}
    EXIT_VALUE=${EXIT_VALUE:-1}

    ## Parse arguments
    while [ -n "$1" ]; do
        case "$1" in
            --dryrun) EXIT_ON_ERROR=false; shift;;
            --value=*) EXIT_VALUE="${1/--value=/}"; shift;;
            *) break;;
        esac
    done

    if [[ -t 1 ]]; then
        red=$(tput setaf 1)
        gray=$(tput setaf 8)
        bold=$(tput bold)
        reset=$(tput sgr0)
    fi

    msg="${reset}${red}${bold}ERROR:${reset} ${bold}$*${reset}"
    [[ -z ${undo} ]] || msg="${msg//${undo}/${reset}${bold}}"
    echo -e "${msg}"

    if ${TRACEBACK_ON_ERROR}; then
        echo -e "${gray}Traceback:"
        for ((ii = 1; ii < "${#BASH_LINENO[@]}"; ii++ )); do
            printf "%d: %s() on line #%s in %s\\n" "$ii" "${FUNCNAME[$ii]}" "${BASH_LINENO[$((ii-1))]}" "${BASH_SOURCE[$ii]}"
        done
    fi

    if [[ -n "${ON_ERROR}" ]]; then
        if [[ $(type -t "${ON_ERROR}") == "function" ]]; then
            ${ON_ERROR}
        fi
    fi

    ## Exit?
    if ${EXIT_ON_ERROR}; then
        echo -e "Exiting (exit ${EXIT_VALUE})${reset}";
        exit "${EXIT_VALUE}"
    fi

    printf "%s" "${reset}"
}

function warn {
    local bold
    local yellow
    local reset
    
    TRACEBACK_ON_WARN=${TRACEBACK_ON_WARN:-false}
    
    if [[ -t 1 ]]; then
        yellow=$(tput setaf 3)
        bold=$(tput bold)
        reset=$(tput sgr0)
    fi
    
    msg="${reset}${yellow}${bold}WARNING${reset}: $*"
    [[ -z ${undo} ]] || msg="${msg//${undo}/${reset}}"
    echo -e "${msg}"
    
    if ${TRACEBACK_ON_WARN}; then
       echo -e "${gray}Traceback:"
       for ((ii = 1; ii < "${#BASH_LINENO[@]}"; ii++ )); do
           printf "%d: %s() on line #%s in %s\\n" "$ii" "${FUNCNAME[$ii]}" "${BASH_LINENO[$((ii-1))]}" "${BASH_SOURCE[$ii]}"
       done
    fi
    
    printf "%s" "${reset}"
}


function message {
    local bold
    local reset
    local msg
    
    ## Nothing to do?
    ${quiet:-false} && return 0;
       
    if [[ -t 1 ]]; then
        bold=$(tput bold)
        reset=$(tput sgr0)
    fi

    msg="${reset}${bold}$*${reset}"
    [[ -z ${undo} ]] || msg="${msg//${undo}/${reset}${bold}}"
    echo -e "${msg}"
    
    printf "%s" "${reset}"
}


function relay_condition {
    local bfr=${1}
    mdebug "relay_condition() ..."
    for cond in "WARNING" "ERROR"; do
        bfr=$(sed -n "/${cond}:/,\$p" <<< "${1}")
        if grep -q -E "${cond}: " <<< "${bfr}"; then
            # traceback=$(sed -n '/Traceback:/,$p' <<< "${bfr}")
	    
	    ## Drop traceback
            bfr=$(sed '/Traceback:/,$d' <<< "${bfr}")
	    
	    [[ ${cond} == "WARNING" ]] && warn  "${bfr#WARNING: }"
	    [[ ${cond} == "ERROR"   ]] && error "${bfr#ERROR: }"
	fi
    done
    mdebug "relay_condition() ... done"
}


function prune_debug {
    printf "%s\n" "$@" | sed '/DEBUG:/d' | sed 's/\x1b\[[0-9;]*m\x0f//g' | sed -E 's/\x1b(\[[0-9;]*m|\(B)//g'
}
