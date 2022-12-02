from typing import List

def load_input_into_int_inventories(filename: str) -> List[List[int]]:
    str_lines = []
    elf_sep = "-"
    number_sep = " "
    with open(filename) as file:
        str_lines = [line.strip() for line in file]
    str_lines = [line if line != "" else elf_sep for line in str_lines]
    str_inventories = number_sep.join(str_lines).split(number_sep + elf_sep + number_sep)
    return [
            list(map(
                int,
                str_inventory.split(number_sep)
                ))
            for str_inventory in str_inventories
            ]


def main():
    # inventories = load_input_into_int_inventories("dummy_input.txt")
    inventories = load_input_into_int_inventories("input.txt")
    inventory_sums = list(map(sum, inventories))
    max_inventory = max(inventory_sums)
    print("Part 1: ", max_inventory)

    top_n = 3
    sorted_inventory_sums = sorted(inventory_sums, reverse=True)
    top_n_sum = sum(sorted_inventory_sums[:top_n])
    print("Part 2: ", top_n_sum)


if __name__ == "__main__":
    main()
