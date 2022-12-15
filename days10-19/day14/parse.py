def parse_point(s):
    tokens = s.split(",")
    return (int(tokens[0]), int(tokens[1]))

def main():
    # input_filename = "dummy_input.txt"
    input_filename = "input.txt"

    input_lines = []
    with open(input_filename) as input_file:
        input_lines = [line.strip() for line in input_file]
    
    paths = [] # [(x1, y1, x2, y2)]
    for line in input_lines:
        tokens = line.split(" ")
        arrows = [token for token in enumerate(tokens) if token[1] == "->"]
        for (i, _) in arrows:
            p1 = parse_point(tokens[i-1])
            p2 = parse_point(tokens[i+1])
            paths.append((*p1, *p2))
    
    prolog_preds = [f"line{path}." for path in paths]

    output_filename = "input.pl"
    with open(output_filename, 'w') as output_file:
        output_file.write('\n'.join(prolog_preds))

if __name__ == "__main__":
    main()
