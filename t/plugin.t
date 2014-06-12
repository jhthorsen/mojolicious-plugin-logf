use Mojo::Base -base;
use Test::Mojo;
use Test::More;

{
  use Mojolicious::Lite;
  plugin "Logf";

  get "/" => sub {
    my $self = shift;

    $self->stash(s => { p => 123 });
    $self->logf(info => 'request: %s', $self->req->params->to_hash);
    $self->logf(warn => 'data: %s %s', undef, $self);
    $self->render(text => 'whatever');
  };

  get "/flatten" => sub {
    my $self = shift;
    $self->render(text => $self->logf->flatten($self->req->params->to_hash));
  };
}

my $t = Test::Mojo->new;
my @messages;

$ENV{MOJO_LOG_LEVEL} = 'debug';
$t->app->log->level('debug');
$t->app->log->unsubscribe('message');
$t->app->log->on(message => sub { shift; push @messages, [@_] if $_[0] =~ /info|warn/; });

{
  $t->get_ok("/?foo=123&bar=42")->status_is(200)->content_is("whatever");

  is $messages[0][0], 'info', 'log info';
  like $messages[0][1], qr{bar.*42}, 'logf to_hash';

  is $messages[1][0], 'warn', 'log warn';
  like $messages[1][1], qr{__UNDEF__}, 'logf undef';
  like $messages[1][1], qr{Mojolicious::Controller}, 'logf Mojolicious::Controller';
  like $messages[1][1], qr{Mojolicious::Controller}, 'logf Mojolicious::Controller';
  like $messages[1][1], qr{'s'.*'HASH}, 'logf stash';
}

{
  $t->get_ok("/flatten?foo=123")->status_is(200)->content_like(qr{'foo'.*123});
}

done_testing;
