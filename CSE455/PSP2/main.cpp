#include "reader.h"

int main() {
	std::cout << "Enter the name of the file to be read\n";
	std::string str = "";
	std::cin >> str;

	reader new_reader(str);
	int number_of_lines = new_reader.TotalLinesOfCode();
	std::map<std::string, int> member_map =  new_reader.MemberLinesOfCode();

	std::cout << "The total number of lines from " << str << " is \t" << number_of_lines << "\n";
	
	for(int num = 0; num < member_map.size(); num++) {
	  std::cout << new_reader.names[num] << "\t\t" << member_map[new_reader.names[num]] << "\n";
	}

	return 0;
}
