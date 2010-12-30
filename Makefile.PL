use inc::Module::Install;

name     'Announcements';
all_from 'lib/Announcements.pm';
githubmeta;

requires 'Moose';

WriteAll;

