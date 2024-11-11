pwd=${BASH_SOURCE%/*}

# shellcheck source=incl/asserts.sh
source "${pwd}"/asserts.sh

function change_dir {
    local opwd
    opwd=${PWD}
    assert_dir_exists "$1"
    cd "$1" || error "Failed to set working directory to $1"
    mdebug "New working directory: '$1' (was '${opwd}')"
}

function make_dir {
    mkdir -p "$1" || error "Failed to create new working directory $1"
}

function remove_dir {
    rm -rf "$1" || error "Failed to remove directory $1"
}

function equal_dirs {
    local a
    local b
    a=$(readlink -f "$1")
    b=$(readlink -f "$2")
    [[ "${a}" == "${b}" ]]
}

function wait_for_file {
    local file
    local maxseconds
    local delay
    
    file=${1:?}
    maxseconds=${2:-300}
    delay=${3:-1.0}
    
    t0=${SECONDS}
    until [[ -f "${file}" && $((SECONDS - t0)) -lt "${maxseconds}" ]]; do
        sleep "${delay}"
    done
    [[ -f "${file}" ]] || error "Waited for file ${file}, but gave up after ${maxseconds} seconds"
}

function file_info {
    local file=${1:?}
    local -i size
    local timestamp
    local now
    local age
    
    if [[ -f "${file}" ]]; then
        size=$(stat --format="%s" "${file}")
        timestamp=$(stat --format="%Y" "${file}")
        now=$(date "+%s")
        age=$(( (now - timestamp) / 3600 ))
        if [[ ${age} -lt 48 ]]; then
            age="${age} hours ago"
        else
            age="$((age / 24)) days ago"
        fi    
        timestamp=$(date -d "@${timestamp}" "+%F %T")
        echo "${size} bytes; ${timestamp} (${age})"
    else
        echo "<not available>"
    fi
}

function dir_info {
    local dir=${1:?}
    local -i size
    local timestamp
    local now
    local age
    
    if [[ -d "${dir}" ]]; then
        size=$(du --summarize --bytes "${dir}" | cut -f 1)
        timestamp=$(stat --format="%Y" "${dir}")
        now=$(date "+%s")
        age=$((now - timestamp))
        age=$((age / 60))
        if [[ ${age} -lt 120 ]]; then
            age="${age} minutes ago"
        else
            age=$((age / 60))
            if [[ ${age} -lt 48 ]]; then
                age="${age} hours ago"
            else
                age=$((age / 24))
                age="${age} days ago"
            fi
        fi    
        timestamp=$(date -d "@${timestamp}" "+%F %T")
        echo "${size} bytes; ${timestamp} (${age})"
    else
        echo "<not available>"
    fi
}
