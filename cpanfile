requires 'perl', '5.008005';
requires 'CPAN::Meta::YAML';
requires 'HTTP::Tiny';
requires 'IO::Socket::SSL';
requires 'JSON::PP';
requires 'Module::CoreList';

on test => sub {
    requires 'Test::More', '0.96';
};
