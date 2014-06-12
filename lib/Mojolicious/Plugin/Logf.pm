package Mojolicious::Plugin::Logf;

=head1 NAME

Mojolicious::Plugin::Logf - Plugin for logging datastructures using sprintf

=head1 VERSION

0.01

=head1 DESCRIPTION

L<Mojolicious::Plugin::Logf> is a plugin which will log complex datastructures
and avoid "unitialized" warnings. This plugin use L<Mojo::Log> or whatever
L<Mojo/log> is set to, to do the actual logging.

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
use overload ();

our $VERSION = '0.01';

=head1 HELPERS

=head2 logf

  $self = $c->logf;
  $c = $c->logf($level => $format, @args);

Logs a string formatted by the usual C<printf> conventions of the C library
function C<sprintf>. C<$level> need to be a valid L<Mojo::Log> level.
C<@args> will be converted using L</flatten>.

Calling this method without any arguments will return C<$self>
(an instance of this plugin), allowing you to call L</flatten>:

  @args_as_strings = $c->logf->flatten(@args);

=cut

sub logf {
  my ($self, $c, $level, $format, @args) = @_;
  my $log = $c->app->log;

  $log->$level(sprintf $format, $self->flatten(@args)) if $log->${ \ "is_$level" };
  $c;
}

=head1 METHODS

=head2 flatten

  @args_as_strings = $self->flatten(@args);

Used to convert input C<@args> using these rules:

=over 4

=item * Scalar

No rule applied.

=item * Object with string overloading

Will be coverted to a string using the string overloading function.

=item * Data structure or object

Will be serialized using L<Data::Dumper> with these settings:

  $Data::Dumper::Indent = 0;
  $Data::Dumper::Maxdepth = $Data::Dumper::Maxdepth || 2;
  $Data::Dumper::Sortkeys = 1;
  $Data::Dumper::Terse = 1;

NOTE! These settings might change, but will always do its best to
serialize the object into one line. C<$Data::Dumper::Maxdepth> is
used to avoid dumping large nested objects. Set this variable
if you need deeper logging. Example:

  local $Data::Dumper::Maxdepth = 1000;
  $c->logf(info => 'Deep structure: %s', $some_object);

=item * Undefined value

Will be logged as "__UNDEF__".

=back

=cut

sub flatten {
  my ($self, @args) = @_;

  local $Data::Dumper::Indent = 0;
  local $Data::Dumper::Maxdepth = $Data::Dumper::Maxdepth || 2;
  local $Data::Dumper::Sortkeys = 1;
  local $Data::Dumper::Terse = 1;

  for my $arg (@args) {
    $arg = !defined $arg                 ? "__UNDEF__"
         : overload::Method($arg, q("")) ? "$arg"
         : ref $arg                      ? Data::Dumper::Dumper($arg)
         :                               $arg
         ;
  }

  return @args;
}

=head2 register

Will register the L</logf> helper in the application

=cut

sub register {
  my ($self, $app, $config) = @_;

  $app->helper(logf => sub {
    return $self if @_ == 1;
    return $self->logf(@_);
  });
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014, Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
