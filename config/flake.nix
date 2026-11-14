{
    inputs =
        {
            android-application.url = "github:AFnRFCb7/a2914e98-2911-405f-8046-3a263071eda9";
            failure.url = "github:AFnRFCb7/failure";
            fixture.url = "github:AFnRFCb7/fixture";
            lazy-shell-application.url = "github:AFnRFCb7/lazy-shell-application";
            lazy-shell-resource.url = "github:AFnRFCb7/resource";
            nixpkgs.url = "github:Nixos/nixpkgs/nixos-24.11";
            node-fetch.url = "github:AFnRFCb7/node-fetch";
            node-package.url = "github:AFnRFCb7/449ceb5d-ccdf-44dc-a710-998deef819f";
            personal.url = "github:AFnRFCb7/personal";
            portal.url = "github:AFnRFCb7/df2532c6-ab52-412e-a72a-6b29d480b9bd";
            promoter.url = "github:AFnRFCb7/9f052589-300f-4b3c-bac3-418ffadac16c";
            sally.url = "github:AFnRFCb7/113002d6-8edb-4dfa-9d3b-2e4e69b46658";
            sequential.url = "github:AFnRFCb7/f85ebe91-4135-4df9-9f8e-41b18583abe6";
            tree-serialization.url = "github:AFnRFCb7/tree-serialization";
            trump5000.url = "github:AFnRFCb7/89c7ac5a-4aea-48ed-abd9-0c30a565f97c";
            trip.url = "github:AFnRFCb7/1f343d60-2ecb-434e-b606-751c4ad2c485";
            visa.url = "github:AFnRFCb7/d39e5148-0459-45f0-ad44-09d29696e39d";
            visitor.url = "github:AFnRFCb7/visitor";
            wrap.url = "github:AFnRFCb7/bc122403-1370-4d95-bae6-d9e9e069570a";
        } ;
    outputs =
        {
            android-application ,
            failure ,
            fixture ,
            lazy-shell-application ,
            lazy-shell-resource ,
            nixpkgs ,
            node-fetch ,
            node-package ,
            personal ,
            portal ,
            promoter ,
            sally ,
            self ,
            sequential ,
            tree-serialization ,
            trip ,
            trump5000 ,
            visa ,
            visitor ,
            wrap
        } :
            let
                personal_ =
                    personal.lib
                        {
                            nixpkgs = nixpkgs ;
                            private = self ;
                            system = system ;
                        }
                        {
                            # android-application = android-application ;
                            failure = failure ;
                            lazy-shell-application = lazy-shell-application ;
                            lazy-shell-resource = lazy-shell-resource ;
                            # portal = portal ;
                            promoter = promoter ;
                            # sally = sally ;
                            sequential = sequential ;
                            tree-serialization = tree-serialization ;
                            trip = trip ;
                            # trump5000 = trump5000 ;
                            visa = visa ;
                            visitor = visitor ;
                            wrap = wrap ;
                        } ;
                system = "x86_64-linux" ;
                pkgs =
                    import nixpkgs
                        {
                            system = system;
                            config =
                                {
                                    allowUnfree = true ;
                                    android_sdk.accept_license = true ;
                                } ;
                        } ;
                in
                    {
                        checks.${ system } = personal_.checks ;
                        nixosConfigurations=
                            {
                                user =
                                    nixpkgs.lib.nixosSystem
                                        {
                                            modules =
                                                [
                                                    ./hardware-configuration.nix
                                                    personal_.implementation
                                                    ./user.nix
                                                    ./foobar.nix
                                                ] ;
                                            system = system ;
                                        } ;
                           } ;
                    } ;
}