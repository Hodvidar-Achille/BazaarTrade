#!/bin/bash
# wait-for-it.sh
echo "Running wait-for-it.sh..."

TIMEOUT=${TIMEOUT:-15}
QUIET=${QUIET:-0}

echoerr() {
  if [[ $QUIET -ne 1 ]]; then printf "%s\n" "$*" 1>&2; fi
}

usage() {
    exitcode="$1"
    echoerr "Usage: $0 host:port [-s] [-t timeout] [-- command args]"
    echoerr "    -h HOST | --host=HOST       Host or IP under test"
    echoerr "    -p PORT | --port=PORT       TCP port under test"
    echoerr "                                Alternatively, you specify the host and port as host:port"
    echoerr "    -s | --strict               Only execute subcommand if the test succeeds"
    echoerr "    -q | --quiet                Don't output any status messages"
    echoerr "    -t TIMEOUT | --timeout=TIMEOUT"
    echoerr "                                Timeout in seconds, zero for no timeout"
    echoerr "    -- COMMAND ARGS             Execute command with args after the test finishes"
    exit "$exitcode"
}

wait_for() {
    if [[ $TIMEOUT -gt 0 ]]; then
        echoerr "$host:$port - waiting $TIMEOUT seconds"
    else
        echoerr "$host:$port - waiting without a timeout"
    fi
    start_ts=$(date +%s)
    while :
    do
        (echo -n > /dev/tcp/$host/$port) >/dev/null 2>&1
        result=$?
        if [[ $result -eq 0 ]]; then
            end_ts=$(date +%s)
            echoerr "$host:$port is available after $((end_ts - start_ts)) seconds"
            break
        fi
        sleep 1
    done
    return $result
}

wait_for_wrapper() {
    # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
    if [[ $QUIET -eq 1 ]]; then
        timeout $BUSYTIMEOUT $0 --quiet --timeout=$TIMEOUT $* &
        PID=$!
        trap "kill -INT -$PID" INT
        wait $PID
        EXIT_STATUS=$?
        trap - INT
        return $EXIT_STATUS
    else
        if [[ $TIMEOUT -gt 0 ]]; then
            timeout $TIMEOUT $0 --quiet --timeout=$TIMEOUT $* &
            PID=$!
            trap "kill -INT -$PID" INT
            wait $PID
            EXIT_STATUS=$?
            trap - INT
            return $EXIT_STATUS
        else
            $0 --quiet --timeout=$TIMEOUT $*
            EXIT_STATUS=$?
            return $EXIT_STATUS
        fi
    fi
}

# process arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        *:* )
        host=$(printf "%s\n" "$1"| cut -d : -f 1)
        port=$(printf "%s\n" "$1"| cut -d : -f 2)
        shift 1
        ;;
        -q | --quiet)
        QUIET=1
        shift 1
        ;;
        -s | --strict)
        STRICT=1
        shift 1
        ;;
        -h)
        HOST="$2"
        if [[ $HOST == "" ]]; then break; fi
        shift 2
        ;;
        --host=*)
        HOST="${1#*=}"
        shift 1
        ;;
        -p)
        PORT="$2"
        if [[ $PORT == "" ]]; then break; fi
        shift 2
        ;;
        --port=*)
        PORT="${1#*=}"
        shift 1
        ;;
        -t)
        TIMEOUT="$2"
        if [[ $TIMEOUT == "" ]]; then break; fi
        shift 2
        ;;
        --timeout=*)
        TIMEOUT="${1#*=}"
        shift 1
        ;;
        --)
        shift
        CLI="$*"
        break
        ;;
        --help)
        usage 0
        ;;
        *)
        echoerr "Unknown argument: $1"
        usage 1
        ;;
    esac
done

if [[ "$HOST" == "" || "$PORT" == "" ]]; then
    echoerr "Error: you need to provide a host and port to test."
    usage 2
fi

wait_for "$@"

RESULT=$?
echo "Ending wait-for-it.sh..."
if [[ $CLI != "" ]]; then
    if [[ $RESULT -ne 0 && $STRICT -eq 1 ]]; then
        echoerr "$host:$port - strict mode, refusing to execute subprocess"
        exit $RESULT
    fi
    exec $CLI
else
    exit $RESULT
fi
