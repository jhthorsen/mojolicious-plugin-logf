use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Mojolicious::Plugin::Logf',
  ABSTRACT_FROM => 'lib/Mojolicious/Plugin/Logf.pm',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Logf.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'perl',
  PREREQ_PM => {
    'Mojolicious' => 4.30,
  },
  BUILD_REQUIRES => {
    'Test::More' => 0.90,
  },
  META_MERGE => {
    resources => {
      license => 'http://dev.perl.org/licenses/',
      homepage => 'https://metacpan.org/release/Mojolicious-Plugin-Logf',
      bugtracker => 'https://github.com/jhthorsen/mojolicious-plugin-logf/issues',
      repository => 'https://github.com/jhthorsen/mojolicious-plugin-logf.git',
    },
  },
  test => {
    TESTS => 't/*.t',
  },
);
