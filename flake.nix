{
    inputs = { } ;
    outputs =
        { self } @module :
            {
                lib =
                    {
                        input ? null ,
                        output ? null
                    } :
                        let
                            implementation =
                                { config , lib , pkgs , ... } :
                                    let
                                        identified =
                                            if builtins.typeOf input == "lambda" then input module
                                            else if builtins.typeOf input == "null" then module
                                            else builtins.throw "9496508508186608" ;
                                        in
                                            with identified ;
                                                {
                                                    options =
                                                        {
                                                            promoter =
                                                                {
                                                                    default =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "action" ;
                                                                                runtimeInputs =
                                                                                    [
                                                                                        pkgs.coreutils
                                                                                        (
                                                                                            config.lazy-shell-application
                                                                                                {
                                                                                                    mounts =
                                                                                                        {
                                                                                                            list = { is-directory = false ; source = "/tmp/promoter.txt" ; type = "bind" ; } ;
                                                                                                            lock = { is-directory = false ; source = "/tmp/promoter.lock" ; type = "bind" ; } ;
                                                                                                        } ;
                                                                                                    name = "queue" ;
                                                                                                    post =
                                                                                                        [
                                                                                                            (
                                                                                                                let
                                                                                                                    application =
                                                                                                                        config.lazy-shell-application
                                                                                                                            {
                                                                                                                                mounts =
                                                                                                                                    {
                                                                                                                                        list = { is-directory = false ; source = "/tmp/promoter.txt" ; type = "bind" ; } ;
                                                                                                                                        lock = { is-directory = false ; source = "/tmp/promoter.lock" ; type = "bind" ; } ;
                                                                                                                                        temporary = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                    } ;
                                                                                                                                name = "process-candidate" ;
                                                                                                                                post = [ ] ;
                                                                                                                                runtime-inputs =
                                                                                                                                    { pkgs , ... } :
                                                                                                                                        [
                                                                                                                                            ( config.failure { } )
                                                                                                                                            pkgs.coreutils
                                                                                                                                            pkgs.flock
                                                                                                                                            (
                                                                                                                                                config.lazy-shell-application
                                                                                                                                                    {
                                                                                                                                                        mounts =
                                                                                                                                                            {
                                                                                                                                                                "log.yaml" = { is-directory = false ; source = "/tmp/promoter.yaml" ; type = "bind" ; } ;
                                                                                                                                                                lock = { is-directory = false ; source = "/tmp/promoter-2.lock" ; type = "bind" ; } ;
                                                                                                                                                            } ;
                                                                                                                                                        name = "process-candidate" ;
                                                                                                                                                        post = [ ] ;
                                                                                                                                                        runtime-inputs =
                                                                                                                                                            { pkgs , ... } :
                                                                                                                                                                let
                                                                                                                                                                    timeout =
                                                                                                                                                                        failure :
                                                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                                                {
                                                                                                                                                                                    name = "extract-timeout" ;
                                                                                                                                                                                    runtimeInputs = [ ] ;
                                                                                                                                                                                    text =
                                                                                                                                                                                        ''
                                                                                                                                                                                            while [[ "$#" -lt 0 ]]
                                                                                                                                                                                            do
                                                                                                                                                                                                case "$1" in
                                                                                                                                                                                                    --identity)
                                                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 9680512020238210 ${ builtins.toString failure } "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        shift 2
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                    --override-input)
                                                                                                                                                                                                        if [[ "$#" -lt 3 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 7635300019148429 ${ builtins.toString failure } "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        shift 3
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                    --timeout)
                                                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 8047149935848509 ${ builtins.toString failure } "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        if [[ -n "$TIMEOUT" ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 7860240520430827 ${ builtins.toString failure } "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        TIMEOUT="$2"
                                                                                                                                                                                                        shift 2
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                    *)
                                                                                                                                                                                                        failure 4335486007730127 ${ builtins.toString failure } "$@"
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                esac
                                                                                                                                                                                            done
                                                                                                                                                                                            if [[ -z "$FAILURE" ]]
                                                                                                                                                                                            then
                                                                                                                                                                                                echo -n 86400
                                                                                                                                                                                            else
                                                                                                                                                                                                echo -n "$TIMEOUT"
                                                                                                                                                                                            fi
                                                                                                                                                                                        '' ;
                                                                                                                                                                                } ;
                                                                                                                                                                    verify-inputs =
                                                                                                                                                                        failure :
                                                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                                                {
                                                                                                                                                                                    name = "verify-inputs" ;
                                                                                                                                                                                    runtimeInputs = [ ( config.failure ) pkgs.awkutils pkgs.coreutils pkgs.git ] ;
                                                                                                                                                                                    text =
                                                                                                                                                                                        ''
                                                                                                                                                                                            declare -A SEEN_INPUTS
                                                                                                                                                                                            while [[ "$#" -gt 0 ]]
                                                                                                                                                                                            do
                                                                                                                                                                                                case "$1" in
                                                                                                                                                                                                    --identity)
                                                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 7198974479630792 "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        shift 2
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                    --override-input)
                                                                                                                                                                                                        if [[ "$#" -lt 3 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 8712000318384001 ${ builtins.toString failure } "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        INPUT="$2"
                                                                                                                                                                                                        FLAKE_REF="$3"
                                                                                                                                                                                                        if [[ -v "SEEN_INPUTS[$INPUT]" ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 7616400968225803 ${ builtins.toString failure } "$INPUT" "$FLAKE_REF"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        mkdir --parents "/mounts/work/verify-inputs/${ builtins.toString failure }/$INPUT/$FLAKE_REF"
                                                                                                                                                                                                        cd "/mounts/work/verify-inputs/${ builtins.toString failure }/$INPUT/$FLAKE_REF"
                                                                                                                                                                                                        git init
                                                                                                                                                                                                        FLAKE_URL="$( awk -v input="$INPUT" '$1 == input ".url" { gsub(/[";]/, "", $3) ; print $3 }' ${ ./config/flake.nix } )" || failure ${ builtins.toString failure } 6106787716535623
                                                                                                                                                                                                        case "$FLAKE_URL" in
                                                                                                                                                                                                            github:*)
                                                                                                                                                                                                                FLAKE_SSH_URL="git@github.com:${ "$" }{FLAKE_URL#github:}.git"
                                                                                                                                                                                                                ;;
                                                                                                                                                                                                            *)
                                                                                                                                                                                                                failure 2132629620155012 ${ builtins.toString failure } "$INPUT" "$FLAKE_URL"
                                                                                                                                                                                                                ;;
                                                                                                                                                                                                        esac
                                                                                                                                                                                                        git remote add origin "$FLAKE_SSH_URL"
                                                                                                                                                                                                        git fetch origin main
                                                                                                                                                                                                        git fetch origin "$FLAKE_REF"
                                                                                                                                                                                                        if ! time timeout ${ builtins.toString config.promoter.personal.timeout } git merge-base --is-ancestor origin/main "origin/$FLAKE_REF"
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 3699464702500510 ${ builtins.toString failure } "$INPUT" "$FLAKE_REF" "$FLAKE_URL" "$FLAKE_SSH_URL"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        SEEN_INPUTS["$INPUT"]=1
                                                                                                                                                                                                        shift 3
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                    --timeout)
                                                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            failure 7892245586736506 "$@"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                        shift 2
                                                                                                                                                                                                        fi
                                                                                                                                                                                                    *)
                                                                                                                                                                                                        failure 2758365734670044 "$@"
                                                                                                                                                                                                        ;;
                                                                                                                                                                                                esac
                                                                                                                                                                                            done
                                                                                                                                                                                        '' ;
                                                                                                                                                                                } ;
                                                                                                                                                                    in
                                                                                                                                                                        [
                                                                                                                                                                            pkgs.flock
                                                                                                                                                                            (
                                                                                                                                                                                config.lazy-shell-application
                                                                                                                                                                                    {
                                                                                                                                                                                        mounts =
                                                                                                                                                                                            {
                                                                                                                                                                                                "log.yaml" = { source = "/mounts/log.yaml" ; type = "bind" ; } ;
                                                                                                                                                                                            } ;
                                                                                                                                                                                        name = "failure-candidate" ;
                                                                                                                                                                                        post = [ ] ;
                                                                                                                                                                                        runtime-inputs = { pkgs , ... } : [ ( config.failure { } ) pkgs.coreutils ( verify-inputs 6873280773848565 ) ] ;
                                                                                                                                                                                        text =
                                                                                                                                                                                            ''
                                                                                                                                                                                                TIMESTAMP="$( date +%s )" || failure 2131060546120731
                                                                                                                                                                                                jq \
                                                                                                                                                                                                    --null-input \
                                                                                                                                                                                                    --sort-keys \
                                                                                                                                                                                                    --arg SCRIPT "$0" \
                                                                                                                                                                                                    --argjson TIMESTAMP "$TIMESTAMP" \
                                                                                                                                                                                                    --args \
                                                                                                                                                                                                    '[
                                                                                                                                                                                                        {
                                                                                                                                                                                                            "arguments" : $ARGS.positional ,
                                                                                                                                                                                                            "script" : $SCRIPT ,
                                                                                                                                                                                                            "timestamp" : $TIMESTAMP
                                                                                                                                                                                                        }
                                                                                                                                                                                                    ]' "$@" | yq eval --prettyPrint >> /mounts/log.yaml
                                                                                                                                                                                            '' ;
                                                                                                                                                                                        variables = { } ;
                                                                                                                                                                                    }
                                                                                                                                                                            )
                                                                                                                                                                            (
                                                                                                                                                                                config.lazy-shell-application
                                                                                                                                                                                    {
                                                                                                                                                                                        mounts =
                                                                                                                                                                                            {
                                                                                                                                                                                                log-flake-check-standard-error = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                log-flake-check-standard-output = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                log-verify-inputs-standard-error = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                log-verify-inputs-standard-output = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                "log.yaml" = { source = "/mounts/log.yaml" ; type = "bind" ; } ;
                                                                                                                                                                                                work = { type = "temporary" ; } ;
                                                                                                                                                                                            } ;
                                                                                                                                                                                        name = "test-candidate" ;
                                                                                                                                                                                        post = [ ] ;
                                                                                                                                                                                        runtime-inputs = { pkgs , ... } : [ ( config.failure { } ) pkgs.coreutils pkgs.git pkgs.jq pkgs.nix pkgs.yq-go ( extract-timeout 5850705811307304 ) ( verify-inputs 2763619251225455 ) ] ;
                                                                                                                                                                                        text =
                                                                                                                                                                                            ''
                                                                                                                                                                                                cleanup() {
                                                                                                                                                                                                    STATUS="$?"
                                                                                                                                                                                                    TIMESTAMP="$( date +%s )" || failure 4403456455560930
                                                                                                                                                                                                    jq \
                                                                                                                                                                                                        --null-input \
                                                                                                                                                                                                        --sort-keys \
                                                                                                                                                                                                        --rawfile LOG_FLAKE_CHECK_STANDARD_ERROR /mounts/log-flake-check-standard-error \
                                                                                                                                                                                                        --rawfile LOG_FLAKE_CHECK_STANDARD_OUTPUT /mounts/log-flake-check-standard-output \
                                                                                                                                                                                                        --rawfile LOG_VERIFY_INPUTS_STANDARD_ERROR /mounts/log-verify-inputs-standard-error \
                                                                                                                                                                                                        --rawfile LOG_VERIFY_INPUTS_STANDARD_OUTPUT /mounts/log-verify-inputs-standard-output \
                                                                                                                                                                                                        --arg SCRIPT "$0" \
                                                                                                                                                                                                        --argjson STATUS "$STATUS" \
                                                                                                                                                                                                        --argjson TIMESTAMP "$TIMESTAMP" \
                                                                                                                                                                                                        --args \
                                                                                                                                                                                                        '[
                                                                                                                                                                                                            {
                                                                                                                                                                                                                "arguments" : $ARGS.positional ,
                                                                                                                                                                                                                "script" : $SCRIPT ,
                                                                                                                                                                                                                "flake-check" :
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        "standard-error" : $LOG_FLAKE_CHECK_STANDARD_ERROR ,
                                                                                                                                                                                                                        "standard-output" : $LOG_FLAKE_CHECK_STANDARD_OUTPUT
                                                                                                                                                                                                                    } ,
                                                                                                                                                                                                                "verify-inputs" :
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        "standard-error" : $LOG_VERIFY_INPUTS_STANDARD_ERROR ,
                                                                                                                                                                                                                        "standard-output" : $LOG_VERIFY_INPUTS_STANDARD_OUTPUT
                                                                                                                                                                                                                    } ,
                                                                                                                                                                                                                "status" : $STATUS ,
                                                                                                                                                                                                                "timestamp" : $TIMESTAMP
                                                                                                                                                                                                            }
                                                                                                                                                                                                        ]' "$@" | yq eval --prettyPrint >> /mounts/log.yaml || true
                                                                                                                                                                                                    exit "$STATUS"
                                                                                                                                                                                                }
                                                                                                                                                                                                trap cleanup EXIT
                                                                                                                                                                                                verify-inputs "$@" > /mounts/log-verify-inputs-standard-output 2> /mounts/log-verify-inputs-standard-error
                                                                                                                                                                                                cd /mounts/work
                                                                                                                                                                                                git init
                                                                                                                                                                                                cat ${ ./config/flake.nix } > flake.nix
                                                                                                                                                                                                cat ${ ./config/nixpkgs.nix } > nixpkgs.nix
                                                                                                                                                                                                cat ${ ./config/personal.nix } > personal.nix
                                                                                                                                                                                                cat ${ ./config/promoter.nix } > promoter.nix
                                                                                                                                                                                                cat ${ ./config/system.nix } > system.nix
                                                                                                                                                                                                cat ${ ./config/visa.nix } > visa.nix
                                                                                                                                                                                                git add flake.nix nixpkgs.nix personal.nix promoter.nix system.nix
                                                                                                                                                                                                TIMEOUT="$( extract-timeout "$@" )" || failure 4495567215883536
                                                                                                                                                                                                time timeout $TIMEOUT" nix flake check "$@" > /mounts/log-flake-check-standard-output 2> /mounts/log-flake-check-standard-error
                                                                                                                                                                                            '' ;
                                                                                                                                                                                        variables = { } ;
                                                                                                                                                                                    }
                                                                                                                                                                            )
                                                                                                                                                                            (
                                                                                                                                                                                config.lazy-shell-application
                                                                                                                                                                                    {
                                                                                                                                                                                        mounts =
                                                                                                                                                                                            {
                                                                                                                                                                                                dot-ssh = { type = "temporary" ; } ;
                                                                                                                                                                                                log-verify-inputs-standard-error = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                log-verify-inputs-standard-output = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                log-promote-standard-error = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                log-promote-standard-output = { is-directory = false ; type = "temporary" ; } ;
                                                                                                                                                                                                "log.yaml" = { source = "/mounts/log.yaml" ; type = "bind" ; } ;
                                                                                                                                                                                                work = { type = "temporary" ; } ;
                                                                                                                                                                                            } ;
                                                                                                                                                                                        name = "success-candidate" ;
                                                                                                                                                                                        post = [ ] ;
                                                                                                                                                                                        runtime-inputs = { pkgs , ... } : [ ( config.failure { } ) pkgs.coreutils ( extract-timeout 0440445674227486 ) ( verify-inputs 6873280773848565 ) ] ;
                                                                                                                                                                                        text =
                                                                                                                                                                                            ''
                                                                                                                                                                                                ORIGINAL_ARGS=("$@")
                                                                                                                                                                                                cleanup() {
                                                                                                                                                                                                    STATUS="$?"
                                                                                                                                                                                                    TIMESTAMP="$( date +%s )" || failure 4686541221118442
                                                                                                                                                                                                    jq \
                                                                                                                                                                                                        --null-input \
                                                                                                                                                                                                        --rawfile LOG_VERIFY_INPUTS_STANDARD_ERROR /mounts/log-verify-inputs-standard-error \
                                                                                                                                                                                                        --rawfile LOG_VERIFY_INPUTS_STANDARD_OUTPUT /mounts/log-verify-inputs-standard-output \
                                                                                                                                                                                                        --arg SCRIPT "$0" \
                                                                                                                                                                                                        --argjson STATUS "$STATUS" \
                                                                                                                                                                                                        --argjson TIMESTAMP "$TIMESTAMP" \
                                                                                                                                                                                                        --args \
                                                                                                                                                                                                        '[
                                                                                                                                                                                                            {
                                                                                                                                                                                                                "arguments" : $ARGS.positional ,
                                                                                                                                                                                                                "verify-inputs" :
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        "standard-error" : $LOG_VERIFY_INPUTS_STANDARD_ERROR ,
                                                                                                                                                                                                                        "standard-output" : $LOG_VERIFY_INPUTS_STANDARD_OUTPUT
                                                                                                                                                                                                                    } ,
                                                                                                                                                                                                                "script" : $SCRIPT ,
                                                                                                                                                                                                                "status" : $STATUS ,
                                                                                                                                                                                                                "timestamp" : $TIMESTAMP
                                                                                                                                                                                                            }
                                                                                                                                                                                                        ]' "${ "$" }{ORIGINAL_ARGS[@]}" | yq eval --prettyPrint >> /mounts/log.yaml || true
                                                                                                                                                                                                    exit "$STATUS"
                                                                                                                                                                                                }
                                                                                                                                                                                                trap cleanup EXIT
                                                                                                                                                                                                verify-inputs "$@" > /mounts/log-verify-inputs-standard-output 2> /mounts/log-verify-inputs-standard-error
                                                                                                                                                                                                TIMEOUT="$( extract-timeout "$@" )" || failure 0758728069227938
                                                                                                                                                                                                cat > /mounts/dot-ssh <<EOF
                                                                                                                                                                                                Host github.com
                                                                                                                                                                                                User git
                                                                                                                                                                                                IdentityFile /mounts/dot-ssh/identity
                                                                                                                                                                                                UserKnownHostsFile /mounts/dot-ssh/known-hosts
                                                                                                                                                                                                StrictHostKeyChecking no
                                                                                                                                                                                                EOF
                                                                                                                                                                                                chmod 0700 /mounts/dot-ssh
                                                                                                                                                                                                while [[ "$#" -gt 0 ]]
                                                                                                                                                                                                do
                                                                                                                                                                                                    case "$1" in
                                                                                                                                                                                                        --identity)
                                                                                                                                                                                                            if [[ "$#" -lt 2 ]]
                                                                                                                                                                                                            then
                                                                                                                                                                                                                failure 7011894971397015
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            if [[ -e /mounts/dot-ssh/identity ]]
                                                                                                                                                                                                            then
                                                                                                                                                                                                                failure 8126750884079075
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            IDENTITY="$2"
                                                                                                                                                                                                            echo "$IDENTITY" > /mounts/dot-ssh/identity
                                                                                                                                                                                                            chmod 0400 /mounts/dot-ssh/identity
                                                                                                                                                                                                            shift 2
                                                                                                                                                                                                            ;;
                                                                                                                                                                                                        --override-input)
                                                                                                                                                                                                            if [[ "$#" -lt 3 ]]
                                                                                                                                                                                                            then
                                                                                                                                                                                                                failure 7792943012687611 "$@"
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            if [[ ! f /mounts/dot-ssh/identity ]]
                                                                                                                                                                                                            then
                                                                                                                                                                                                                failure 0181553345914754
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            INPUT="$2"
                                                                                                                                                                                                            FLAKE_REF="$3"
                                                                                                                                                                                                            mkdir --parents "/mounts/work/success-candidate/$INPUT/$FLAKE_REF"
                                                                                                                                                                                                            cd "/mounts/work/success-candidate/$INPUT/$FLAKE_REF"
                                                                                                                                                                                                            git init
                                                                                                                                                                                                            FLAKE_URL="$( awk -v input="$INPUT" '$1 == input ".url" { gsub(/[";]/, "", $3) ; print $3 }' ${ ./config/flake.nix } )" || failure 5800237750793123
                                                                                                                                                                                                            case "$FLAKE_URL" in
                                                                                                                                                                                                                github:*)
                                                                                                                                                                                                                    FLAKE_SSH_URL="git@github.com:${ "$" }{FLAKE_URL#github:}.git"
                                                                                                                                                                                                                    ;;
                                                                                                                                                                                                                *)
                                                                                                                                                                                                                    failure 6577158659239693 "$INPUT" "$FLAKE_URL"
                                                                                                                                                                                                                    ;;
                                                                                                                                                                                                            esac
                                                                                                                                                                                                            git remote add origin "$FLAKE_SSH_URL"
                                                                                                                                                                                                            git fetch origin main
                                                                                                                                                                                                            git fetch origin "$FLAKE_REF"
                                                                                                                                                                                                            if time timeout "$TIMEOUT" git push origin "refs/heads/$FLAKE_REF:refs/heads/main" > /mounts/log-promote-standard-output 2> /mounts/log-promote-standard-error
                                                                                                                                                                                                            then
                                                                                                                                                                                                                STATUS="$?"
                                                                                                                                                                                                            else
                                                                                                                                                                                                                STATUS="$?"
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            TIMESTAMP="$( date +%s )" || failure 3279756893357265
                                                                                                                                                                                                            jq \
                                                                                                                                                                                                                --null-input \
                                                                                                                                                                                                                --arg FLAKE_REF "$FLAKE_REF" \
                                                                                                                                                                                                                --arg INPUT "$INPUT" \
                                                                                                                                                                                                                --rawfile LOG_PROMOTE_STANDARD_ERROR /mounts/log-promote-standard-error \
                                                                                                                                                                                                                --rawfile LOG_PROMOTE_STANDARD_OUTPUT /mounts/log-promote-standard-output \
                                                                                                                                                                                                                --arg SCRIPT "$0" \
                                                                                                                                                                                                                --argjson STATUS "$STATUS" \
                                                                                                                                                                                                                '[
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        "flake-ref" : $FLAKE_REF ,
                                                                                                                                                                                                                        "input" : $INPUT ,
                                                                                                                                                                                                                        "promote" :
                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                "standard-error" : $LOG_PROMOTE_STANDARD_ERROR ,
                                                                                                                                                                                                                                "standard-output" : $LOG_PROMOTE_STANDARD_OUTPUT
                                                                                                                                                                                                                            } ,
                                                                                                                                                                                                                        "script" : $SCRIPT ,
                                                                                                                                                                                                                        "status" : $STATUS ,
                                                                                                                                                                                                                        "timestamp" : $TIMESTAMP
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                ]' | yq eval --prettyPrint >> /mounts/log.yaml || true
                                                                                                                                                                                                            if [[ "$STATUS" != 0 ]]
                                                                                                                                                                                                            then
                                                                                                                                                                                                                failure 6671477303488324 "$STATUS" "$INPUT" "$FLAKE_REF" "$FLAKE_URL" "$FLAKE_SSH_URL"
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            shift 3
                                                                                                                                                                                                            ;;
                                                                                                                                                                                                        --timeout)
                                                                                                                                                                                                            if [[ "$#" -lt 1 ]]
                                                                                                                                                                                                            then
                                                                                                                                                                                                                failure 2191754731581915 "$@"
                                                                                                                                                                                                            fi
                                                                                                                                                                                                            shift 2
                                                                                                                                                                                                            ;;
                                                                                                                                                                                                        *)
                                                                                                                                                                                                            failure 5605724406678642 "$@"
                                                                                                                                                                                                            ;;
                                                                                                                                                                                                    esac
                                                                                                                                                                                                done
                                                                                                                                                                                            '' ;
                                                                                                                                                                                        variables = { } ;
                                                                                                                                                                                    }
                                                                                                                                                                            )
                                                                                                                                                                        ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                exec 138> /mounts/lock
                                                                                                                                                                flock -x 138
                                                                                                                                                                if nice --adjustment 19 test-candidate "$ITEM"
                                                                                                                                                                then
                                                                                                                                                                    nice --adjustment 19 success-candidate "$ITEM"
                                                                                                                                                                else
                                                                                                                                                                    nice --adjustment 19 failure-candidate "$ITEM"
                                                                                                                                                                fi
                                                                                                                                                            '' ;
                                                                                                                                                        variables = { } ;
                                                                                                                                                    }
                                                                                                                                            )
                                                                                                                                        ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        exec 133> /mounts/lock
                                                                                                                                        flock -x 133
                                                                                                                                        if [[ -s /mounts/list ]]
                                                                                                                                        then
                                                                                                                                            ITEM="$( head --lines 1 /mounts/list )" || failure 5563603558226371
                                                                                                                                            nohup nice --adjustment 19 process-candidate "$ITEM" &
                                                                                                                                            tail --lines +2 /mounts/list > /mounts/temporary
                                                                                                                                            mv /mounts/temporary /mounts/list
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/process-candidate"
                                                                                                            )
                                                                                                        ] ;
                                                                                                    runtime-inputs =
                                                                                                        { pkgs , ... } :
                                                                                                            [
                                                                                                                pkgs.flock
                                                                                                            ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            exec 151> /mounts/lock
                                                                                                            flock -x 151
                                                                                                            echo "$@" >> /mounts/list
                                                                                                        '' ;
                                                                                                    variables = { } ;
                                                                                                }
                                                                                        )
                                                                                    ] ;
                                                                                text =
                                                                                    ''
                                                                                        nohup nice --adjustment 19 queue "$@" &
                                                                                    '' ;
                                                                            } ;
                                                                    type = lib.types.package ;
                                                                } ;
                                                        } ;
                                                } ;
                            in
                                {
                                    implementation =
                                        if builtins.typeOf output == "lambda" then output implementation
                                        else if builtins.typeOf output == "null" then implementation
                                        else builtins.throw "0684019859103061" ;
                                } ;
            } ;
}