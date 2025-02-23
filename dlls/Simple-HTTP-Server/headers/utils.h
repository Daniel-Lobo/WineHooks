#pragma once
// C++ Libraries
#include <string>
#include <vector>
#include <sstream>
#include <fstream>
#include <algorithm>

// Function to split a string by a delimiter
std::vector<std::string> split(const std::string& str, char delimiter);

// Function to read the contents of a file
std::string readFile(const std::string& filePath);

std::string toLower(const std::string& str);