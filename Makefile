# Makefile for the OCADrone 'signal' IPC tool.
# Signal version  : 2.0.0
# Makefile version: 4
#
# Author       : Jean-Philippe Clipffel
# Creation date: 29/04/2014
# Last modified: 20/01/2015
#
# About signal IPC tool versions
# ------------------------------
# Format : Major.Medium.Minor
# Major  : New versions, include new functionnalities
# Medium : Small API update, functionnalities enable / disabled
# Minor  : Simple security patches and stability updates
#
# License GNU LGPL 2.1 and later
# ------------------------------
#
# Signal
# Copyright (C) 2015 Jean-Philippe Clipffel
# Email: jp.clipffel@gmail.com
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
# USA



# Variables
# =========
NAME_SERVER 		=		sigserver
NAME_CLIENT 		= 	sigclient

PATH_ROOT 			=		.
PATH_SOURCE 		=		./source
PATH_INCLUDE 		=		./include

INSTALL_PATH 		= 	/ocadrone/apps/signal


# Sources
# =======
SRC_SERVER 			= 	$(PATH_SOURCE)/main_server.cpp 	\
										$(PATH_SOURCE)/server.cpp

SRC_CLIENT 			= 	$(PATH_SOURCE)/main_client.cpp

SRC_CFGFILE 		=		$(PATH_ROOT)/sigserver.cfg

# Compilation options
# ===================
CC 							= 	g++
CFLAGS 					= 	-W -Wall -ansi -pedantic -O3 -std=c++11
CLIBS 					= 	-lKNM -lAISignal -lpthread


# Rules configuration
# ===================
.PHONY:		help clean 															\
					build build-server build-client 				\
					install install-server install-client 	\
					remove remove-server remove-client

.SILENT:	help clean 															\
					build build-server build-client 				\
					install install-server install-client 	\
					remove remove-server remove-client


# Basic Rules
# ===========
$(NAME): 	help

help:
			@echo "Signal tools Makefile help"
			@echo "--------------------------"
			@echo ""
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
			@echo "Note: The library 'libKNM' is needed."


# Compilation rules
# =================
build:
			make --no-print-directory build-server
			make --no-print-directory build-client

build-server:
			@echo "Compiling signal server"
			@echo "-----------------------"
			@echo "Compiler       : $(CC)"
			@echo "Compiler flags : $(CFLAGS)"
			@echo "Libraries      : $(CLIBS)"
			$(CC) $(CFLAGS) $(CLIBS) $(SRC_SERVER) -I $(PATH_INCLUDE) -o $(NAME_SERVER)

build-client:
			@echo "Compiling signal client"
			@echo "-----------------------"
			@echo "Compiler       : $(CC)"
			@echo "Compiler flags : $(CFLAGS)"
			@echo "Libraries      : $(CLIBS)"
			$(CC) $(CFLAGS) $(CLIBS) $(SRC_CLIENT) -I $(PATH_INCLUDE) -o $(NAME_CLIENT)


# Installation rules
# ==================
install:
			if [ ! -d $(INSTALL_PATH) ]; then mkdir -p $(INSTALL_PATH); fi
			make --no-print-directory install-server
			make --no-print-directory install-client

install-server:
			@echo "---"
			@echo "Installing signal server"
			@echo "Installation directory: $(INSTALL_PATH)"
			cp $(NAME_SERVER) $(INSTALL_PATH)
			if [ -e $(SRC_CFGFILE) ]; then cp $(SRC_CFGFILE) $(INSTALL_PATH); fi
			@echo "Done."

install-client:
			@echo "---"
			@echo "Installing signal client"
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
