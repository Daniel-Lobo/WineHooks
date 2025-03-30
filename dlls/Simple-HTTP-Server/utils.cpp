#include "headers/utils.h"

// Function to split a string by a delimiter
std::vector<std::string> split(const std::string& str, char delimiter) {
    std::vector<std::string> tokens;
    std::stringstream ss(str);
    std::string token;
    while (std::getline(ss, token, delimiter)) {
        tokens.push_back(token);
    }
    if (delimiter == '=' && tokens.size() > 2) {
        for (size_t i = 2; i < tokens.size(); i++) {
            tokens[1] += delimiter + tokens[i];
        }
        // Erase all items after index 1
        tokens.erase(tokens.begin() + 2, tokens.end());
    }
    return tokens;
}

// Function to read the contents of a file
std::string readFile(const std::string& filePath) {
    std::ifstream file(filePath);
    if (!file.is_open()) {
        return "";
    }

    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

std::string toLower(const std::string& str) {
    std::string result = str;
    std::transform(result.begin(), result.end(), result.begin(), ::tolower);
    return result;
}
