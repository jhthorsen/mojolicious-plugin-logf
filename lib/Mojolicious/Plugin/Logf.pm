package Mojolicious::Plugin::Logf;

=head1 NAME

Mojolicious::Plugin::Logf - Plugin for logging datastructures using sprintf

=head1 VERSION

0.01

=head1 DESCRIPTION

L<Mojolicious::Plugin::Logf> is a plugin which will log complex datastructures
and avoid "unitialized" warnings.

=head1 SYNOPSIS

  use Mojolicious::Lite;
  plugin "Logf";

  get "/" => sub {
    my $self = shift;

    $self->logf(info => 'request: %s', $self->req->params->to_hash);
  };

=cut

use Mojo::Base 'Mojolicious::Plugin';
use Data::Dumper ();

our $VERSION = '0.01';

=head1 HELPERS

=head2 logf

  $c->logf($format, @args);

Logs a string formatted by the usual C<printf> conventions of the C library
function C<sprintf>. C<@args> will be converted using these rules:

=over 4

=item * Normal string

=item * Data structure

=item * Undefined value

=back

=cut

sub logf {
  my($self, $c, $format, @args) = @_;
}

=head1 METHODS

=head2 register

Will register the L</logf> helper in the application

=cut

sub register {
  my ($self, $app, $config) = @_;

  $app->register(logf => sub { $self->logf(@_); });
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014, Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
