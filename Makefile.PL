use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Mojolicious::Plugin::Logf',
  ABSTRACT_FROM => 'lib/Mojolicious/Plugin/Logf.pm',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Logf.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'perl',
  PREREQ_PM => {

  },
  BUILD_REQUIRES => {

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
  #MIN_PERL_VERSION => 5.10,
  #EXE_FILES => ['bin/my-app'],
);
