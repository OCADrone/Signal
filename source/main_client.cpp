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

int 								main(int ac, char **av)
{
	string 						resp;
	string 						cmd;
	string 						path;
	string 						data;
	AISignal::client 	sigclient;

	if (ac < 3)
		usage();

	sigclient.set_address(av[1]);
	sigclient.set_port(KUtils::to_int(av[2]));

	try
	{
		sigclient.connect();

		while (true)
		{
			resp.clear();

			// get command
			cout << "command (fetch|send): ";
			cin >> cmd;

			// === SEND ===
			if (cmd == "send")
			{
				cout << "path: ";
				cin >> path;

				cout << "data: ";
				cin >> data;

				sigclient.send(path, data);
			}

			// === FETCH ===
			else if (cmd == "fetch")
			{
				cout << "path: ";
				cin >> path;

				resp = sigclient.fetch(path);
				cout << "response: " << resp << endl;
			}
		}

	}
	catch(const KError &error)
	{
		cerr << "ERROR: ";
		error.dump();
	}

	if (resp.size() > 0)
		cout << resp << endl;
	return 0;
}
