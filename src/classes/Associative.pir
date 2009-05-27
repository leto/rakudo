## $Id$

=head1 NAME

src/classes/Associative.pir - Associative Role

=head1 DESCRIPTION

=cut

.namespace ['Associative[::T]']

.sub '_associative_role_body'
    .param pmc type :optional
    
    $P0 = get_hll_global ['Associative[::T]'], 'postcircumfix:{ }'
    capture_lex $P0
    $P0 = get_hll_global ['Associative[::T]'], 'of'
    capture_lex $P0

    # Capture type.
    if null type goto no_type
    type = type.'WHAT'()
    goto type_done
  no_type:
    type = get_hll_global 'Object'
  type_done:
    .lex 'T', type
    
    # Create role.
    .local pmc metarole
    metarole = "!meta_create"("role", "Associative[::T]", 0)
    .tailcall '!create_parametric_role'(metarole)
.end
.sub '' :load :init :outer('_associative_role_body')
    .local pmc block, signature
    block = get_hll_global ['Associative[::T]'], '_associative_role_body'
    signature = new ["Signature"]
    setprop block, "$!signature", signature
    signature."!add_param"("T", 1 :named("optional"))
    "!ADDTOROLE"(block)
.end


=head2 Operators

=over

=item postcircumfix:<{ }>

Returns a list element or slice.

=cut

.sub 'postcircumfix:{ }' :method :outer('_associative_role_body')
    .param pmc args            :slurpy
    .param pmc options         :slurpy :named
    .local pmc result, type
    type = find_lex 'T'
    args.'!flatten'()
    if args goto do_index
    ## return complete set of values as a list
    .tailcall self.'values'()
  do_index:
    $I0 = args.'elems'()
    if $I0 != 1 goto slice
    $S0 = args[0]
    result = self[$S0]
    unless null result goto end
    result = 'undef'()
    setprop result, 'type', type
    self[$S0] = result
    goto end
  slice:
    result = new ['List']
  slice_loop:
    unless args goto slice_done
    $S0 = shift args
    .local pmc elem
    elem = self[$S0]
    unless null elem goto slice_elem
    elem = 'undef'()
    setprop elem, 'type', type
    self[$S0] = elem
  slice_elem:
    push result, elem
    goto slice_loop
  slice_done:
  end:
    .return (result)
.end
.sub '' :load :init
    .local pmc block, signature
    block = get_hll_global ['Associative[::T]'], 'postcircumfix:{ }'
    signature = new ["Signature"]
    setprop block, "$!signature", signature
    signature."!add_param"("$args", 0 :named("named"))
    signature."!add_param"("$options", 1 :named("named"))
.end


=item of

Returns the type constraining what may be stored.

=cut

.sub 'of' :method :outer('_associative_role_body')
    $P0 = find_lex 'T'
    .return ($P0)
.end
.sub '' :load :init
    .local pmc block, signature
    block = get_hll_global ['Associative[::T]'], 'of'
    signature = new ["Signature"]
    setprop block, "$!signature", signature
.end


.namespace []
.sub 'postcircumfix:{ }'
    .param pmc invocant
    .param pmc args    :slurpy
    .param pmc options :slurpy :named
    $I0 = can invocant, 'postcircumfix:{ }'
    if $I0 goto object_method
    $I0 = isa invocant, 'Perl6Object'
    if $I0 goto object_method
  foreign:
    $P0 = get_hll_global ['Associative[::T]'], 'postcircumfix:{ }'
    .tailcall $P0(invocant, args :flat, options :flat :named)
  object_method:
    .tailcall invocant.'postcircumfix:{ }'(args :flat, options :flat :named)
.end

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

