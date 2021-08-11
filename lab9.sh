#!/bin/bash
#
# Displays a menu of choices for an address book program and asks user to select a choice.
# Once user inputs selection, the program outputs the user's selection.
#
# @author Viola Yasuda
# @version 9.0 7/29/2021

BOOK="addr.txt"

# Prints the menu for the address book program
do_menu()
{
	echo -e "1. List/Search\n2. Add\n3. Edit\n4. Remove\n5. Quit\n"
	echo -n "Select a choice: "
}

# Prints all contacts in the address book file.
do_list()
{
	echo -e "--Contacts--\n"
	awk -F: '{ print "Name:", $1, $2, "\nAddress:", $3, $4, $5, $6, "\nPhone Number:", $7, \
	"\nCellphone number:", $8, "\nEmail:", $9, "\nPreferred Method of Communication:", $10, \
	"\n"  }' $BOOK
}

# Asks for a search term and prints all contacts related to the term.
do_search()
{
	echo -n "Enter a search term (one word): "
	read searchTerm
	echo
	awk -F: -v pat=$searchTerm '$0~pat { print "Name:", $1, $2, "\nAddress:", $3, $4, $5, $6, \
	"\nPhone Number:", $7, "\nCellphone Number:", $8, "\nEmail:", $9, \
	"\nPreferred Method of Communication:", $10, "\n" }' $BOOK
	echo
}

# Adds a contact to the address book file.
do_add()
{
	echo -n "Enter the contact's first name: "
	read fN
	echo -n "Enter the contact's last name: "
	read lN
	echo -n "Enter the contact's address (number and street): "
	read Addr
	echo -n "Enter the contact's city: "
	read City
	echo -n "Enter the contact's state: "
	read State
	echo -n "Enter the contact's zip code: "
	read Zip
	echo -n "Enter the contact's phone number: "
	read Phone
	echo -n "Enter the contact's cellphone number: "
	read Cell
	echo -n "Enter the contact's email address: "
	read Email
	echo -n "Enter the contact's preferred method of communication: "
	read PMOC
	echo "$fN:$lN:$Addr:$City:$State:$Zip:$Phone:$Cell:$Email:$PMOC" >> $BOOK
	echo
}

# Asks the user for a search term, prints all contacts related to the term, and then
# asks the user to choose one of the contacts. Once the user chooses a contact to
# edit, asks the user to choose a field to edit. Edits the chosen field based on user
# input and updates the contact in the address book file.
do_edit()
{
	echo -n "Enter a search term for the contact to edit (one word): "
	read searchTerm
	possibleContacts="$(fgrep -n $searchTerm $BOOK)"
	if [ -z "$possibleContacts" ]; then
		echo "Error: no contacts contain that search term."
		return
	fi
	echo -e "\n$possibleContacts\n"
	echo -n "Type the number at the start of the line with the contact you wish to edit: "
	read lineNum
	if ( echo "$possibleContacts" | grep "^$lineNum:" ); then
		contact="$( echo "$possibleContacts" | grep "^$lineNum:" | cut -d ":" -f 2- )"
		fN="$( echo "$contact" | cut -d ":" -f 1 )"
		lN="$( echo "$contact" | cut -d ":" -f 2 )"
		addr="$( echo "$contact" | cut -d ":" -f 3 )"
		city="$( echo "$contact" | cut -d ":" -f 4 )"
		state="$( echo "$contact" | cut -d ":" -f 5 )"
		zip="$( echo "$contact" | cut -d  ":" -f 6 )"
		phone="$( echo "$contact" | cut -d ":" -f 7 )"
		cell="$( echo "$contact" | cut -d ":" -f 8 )"
		email="$( echo "$contact" | cut -d ":" -f 9 )"
		pmoc="$( echo "$contact" | cut -d ":" -f 10 )"
		#add code for editing
		echo -e "\n1. First Name\n2. Last Name\n3. Address (Number and Street)"
		echo -e "4. City\n5. State\n6. Zip\n7. Phone\n8. Cell Phone\n9. Email"
		echo -e "10. Preferred Method of Contact\n"
		echo -n "Enter the number of a field above (1-10) to edit: "
		read fieldNum
		case $fieldNum in
			1)
				echo -n "Enter the new first name: "
				read fN;;
			2)
				echo -n "Enter the new last name: "
				read lN;;
			3)
				echo -n "Enter the new address (number and street): "
				read addr;;
			4)
				echo -n "Enter the new city: "
				read city;;
			5)
				echo -n "Enter the new state: "
				read state;;
			6)
				echo -n "Enter the new zip code: "
				read zip;;
			7)
				echo -n "Enter the new phone number: "
				read phone;;
			8)
				echo -n "Enter the new cell phone number: "
				read cell;;
			9)
				echo -n "Enter the new email address: "
				read email;;
			10)
				echo -n "Enter the new preferred method of communication: "
				read pmoc;;
			*)
				echo "Error: invalid choice."
		esac
		sed -i "${lineNum}d" $BOOK
	echo "$fN:$lN:$addr:$city:$state:$zip:$phone:$cell:$email:$pmoc" >> $BOOK
	else
		echo "Error: invalid line number."
	fi
}

# Asks the user for a search term, then asks the user to choose from the returned contacts.
# Once this is done, deletes the contact from the address book file.
do_remove()
{
	echo -n "Enter a search term for the contact to delete (one word): "
	read searchTerm
	possibleContacts="$(fgrep -n $searchTerm $BOOK)"
	if [ -z "$possibleContacts" ]; then 
		echo "Error: no contacts contain that search term."
		return
	fi
	echo -e "\n$possibleContacts\n"
	echo -n "Type the number at the start of the line with the contact you wish to remove: "
	read lineNum
	if ( echo "$possibleContacts" | grep "^$lineNum:" ); then
		sed -i "${lineNum}d" $BOOK
	else
		echo "Error: invalid line number."
	fi
	echo

}

###############################
### Main Script Starts Here ###
###############################

echo -e "-- Address Book --\n"
while [ 1 ]
do
	do_menu
	read input
	case $input in
		1)
			echo -n "Type 1 for List and 2 for Search: "
			read input2
			case $input2 in
				1)
					do_list;;
				2)
					do_search;;
				*)
					echo -e "Invalid input. Type either 1 or 2.\n";;
			esac;;
		2)
			do_add;;
		3)
			do_edit;;
		4)
			do_remove;;
		5)
			echo "Goodbye!"
			break;;
		*)
			echo -e "Invalid input. Type a value between 1 and 5.\n";;
	esac
done
