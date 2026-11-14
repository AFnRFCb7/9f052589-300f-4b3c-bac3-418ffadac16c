{ ... } :
    {
        nixpkgs.config.android_sdk.accept_license = true ;
        nixpkgs.config.allowUnfree = true ;
        personal =
            {
                agenix = ./age.key ;
                description = "Emory Merryman" ;
                email = "emory.merryman@gmail.com" ;
                name = "emory" ;
                password = "blueberry" ;
                secrets.known-hosts = ./temporary/known-hosts ;
                temporary =
                    {
                        ssh =
                            {
                                identity = ./temporary/id_rsa ;
                                known-hosts = ./temporary/known-hosts ;
                            } ;
                    } ;
                wifi =
                    {
                        "bigwhitemachine" =
                            {
                                psk = "fukdis1!123" ;
                            } ;
                        "Starry08278" =
                            {
                                psk = "judipn0pax" ;
                            } ;
                        "Galaxy A126AAA" =
                            {
                                psk = "yeyx1272" ;
                            } ;
                    } ;
            } ;
    }