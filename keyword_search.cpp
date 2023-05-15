#include <vector>
#include <string>
#include <omp.h>

bool* sentences_contain_keywords(const std::vector<std::string>& sentences, const std::vector<std::string>& keywords) {
    size_t total_size = sentences.size() * keywords.size();
    bool* result = new bool[total_size]();

    #pragma omp parallel for
    for (long long i = 0; i < total_size; ++i) {
        long long sentence_index = i / keywords.size();
        long long keyword_index = i % keywords.size();
        const std::string& sentence = sentences[sentence_index];
        const std::string& keyword = keywords[keyword_index];
        if (sentence.find(keyword) != std::string::npos) {
            result[i] = true;
        }
    }

    return result;
}
