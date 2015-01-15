#include <iostream>
#include <KNM/base.hh>
#include <KNM/net.hh>
#include <AISignal/client.hh>

using namespace std;
using namespace KNM;
using namespace AISignal;

void 			usage()
{
	cerr << "usage: sigclient <address> <port>" << endl;
	exit(1);
}

void 			cmd_help()
{
	cerr << "commands: subscribe, send, fetch" << endl;
}

void 			cmd_subscribe(const string &args, AISignal::client *sigclient)
{
	string 	*channel;

	channel = KUtils::cut(args, ' ', 1);
	if (channel->size() > 0)
	{
		cout << "subscribing to channel " << *channel << endl;
		sigclient->subscribe(*channel);
	}
	else
		cout << "syntax: subscribe <channel-path>" << endl;
}

void 			cmd_send(const string &args, AISignal::client *sigclient)
{
	string 	*channel;
	string 	*data;

	channel = KUtils::cut(args, ' ', 1);
	data    = KUtils::cut(args, ' ', 2);
	if (channel->size() > 0 && data->size() > 0)
	{
		cout << "send '" << *data << "' on '" << *channel << "'" << endl;
		sigclient->send(*channel, *data);
	}
	else
		cout << "syntax: send <channel-path> <data>" << endl;

}

void 			cmd_fetch(const string &args, AISignal::client *sigclient)
{
	string 						*channel;
	string 						*mode;
	AISignal::signal 	sigin;

	channel = KUtils::cut(args, ' ', 1);
	mode    = KUtils::cut(args, ' ', 2);

	if (channel->size() > 0 && mode->size() > 0)
	{
		if (*mode == "FIFO" || *mode == "fifo")
			sigin = sigclient->fetch(*channel, AISignal::mode::FIFO);
		else if (*mode == "LIFO" || *mode == "lifo")
			sigin = sigclient->fetch(*channel, AISignal::mode::LIFO);
		else if (*mode == "SINGLE" || *mode == "single")
			sigin = sigclient->fetch(*channel, AISignal::mode::SINGLE);
		else
		{
			cerr << "invalid mode: FIFO, LIFO or SINGLE expected" << endl;
			return;
		}
		cout << sigin.data << endl;
	}
	else
		cout << "syntax: fetch <channel-path> <FIFO|LIFO>" << endl;

}

void 			shell(AISignal::client *sigclient)
{
	string 	line;
	string 	*command;

	while (true)
	{
		cout << "signal-client: ";
		std::getline(std::cin, line);
		command = KUtils::cut(line, ' ', 0);

		if (*command == "subscribe")
			cmd_subscribe(line, sigclient);
		else if (*command == "send")
			cmd_send(line, sigclient);
		else if (*command == "fetch")
			cmd_fetch(line, sigclient);
		else if (*command == "help")
			cmd_help();
		else if (*command == "exit" || *command == "quit")
			return;
		else
		{
			cerr << "unknow command '" << *command << "'" << endl;
			cmd_help();
		}
	}
}

int 								main(int ac, char **av)
{
	AISignal::client 	sigclient;

	if (ac < 3)
		usage();

	sigclient.set_address(av[1]);
	sigclient.set_port(KUtils::to_int(av[2]));

	try
	{
		sigclient.connect();
		shell(&sigclient);
	}
	catch(const KError &error)
	{
		error.dump();
	}
	return 0;
}
