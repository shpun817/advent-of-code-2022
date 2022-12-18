if (!require("Rfast")) {
    install.packages("Rfast")
    library("Rfast")
}
if (!require("rlist")) {
    install.packages("rlist")
    library("rlist")
}
library(purrr)

# filename <- "dummy_input.txt"
filename <- "input.txt"

# File reading and parsing
read_file <- function(filename) {
    valves <-
        readChar(filename, file.info(filename)$size) %>%
        strsplit(split = "\r\n") %>%
        unlist %>%
        map(function(line) {
            stmts <- unlist(strsplit(line, ";"))

            name <- unlist(strsplit(stmts[1], " "))[2]
            rate <- strtoi(unlist(strsplit(stmts[1], "="))[2])
            neighbors <- unlist(strsplit(gsub(",", "", stmts[2]), " "))[-(1:5)]

            list(
                name = name,
                rate = rate,
                neighbors = neighbors
            )
        })

    names(valves) <-
    valves %>% map(function(v) v$name)

    valves
}

# Construct the distance matrix
set_mat_names <- function(mat, valves) {
    valve_names <- valves %>% map(function(v) v$name) %>% unlist
    rownames(mat) <- valve_names
    colnames(mat) <- valve_names
    mat
}

construct_dist_mat <- function(valves) {
    num_valves <- length(valves)

    adj_mat <- matrix(NA, num_valves, num_valves) %>% set_mat_names(valves)

    for (valve in valves) {
        for (neighbor in valve$neighbors) {
            adj_mat[valve$name, neighbor] <- 1
        }
    }

    floyd(adj_mat) %>% set_mat_names(valves)
}

find_max_total_pressure <- function(
    time_left,
    at_valve_name,
    valves_to_open,
    dist_mat,
    visited_valves = c(),
    released_so_far = 0
) {
    visited_valves <- append(visited_valves, at_valve_name)

    # Open this one
    released_here <- valves_to_open[[at_valve_name]]$rate * time_left
    valves_to_open[[at_valve_name]]$rate <- 0
    released_so_far <- released_so_far + released_here

    all_paths <- list(list(released = released_so_far, path = visited_valves))

    get_time_needed_to_open <- function(to_valve_name) {
        dist_mat[at_valve_name, to_valve_name] + 1
    }

    valves_to_open <- list.filter(valves_to_open, rate > 0)

    max_total_released <- 0
    for (valve in valves_to_open) {
        time_needed_to_open <- get_time_needed_to_open(valve$name)
        # Base case
        if (time_needed_to_open >= time_left) {
            next
        }
        # DFS
        res <- find_max_total_pressure(
            time_left - time_needed_to_open,
            valve$name,
            valves_to_open,
            dist_mat,
            visited_valves,
            released_so_far
        )
        all_paths <- c(all_paths, res$all_paths)
        if (res$total_released > max_total_released) {
            max_total_released <- res$total_released
        }
    }

    total_released <- released_here + max_total_released
    list(
        total_released = total_released,
        all_paths = all_paths
    )
}

no_collision_in_paths <- function(p1, p2) {
    l1 <- length(p1)
    l2 <- length(p2)
    length(unique(c(p1, p2))) == l1 + l2
}

# Main
main <- function() {
    valves <- read_file(filename)
    dist_mat <- construct_dist_mat(valves)

    max_released_p1 <- find_max_total_pressure(30, "AA", valves, dist_mat)$total_released

    print(paste("Part 1:", max_released_p1))

    res <- find_max_total_pressure(26, "AA", valves, dist_mat)

    all_paths <- res$all_paths
    all_paths <- all_paths %>% map(function(p) {
        p$sorted_path <- p$path %>% sort
        p$sorted_path <- p$sorted_path[-1]
        p
    })
    all_paths <- all_paths[order(all_paths %>% map(function(p) -p$released) %>% unlist)]

    max_released <- 0
    len <- length(all_paths)
    for (i in 1:len) {
        p1 <- all_paths[[i]]
        p2s <- all_paths[-(1:i)]
        for (p2 in p2s) {
            if (!no_collision_in_paths(p1$sorted_path, p2$sorted_path)) {
                next
            }
            combined_released <- p1$released + p2$released
            if (combined_released > max_released) {
                max_released <- combined_released
            }
        }
    }
    print(paste("Part 2:", max_released))
}
main()
