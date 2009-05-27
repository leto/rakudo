## $Id$

=head1 TITLE

Match - Perl 6 match objects

=head1 Description

=cut

.namespace ['Match']
.sub '' :anon :load :init
    .local pmc p6meta, matchproto
    p6meta = get_hll_global ['Perl6Object'], '$!P6META'
    matchproto = p6meta.'new_class'('Match', 'parent'=>'parrot;PGE::Grammar Any')
    $P0 = p6meta.'get_parrotclass'(matchproto)
    $P1 = root_new ['parrot';'ResizablePMCArray']
    push $P1, 'of'
    $P0.'resolve_method'($P1)
    $P0 = get_hll_global 'Positional'
    $P0 = $P0.'!select'()
    p6meta.'add_role'($P0, 'to'=>matchproto)
    $P0 = get_hll_global 'Associative'
    $P0 = $P0.'!select'()
    p6meta.'add_role'($P0, 'to'=>matchproto)
.end


=item hash, list

Currently C<Object> interposes its own C<hash> and C<list> methods
on Match objects, these force Match.hash and Match.list to
properly delegate to the underlying Capture PMC.

=cut

.sub '' :method('item')
    .return (self)
.end

.sub '' :method('hash')
    $P0 = getattribute self, ['Capture'], 'proxy'
    $P1 = $P0.'hash'()
    .return ($P1)
.end

.sub '' :method('list')
    $P0 = getattribute self, ['Capture'], 'proxy'
    $P1 = $P0.'list'()
    .return ($P1)
.end


=item of

Returns the type of value that this Match object may store. Note: we need this
to resolve role composition collision with Positional and Associative. At some
point we may not have of there, but for now it's the best place.

=cut

.sub 'of' :method
    $P0 = get_hll_global 'Object'
    .return ($P0)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
