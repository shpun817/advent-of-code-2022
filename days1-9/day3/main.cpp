#include <algorithm>
#include <iterator>
#include <iostream>
#include <fstream>
#include <string>
#include <set>

// Return '\0' if there is no shared item (which is against assumption)
char find_shared_item(const std::string& line) {
    size_t compartment_size = line.length() >> 1;
    const std::string first_compartment = line.substr(0, compartment_size);
    const std::string second_compartment = line.substr(compartment_size);
    std::set<char> items_in_first;
    for (const char& c: first_compartment) {
        items_in_first.insert(c);
    }
    for (const char& c: second_compartment) {
        if (items_in_first.find(c) != items_in_first.end()) {
            return c;
        }
    }
    return '\0';
}

int find_priority_of_item(char item) {
    if ('a' <= item && item <= 'z') {
        return item - 'a' + 1;
    }
    if ('A' <= item && item <= 'Z') {
        return item - 'A' + 27;
    }
    return -1;
}

// Part 2
class BadgeFinder {
    int elf_count;
    std::set<char> item_set;

    void reset() {
        elf_count = 0;
        item_set.clear();
    }
  public:
    BadgeFinder(): elf_count{0}, item_set{} {}
    
    // Return true if a badge is found
    bool insert_rucksack(char* badge, const std::string& rucksack) {
        if (elf_count == 2) {
            *badge = '\0';
            // The first common item is the badge
            for (const char& c: rucksack) {
                if (item_set.find(c) != item_set.end()) {
                    *badge = c;
                    break;
                }
            }
            reset();
            return true;
        }

        if (elf_count == 0) {
            // Just find all unique items
            for (const char& c: rucksack) {
                item_set.insert(c);
            }
        } else if (elf_count == 1) {
            // Limit item_set to only include items found here
            std::set<char> items_in_rucksack;
            for (const char& c: rucksack) {
                items_in_rucksack.insert(c);
            }
            
            std::set<char> intersection;
            std::set_intersection(
                item_set.begin(), item_set.end(),
                items_in_rucksack.begin(), items_in_rucksack.end(),
                std::inserter(intersection, intersection.begin())
            );

            item_set = intersection;
        }
        ++elf_count;
        return false;
    }
};

int main() {
    // std::ifstream file("dummy_input.txt");
    std::ifstream file("input.txt");
    std::string line;
    int total_priority = 0;
    int total_batch_priority = 0;
    BadgeFinder badgeFinder;
    while (file >> line) {
        if (line.empty()) {
            continue;
        }
        char shared_item = find_shared_item(line);
        if (shared_item == '\0') {
            std::cerr << "No shared item found for line \"" << line << "\"\n";
            return 1;
        }
        int priority = find_priority_of_item(shared_item);
        if (priority < 1) {
            std::cerr << "Invalid shared item \"" << shared_item << "\"\n";
        }
        total_priority += priority;

        char badge;
        if (badgeFinder.insert_rucksack(&badge, line)) {
            if (badge == '\0') {
                std::cerr << "No badge found for group ending at line \"" << line << "\"\n";
                return 1;
            }
            int badge_priority = find_priority_of_item(badge);
            if (badge_priority < 1) {
                std::cerr << "Invalid badge \"" << badge << "\"\n";
            }
            total_batch_priority += badge_priority;
        }
    }
    std::cout << "Part 1: " << total_priority << '\n';
    std::cout << "Part 2: " << total_batch_priority << '\n';
}
