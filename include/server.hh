#ifndef SERVER_HH
#define SERVER_HH

#include <string>
#include <KNM/net.hh>
#include <KNM/data.hh>
#include <KNM/sync.hh>
#include <AISignal/server.hh>
#include <AISignal/channel.hh>
#include "default.hh"

using namespace std;
using namespace KNM;

/**
 * A registry server.
 * Act as a wrapper for the libAIRegistry server, which already
 * include all necessary ressource.
 */
class 	server
{
public:
	server();																/**< Default constructor. */
	server(KTree<AISignal::channel*>*);			/**< Construct + signal db. */
	server(const string &, int);						/**< Construct + address & port. */
	void reset();														/**< Reset intial state. */
	~server();															/**< Destructor. */

	void 			set_address(const string &);	/**< Set network address. */
	void 			set_port(int);								/**< Set network port. */
	void 			start();											/**< Start server process. */
	void 			add_channel(const string &);	/**< Add channel to signal db. */

private:
	void 			init();												/**< Initialize object. */

	KSocket 									link;					/**< Network link. */
	KLog 											log;					/**< Log manager. */
	KTree<AISignal::channel*>	*sigdb;				/**< Tree DB. */
	KMutex 										siglock; 			/**< DB lock. */
};

#endif
