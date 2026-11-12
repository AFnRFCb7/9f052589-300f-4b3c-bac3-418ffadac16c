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
                                                                    actions =
                                                                        {
                                                                            restore =
                                                                                lib.mkOption
                                                                                    {
                                                                                        default =
                                                                                            config.lazy-shell-application
                                                                                                {
                                                                                                    mounts = { } ;
                                                                                                    name = "restore" ;
                                                                                                    post = [ ] ;
                                                                                                    runtime-inputs =
                                                                                                        { pkgs , ... } :
                                                                                                            [
                                                                                                                pkgs.git
                                                                                                                (
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "restore" ;
                                                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    git fetch origin main
                                                                                                                                    git checkout origin/main
                                                                                                                                '' ;
                                                                                                                        }
                                                                                                                )
                                                                                                            ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            git submodule foreach 'restore'
                                                                                                        '' ;
                                                                                                    variables = { } ;
                                                                                                } ;
                                                                                        type = lib.types.package ;
                                                                                    } ;
                                                                            post =
                                                                                lib.mkOption
                                                                                    {
                                                                                        default =
                                                                                            config.lazy-shell-application
                                                                                                {
                                                                                                    mounts =
                                                                                                        {
                                                                                                            dot-ssh = { type = "temporary" ; } ;
                                                                                                            work = { type = "temporary" ; } ;
                                                                                                        } ;
                                                                                                    name = "promote" ;
                                                                                                    post = [ ] ;
                                                                                                    runtime-inputs =
                                                                                                        { config , pkgs , ... } :
                                                                                                            [
                                                                                                                ( config.failure { } )
                                                                                                                pkgs.coreutils
                                                                                                                pkgs.git
                                                                                                                (
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "process-candidate" ;
                                                                                                                            runtimeInputs =
                                                                                                                                [
                                                                                                                                    pkgs.git
                                                                                                                                    pkgs.nix
                                                                                                                                    (
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "cleanup" ;
                                                                                                                                                runtimeInputs =
                                                                                                                                                    [
                                                                                                                                                        ( config.failure { } )
                                                                                                                                                        pkgs.git
                                                                                                                                                        (
                                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                                {
                                                                                                                                                                    name = "promote" ;
                                                                                                                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                                    text =
                                                                                                                                                                        ''
                                                                                                                                                                            ALPHA="$(git rev-parse HEAD)" || failure 2893839237126451
                                                                                                                                                                            BETA="$(git rev-parse origin/main)" || failure 8787959431289203
                                                                                                                                                                            if [[ "$ALPHA" != "$BETA" ]]
                                                                                                                                                                            then
                                                                                                                                                                                if git push origin HEAD:main
                                                                                                                                                                                then
                                                                                                                                                                                    UUID="$(  cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head --lines 1 )" || failure 1962589628164118
                                                                                                                                                                                    git checkout -b "success/$UUID"
                                                                                                                                                                                    git push origin "success/$UUID"
                                                                                                                                                                                    git push origin --delete "$REF"
                                                                                                                                                                                else
                                                                                                                                                                                    UUID="$(  cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head --lines 1 )" || failure 0387526746530622
                                                                                                                                                                                    git checkout -b "rejected/$UUID"
                                                                                                                                                                                    git push origin "rejected/$UUID"
                                                                                                                                                                                    git push origin --delete "$REF"
                                                                                                                                                                                fi
                                                                                                                                                                            elif git diff --quiet origin/main HEAD
                                                                                                                                                                            then
                                                                                                                                                                                UUID="$(  cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head --lines 1 )" || failure 3801835872555108
                                                                                                                                                                                git checkout -b "duplicate/$UUID"
                                                                                                                                                                                git push origin "duplicate/$UUID"
                                                                                                                                                                                git push origin --delete "$REF"
                                                                                                                                                                            fi
                                                                                                                                                                        '' ;
                                                                                                                                                                }
                                                                                                                                                        )
                                                                                                                                                    ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        STATUS="$?"
                                                                                                                                                        if [[ "$STATUS" == 0 ]]
                                                                                                                                                        then
                                                                                                                                                            git submodule foreach 'promote'
                                                                                                                                                        else
                                                                                                                                                            UUID="$(  cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head --lines 1 )" || failure 9910674273434369
                                                                                                                                                            git checkout -b "failure/$UUID"
                                                                                                                                                            git push origin "failure/$UUID"
                                                                                                                                                            git push origin --delete "$REF"
                                                                                                                                                        fi
                                                                                                                                                    '' ;
                                                                                                                                            }
                                                                                                                                    )
                                                                                                                                    (
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "detect-override" ;
                                                                                                                                                runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        if ! git diff --quiet origin/main HEAD
                                                                                                                                                        then
                                                                                                                                                            echo "$name"
                                                                                                                                                        fi
                                                                                                                                                    '' ;
                                                                                                                                            }
                                                                                                                                    )
                                                                                                                                ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    REF="$1"
                                                                                                                                    git fetch origin main
                                                                                                                                    git checkout "$REF"
                                                                                                                                    git rebase origin/main
                                                                                                                                    git submodule update --init --recursive
                                                                                                                                    OVERRIDES=()
                                                                                                                                    git submodule foreach 'git fetch origin main'
                                                                                                                                    git submodule foreach 'detect-overrides'
                                                                                                                                    for (( CHECK=1; CHECK<=NUMBER_OF_CHECKS; CHECK++ ))
                                                                                                                                    do
                                                                                                                                        time timeout ${ builtins.toString config.promoter.personal.timeout } nix build "${ "$" }{OVERRIDES[@]}" --show-trace ".#checks.x86_64-linux.check-$CHECK"
                                                                                                                                    done
                                                                                                                                    time timeout ${ builtins.toString config.promoter.personal.timeout } nix flake check --show-trace "${ "$" }{OVERRIDES[@]}"
                                                                                                                                '' ;
                                                                                                                        }
                                                                                                                )
                                                                                                            ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            cd /mounts/work
                                                                                                            git init
                                                                                                            git remote add origin "github.com:${ config.promoter.personal.organization }/${ config.promoter.personal.repository }.git"
                                                                                                            cat ${ config.promoter.personal.committer.key } > /mounts/dot-ssh/identity.asc
                                                                                                            chmod 0400 /mounts/dot-ssh/identity.asc
                                                                                                            export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -i /mounts/dot-ssh/identity.asc" -o StrictHostKeyChecking=no"
                                                                                                            git config user.email "${ config.promoter.personal.committer.email }"
                                                                                                            git config user.name "${ config.promoter.personal.committer.name }"
                                                                                                            git fetch origin main
                                                                                                            git submodule update --init --recursive
                                                                                                            git submodule foreach 'git config core.sshCommand "${ config.promoter.actions.ssh }/bin/ssh"'
                                                                                                            git submodule foreach 'git config user.email "${ config.promoter.personal.committer.email }"'
                                                                                                            git submodule foreach 'git config user.name "${ config.promoter.personal.committer.name }"'
                                                                                                            while IFS= read -r REF
                                                                                                            do
                                                                                                                process-candidate "$REF"
                                                                                                            done < <( git for-each-ref --format='%(refname)' refs/remotes/origin/candidate/ )
                                                                                                        '' ;
                                                                                                    variables = { } ;
                                                                                                } ;
                                                                                        type = lib.types.package ;
                                                                                    } ;
                                                                            pre =
                                                                                lib.mkOption
                                                                                    {
                                                                                        default =
                                                                                            config.lazy-shell-application
                                                                                                {
                                                                                                    mounts = { } ;
                                                                                                    name = "pre-commit" ;
                                                                                                    post = [ ] ;
                                                                                                    runtime-inputs =
                                                                                                        { pkgs , ... } :
                                                                                                            [
                                                                                                                pkgs.git
                                                                                                                (
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "pre-commit" ;
                                                                                                                            runtimeInputs = [ ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    git fetch origin main
                                                                                                                                    if ! git diff --quiet origin/main HEAD
                                                                                                                                    then
                                                                                                                                        UUID="$( cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head --lines 1 )" || failure 9910674273434369
                                                                                                                                        git checkout -b "candidate/$UUID"
                                                                                                                                        git reset --soft origin/main
                                                                                                                                        git commit -a --verbose
                                                                                                                                        git push origin "candidate/$UUID"
                                                                                                                                    fi
                                                                                                                                '' ;
                                                                                                                        }
                                                                                                                )
                                                                                                            ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            git submodule foreach "submodule-precommit.sh"
                                                                                                            git add .
                                                                                                        '' ;
                                                                                                    variables = { } ;
                                                                                                } ;
                                                                                        type = lib.types.package ;
                                                                                    } ;
                                                                        } ;
                                                                    personal =
                                                                        {
                                                                            committer =
                                                                                {
                                                                                    email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                    key = lib.mkOption { type = lib.types.path ; } ;
                                                                                    name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                } ;
                                                                            number-of-checks = lib.mkOption { default = 13 ; type = lib.types.int ; } ;
                                                                            organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                            repository = lib.mkOption { default = "personal" ; type = lib.types.str ; } ;
                                                                            timeout = lib.mkOption { default = 60 * 60 ; type = lib.types.int ; } ;
                                                                        } ;
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