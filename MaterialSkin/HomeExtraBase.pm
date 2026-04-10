package Plugins::MaterialSkin::HomeExtraBase;

use strict;

use base qw(Slim::Plugin::OPMLBased);
use Plugins::MaterialSkin::Plugin;

sub initPlugin {
    my ($class, %args) = @_;

    my $extra = delete $args{extra};

    $class->SUPER::initPlugin(%args);

    $extra->{handler} = sub { $class->handleExtra(@_) }; #Sven 2026-02-10

    Plugins::MaterialSkin::Plugin->registerHomeExtra($args{tag}, {
        title => $extra->{title},
        subtitle => $extra->{subtitle},
        icon  => $extra->{icon},
        needsPlayer => $extra->{needsPlayer},

        handler => sub { $class->handleExtra(@_) }, #Sven 2026-02-10
    });
}

#  we don't want these menus to be shown anywhere but as Home Extras
sub initJive {[]}
sub modeName {}

sub handleExtra { #Sven 2026-02-05 von Craig abgewandelte Version, sollte im Ergebnis den gleichen Effek6t haben, ist möglicherweise etwas sicherer.
    my ($class, $client, $cb, $count, $userId) = @_;

    my @cmd = ($class->tag, 'items', 0, $count || Plugins::MaterialSkin::Plugin::NUM_HOME_ITEMS(), 'menu:1');

    push(@cmd, "user_id:${userId}") if $userId; #Sven 2026-04-10

    Slim::Control::Request::executeRequest($client, \@cmd,
        sub {
            my $response = shift;
            my $results = $response->getResults() || {};
            $cb->($results);
        }
    );
}

1;