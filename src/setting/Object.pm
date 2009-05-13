subset Matcher of Object where { .can('ACCEPTS') };

class Object is also {
    multi method perl {
        self.WHAT.substr(0, -2) ~ '.new()';
    }

    multi method eigenstates {
        list(self)
    }

    method WALK(:$name!, :$canonical, :$ascendant, :$descendant, :$preorder, :$breadth,
                :$super, Matcher :$omit = False, Matcher :$include = True) {
        # First, build list of classes in the order we'll need them.
        my @classes;
        if $super {
            @classes = self.^parents(:local);
        } else {
            if $breadth {
                my @search_list = self.WHAT;
                while @search_list {
                    push @classes, @search_list.list();
                    my @new_search_list;
                    for @search_list -> $current {
                        for $current.^parents(:local) -> $next {
                            unless any(@new_search_list <<===>> $next) {
                                push @new_search_list, $next;
                            }
                        }
                    }
                    @search_list = @new_search_list;
                }
            } elsif $ascendant | $preorder {
                my sub build_ascendent($class) {
                    unless any(@classes <<===>> $class) {
                        push @classes, $class;
                        for $class.^parents(:local) {
                            build_ascendent($^parent);
                        }
                    }
                }
                build_ascendent(self.WHAT);
            } elsif $descendant {
                my sub build_descendent($class) {
                    unless any(@classes <<===>> $class) {
                        for $class.^parents(:local) {
                            build_descendent($^parent);
                        }
                        push @classes, $class;
                    }
                }
                build_descendent(self.WHAT);
            } else {
                # Canonical, the default (just whatever the meta-class says).
                @classes = self.^parents();
            }
        }
        # Now we have classes, build method list.
        my @methods;
        for @classes -> $class {
            if $include.ACCEPTS($class) && !$omit.ACCEPTS($class) {
                for $class.^methods() -> $method {
                    my $check_name = $method.?name;
                    if $check_name.defined && $check_name eq $name {
                        @methods.push($method);
                    }
                }
            }
        }

        return @methods;
    }
}

# vim: ft=perl6
