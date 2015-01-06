# Makefile for AI registry tools:
# - regserver (registry server)
# - regclient (registry client)


# Variables
# =========
NAME_SERVER 	=	sigserver
NAME_CLIENT 	= sigclient

PATH_ROOT 		=	.
PATH_SOURCE 	=	./source
PATH_INCLUDE 	=	./include

INSTALL_PATH 	= 	/ocadrone/apps/signal


# Sources
# =======
SRC_SERVER 		= 	$(PATH_SOURCE)/main_server.cpp 	\
									$(PATH_SOURCE)/server.cpp

SRC_CLIENT 		= 	$(PATH_SOURCE)/main_client.cpp


# Compilation options
# ===================
CC 					= 	g++
CFLAGS 			= 	-W -Wall -ansi -pedantic -O3 -std=c++11  -Wl,-rpath /usr/local/lib/
CLIBS 			= 	-lKNM -lAISignal -lpthread


# Rules configuration
# ===================
.PHONY:		help clean 								\
			build build-server build-client 		\
			install install-server install-client 	\
			remove remove-server remove-client

.SILENT:	help clean 								\
			build build-server build-client 		\
			install install-server install-client 	\
			remove remove-server remove-client


# Basic Rules
# ===========
$(NAME): 	help

help:
			@echo "Signal tools Makefile help"
			@echo "=========================="

			@echo "[*] Compilation"
			@echo "    Type 'make build' to build the tools."
			@echo "    To build only server: 'make build-server'"
			@echo "    To build only client: 'make build-client'"
			@echo ""
			@echo "[*] Installation"
			@echo "    Type 'make install' (as root)."
			@echo ""
			@echo "[*] Removing"
			@echo "    Type 'make remove'."
			@echo ""
			@echo "Note: Two libraries are needed:"
			@echo "'libKNM' and 'libAIRegistry'."


# Compilation rules
# =================
build:
			make --no-print-directory build-server
			make --no-print-directory build-client

build-server:
			@echo "--------------------------------------------"
			@echo "Building server"
			@echo "Compiler       : $(CC)"
			@echo "Compiler flags : $(CFLAGS)"
			@echo "Libraries      : $(CLIBS)"
			@echo "--------------------------------------------"
			$(CC) $(CFLAGS) $(CLIBS) $(SRC_SERVER) -I $(PATH_INCLUDE) -o $(NAME_SERVER)

build-client:
			@echo "--------------------------------------------"
			@echo "Building client"
			@echo "Compiler       : $(CC)"
			@echo "Compiler flags : $(CFLAGS)"
			@echo "Libraries      : $(CLIBS)"
			@echo "--------------------------------------------"
			$(CC) $(CFLAGS) $(CLIBS) $(SRC_CLIENT) -I $(PATH_INCLUDE) -o $(NAME_CLIENT)


# Installation rules
# ==================
install:
			if [ ! -d $(INSTALL_PATH) ]; then mkdir -p $(INSTALL_PATH); fi
			make --no-print-directory install-server
			make --no-print-directory install-client

install-server:
			@echo "---"
			@echo "Installing registry server 'regserver'"
			@echo "Installation directory: $(INSTALL_PATH)"
			cp $(NAME_SERVER) $(INSTALL_PATH)
			@echo "Done."

install-client:
			@echo "---"
			@echo "Installing registry client 'regclient'"
			@echo "Installation directory: $(INSTALL_PATH)"
			cp $(NAME_CLIENT) $(INSTALL_PATH)
			@echo "Done."


# Removing & cleaning rules
# =========================
remove:
			make --no-print-directory remove-server
			make --no-print-directory remove-client

remove-server:
			@echo "Removing server"
			rm $(INSTALL_PATH)/$(NAME_SERVER)
			@echo "Done."

remove-client:
			@echo "Removing client"
			rm $(INSTALL_PATH)/$(NAME_CLIENT)
			@echo "Done."

clean:
			if [ -e $(NAME_SERVER) ]; then rm $(NAME_SERVER); fi
			if [ -e $(NAME_CLIENT) ]; then rm $(NAME_CLIENT); fi
