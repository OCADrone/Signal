#include <KNM/base.hh>
#include <KNM/sys/KFS.hh>
#include <KNM/parse/KConfig.hh>
#include <default.hh>
#include <server.hh>

using namespace std;
using namespace KNM;

void 		usage()
{
	cerr << "usage: sigserver option..." << endl;
	cerr << "options: " << endl;
	cerr << "-c | --config  : Configuration file path" << endl;
	cerr << "-a | --address : Address to listen on"    << endl;
	cerr << "-p | --port    : Port to bind on"         << endl;
	exit(1);
}

int 				main(int ac, char **av)
{
	server 		host;
	KConfig 	config;
	KFS 			shell;

	if (config.is_flag(ac, av, 'h', "help"))
		usage();

	// Setup configuration source
	config.include(ac, av);
	if (config.is_option(ac, av, 'c', "config"))
		config.include(*config.find_s(ac, av, 'c', "config"));
	else
	{
		if (shell.is_file(SERVER_DEFAULT_CFGFILE))
			config.include(SERVER_DEFAULT_CFGFILE);
	}

	// Setup configuration rules
	config.add_rule(new KConfig::option(".network.address", 'a', "address",        1, KConfig::MANDATORY, KConfig::PREFER_ARGS));
	config.add_rule(new KConfig::option(".network.port",    'p', "port",           1, KConfig::MANDATORY, KConfig::PREFER_ARGS));
	config.add_rule(new KConfig::option(".channels.size",   ' ', "channels-size",  1, KConfig::OPTIONNAL, KConfig::PREFER_ARGS, "1"));
	config.add_rule(new KConfig::option(".channels.build",  ' ', "channels-build", 1, KConfig::OPTIONNAL, KConfig::PREFER_ARGS, "true"));

	// Load configuration
	try
	{
		config.load();
	}
	catch(const KError &error)
	{
		error.dump();
		usage();
	}


	// Setup server using configuration
	host.set_address(config.find_s(".network.address"));
	host.set_port(KUtils::to_int(config.find_s(".network.port")));

	try
	{
		host.start();
	}
	catch(const KError &error)
	{
		error.dump();
		return 1;
	}

	return 0;
}
