#include "server.hh"

server::server()
{
	init();
}

server::server(const string &_address, int _port)
{
	init();
	link.set_address(_address);
	link.set_port(_port);
}

void 	server::reset()
{
	init();
}

server::~server()
{
	reset();
}

void 	server::set_address(const string &_address)
{
	link.set_address(_address);
}

void 	server::set_port(int _port)
{
	link.set_port(_port);
}

void 								server::start()
{
	KSocket 					*csock = NULL;
	AISignal::server 	*cserv = NULL;

	try
	{
		// Initialize network link
		link.endpoint();
		link.listen();

		// Wait and connect a client
		while (1)
		{
			csock = link.accept();
			cserv = new AISignal::server(csock, &sigdb, &siglock);
			cserv->start();
		}
	}
	catch(const KError &error)
	{
		error.dump();
	}
}

void 	server::init()
{
	// Configure network link
	link.set_address(SERVER_DEFAULT_ADDRESS);
	link.set_port(KUtils::to_int(SERVER_DEFAULT_PORT));
	link.set_type(KSocket::TCP4);
}
