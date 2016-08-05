#!/usr/bin/perl
use strict;
use warnings;

use AnyEvent::RabbitMQ;

use lib './lib/Utils';

use Config_Reader qw(getConfigValueByKey);
use Log_Initializer qw(get_Logger);

sendEmails();

sub sendEmails {

    my $condvar = AnyEvent->condvar;
    my $ar      = AnyEvent::RabbitMQ->new;

    get_Logger()->info("Starting Worker ");

    $ar->load_xml_spec()->connect(
        host  => getConfigValueByKey("rabbitMQHost"),
        port  => getConfigValueByKey("rabbitMQport"),
        user  => getConfigValueByKey("rabbitMQuser"),
        pass  => getConfigValueByKey("rabbitMQpass"),
        vhost => '/',

        on_success => sub { _on_connect_success( $condvar, $ar, @_ ) },
        on_failure      => sub { _error( $condvar, $ar, 'failure',      @_ ) },
        on_read_failure => sub { _error( $condvar, $ar, 'read_failure', @_ ) },
        on_return       => sub { _error( $condvar, $ar, 'return',       @_ ) },
        on_close        => sub { _error( $condvar, $ar, 'close',        @_ ) },
    );
    $condvar->recv;

    return;
}

sub _on_connect_success {

    my ( $condvar, $ar, $new_ar ) = @_;
    get_Logger()->info("Connected to RabbitMQ. ");
    _open_channel( $condvar, $new_ar );
    return;
}

sub _open_channel {

    my ( $condvar, $ar ) = @_;
    get_Logger()->info("Opening RabbitMQ channel... ");
    $ar->open_channel(
        on_success => sub { _on_open_channel_success( $condvar, $ar, @_ ) },
        on_failure      => sub { _error( $condvar, $ar, 'failure',      @_ ) },
        on_read_failure => sub { _error( $condvar, $ar, 'read_failure', @_ ) },
        on_return       => sub { _error( $condvar, $ar, 'return',       @_ ) },
        on_close        => sub { _error( $condvar, $ar, 'close',        @_ ) },
    );
    return;
}

sub _on_open_channel_success {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Opened RabbitMQ channel. ");
    $channel->confirm;
    _declare_exchange( $condvar, $ar, $channel );
    return;
}

sub _declare_exchange {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Declaring RabbitMQ exchange... ");
    $channel->declare_exchange(
        exchange => 'testest',
        type     => 'fanout',

        on_success =>
          sub { _on_declare_exchange_success( $condvar, $ar, $channel, @_ ) },
        on_failure      => sub { _error( $condvar, $ar, 'failure',      @_ ) },
        on_read_failure => sub { _error( $condvar, $ar, 'read_failure', @_ ) },
        on_return       => sub { _error( $condvar, $ar, 'return',       @_ ) },
        on_close        => sub { _error( $condvar, $ar, 'close',        @_ ) },
    );
    return;
}

sub _on_declare_exchange_success {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Declared RabbitMQ exchange. ");
    _bind_exchange( $condvar, $ar, $channel );
    return;
}

sub _bind_exchange {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Binding RabbitMQ exchange... ");
    $channel->bind_exchange(
        source      => 'testest',
        destination => 'testest',
        routing_key => '',

        on_success =>
          sub { _on_bind_exchange_success( $condvar, $ar, $channel, @_ ) },
        on_failure      => sub { _error( $condvar, $ar, 'failure',      @_ ) },
        on_read_failure => sub { _error( $condvar, $ar, 'read_failure', @_ ) },
        on_return       => sub { _error( $condvar, $ar, 'return',       @_ ) },
        on_close        => sub { _error( $condvar, $ar, 'close',        @_ ) },
    );
    return;
}

sub _on_bind_exchange_success {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Binded RabbitMQ exchange. ");
    _declare_queue( $condvar, $ar, $channel );
    return;
}

sub _declare_queue {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Declaring RabbitMQ queue... ");

    $channel->declare_queue(
        queue => getConfigValueByKey("rabbitMQName"),

        #    auto_delete => 1,
        #    passive     => 0,
        durable => 1,

        #    exclusive   => 0,
        #    no_ack      => 1,
        #    ticket      => 0,

        on_success =>
          sub { _on_declare_queue_success( $condvar, $ar, $channel, @_ ) },
        on_failure      => sub { _error( $condvar, $ar, 'failure',      @_ ) },
        on_read_failure => sub { _error( $condvar, $ar, 'read_failure', @_ ) },
        on_return       => sub { _error( $condvar, $ar, 'return',       @_ ) },
        on_close        => sub { _error( $condvar, $ar, 'close',        @_ ) },
    );
    return;
}

sub _on_declare_queue_success {

    my ( $condvar, $ar, $channel ) = @_;
    get_Logger()->info("Declared RabbitMQ queue. ");

    my $filename = './data/emailAlerts.json';

    my $json_text = do {
				   open(my $json_fh, "<:encoding(UTF-8)", $filename)
			           or die("Can't open \$filename\": $!\n");
			           local $/;
				   <$json_fh>
			};
    $channel->publish(
   			    exchange => '',
                            routing_key => getConfigValueByKey("rabbitMQName"),
                            body => $json_text,
		      );

    print " [x] Sent $json_text\n";

    $ar->close();
    return;
}

sub _error {

    my ( $condvar, $ar, $type, @error ) = @_;
    get_Logger()->info("Error $type @error ");
    $condvar->send( $condvar, $ar, $type, @error );
    return;

}


