## grouping 1 columns and summarizing 1 column
library(dplyr, warn.conflicts = FALSE)
mtcars %>%
    group_by(cyl) %>%
    summarise(mean = mean(disp), n = n())

result <- aggregate(disp ~ cyl, data = mtcars, FUN = function(x) c(mean = mean(x), n = length(x)))
data.frame(
    cyl = result$cyl,
    mean = result$disp[,"mean"],
    n = result$disp[,"n"]
)

mtcars |> 
    {\(x) split(x$disp, x$cyl)}() |>
    {\(g) mapply(\(d, c) c(cyl = c, mean = mean(d), n = length(d)), g, sort(unique(mtcars$cyl))) |> t() }() |>
    setNames(c("cyl", "mean", "n")) |>
    as.data.frame()

## grouping 2 columns and summarizing 1 column
mtcars %>%
    group_by(cyl, am) %>%
    summarise(mean = mean(disp), n = n())

result <- aggregate(disp ~ cyl + am, data = mtcars, FUN = function(x) c(mean = mean(x), n = length(x)))
data.frame(
    cyl = result$cyl,
    am = result$am,
    mean = result$disp[,"mean"],
    n = result$disp[,"n"]
)


## grouping 2 columns and summarizing 2 column
mtcars %>%
    group_by(cyl, am) %>%
    summarise(mean = mean(disp), mpg = mean(mpg), n = n(), .groups = "drop")


agg <- aggregate(
    disp ~ cyl + am,
    data = mtcars,
    FUN = function(x) c(mean_disp = mean(x), mean_mpg = mean(mtcars$mpg), n = length(x)))
result <- data.frame(
    cyl = agg$cyl,
    am = agg$am,
    mean_disp = agg$disp[,"mean_disp"],
    mean_mpg = agg$disp[,"mean_mpg"],
    n = agg$disp[,"n"]
)
result <- result[order(result$cyl, result$am), ]
result


unique_combinations <- expand.grid(cyl = unique(mtcars$cyl), am = unique(mtcars$am))
result_list <- lapply(1:nrow(unique_combinations), function(i) {
    subset <- mtcars[mtcars$cyl == unique_combinations$cyl[i] & mtcars$am == unique_combinations$am[i], ]
    mean_disp <- mean(subset$disp)
    mean_mpg <- mean(subset$mpg)
    n <- nrow(subset)
    c(cyl = unique_combinations$cyl[i], am = unique_combinations$am[i], mean_disp = mean_disp, mean_mpg = mean_mpg, n = n)
})
result <- do.call(rbind, result_list) |> 
    as.data.frame() |>
    setNames(c("cyl", "am", "mean_disp", "mean_mpg", "n"))
result <- result[order(result$cyl, result$am), ]
result






result <- mtcars |>
    split(f = as.factor(mtcars$cyl)) |>
    lapply(\(x) data.frame(cyl = x$cyl[1], mean = mean(x$disp), n = nrow(x))) |>
    do.call(rbind, args = _)
result

mtcars |>
    split(f = as.factor(mtcars$cyl)) |>
    lapply(\(x) data.frame(cyl = x$cyl[1], mean = mean(x$disp), n = nrow(x))) |>
    do.call(rbind, args = _)




mtcars |>
    by(mtcars$cyl, \(x) data.frame(cyl = x$cyl[[1]], mean = mean(x$disp), n = nrow(x))) |>
    do.call(rbind, args = _)





mtcars %>%
    group_by(cyl, am) %>%
    summarise(mean = mean(disp), mpg = mean(mpg), n = n(), .groups = "drop")

agg <- aggregate(
    disp ~ cyl + am,
    data = mtcars,
    FUN = function(x) c(mean_disp = mean(x), mean_mpg = mean(mtcars$mpg), n = length(x)))
result <- data.frame(
    agg,
    stringsAsFactors = FALSE
)
result <- result[order(result$cyl, result$am), ]
result


agg <- aggregate(
    disp ~ cyl + am,
    data = mtcars,
    FUN = \(x) c(mean_disp = mean(x), mean_mpg = mean(mtcars$mpg), n = length(x))
    )
result <- cbind(
    agg[1:length(agg)-1],
    as.data.frame(agg$disp)) |>
    setNames(c(names(agg[1:length(agg)-1]), "mean_disp", "mean_mpg", "n")) |>
    (\(df) df[order(df$cyl, df$am), ])()
result




result <- aggregate(disp ~ cyl + am, data = mtcars, FUN = \(x) c(mean = mean(x))) |> setNames(c("cyl", "am", "mean")) |>
    merge(aggregate(mpg ~ cyl + am, data = mtcars, FUN = \(x) c(mean = mean(x))) |> setNames(c("cyl", "am", "mpg")), by = c("cyl", "am"))  |>
    merge(aggregate(disp ~ cyl + am, data = mtcars, FUN = \(x) c(n = length(x))) |> setNames(c("cyl", "am", "n")), by = c("cyl", "am"))

expected_output <- mtcars %>%
    group_by(cyl, am) %>%
    summarise(mean = mean(disp), mpg = mean(mpg), n = n(), .groups = "drop") %>% 
    as.data.frame()
expected_output

testthat::expect_identical(result, expected_output)



expected_output <- aggregate(disp ~ cyl + am, data = mtcars, FUN = \(x) c(mean = mean(x))) |> setNames(c("cyl", "am", "mean")) |>
    merge(aggregate(mpg ~ cyl + am, data = mtcars, FUN = \(x) c(mean = mean(x))) |> setNames(c("cyl", "am", "mpg")), by = c("cyl", "am"))  |>
    merge(aggregate(disp ~ cyl + am, data = mtcars, FUN = \(x) c(n = length(x))) |> setNames(c("cyl", "am", "n")), by = c("cyl", "am"))
expected_output

aggregate_merge <- function(x, data, FUN, names) {
    aggregation_results <- Map(function(formula, dat, func, col_names) {
        agg_result <- aggregate(formula, data = dat, FUN = func)
        merge_cols <- setdiff(names(agg_result), c("cyl", "am"))
        setNames(agg_result, c("cyl", "am", col_names))
    }, x, data, FUN, names)
    
    merged_data <- Reduce(function(df1, df2) {
        merge(df1, df2, by = c("cyl", "am"))
    }, aggregation_results)
    
    return(merged_data)
}

result <- aggregate_merge(
    x = list(disp ~ cyl + am, mpg ~ cyl + am, disp ~ cyl + am),
    data = list(mtcars, mtcars, mtcars),
    FUN = list(
        \(x) c(mean = mean(x)),
        \(x) c(mean = mean(x)),
        \(x) c(n = length(x))
    ),
    names = list(
        c("mean"),
        c("mpg"),
        c("n")
    )
)

testthat::expect_identical(result, expected_output)




by = c("cyl", "am")
result <- Reduce(function(df1, df2) merge(df1, df2, by = by), list(
    aggregate(as.formula(paste("disp ~", paste(by, collapse = " + "))), data = mtcars, FUN = \(x) mean(x)) |> setNames(c(by, "mean")),
    aggregate(as.formula(paste("mpg ~", paste(by, collapse = " + "))), data = mtcars, FUN = \(x) mean(x)) |> setNames(c(by, "mpg")),
    aggregate(as.formula(paste("disp ~", paste(by, collapse = " + "))), data = mtcars, FUN = \(x) length(x)) |> setNames(c(by, "n"))
))
testthat::expect_identical(result, expected_output)





# > expected_output
# cyl am     mean      mpg  n
# 1   4  0 135.8667 22.90000  3
# 2   4  1  93.6125 28.07500  8
# 3   6  0 204.5500 19.12500  4
# 4   6  1 155.0000 20.56667  3
# 5   8  0 357.6167 15.05000 12
# 6   8  1 326.0000 15.40000  2


aggregate_with_name <- function(formula, data, FUN, name) {
    result <- aggregate(formula, data = data, FUN = FUN)
    terms <- attr(terms(formula), "term.labels")
    setNames(result, c(terms, name))
}

aggregate_merge <- function(data, formula, FUN, name) {
    aggregate_results <- lapply(seq_along(formula), function(i) {
        aggregate_with_name(formula[[i]], data = data, FUN = FUN[[i]], name = name[[i]])
    })
    Reduce(function(df1, df2) merge(df1, df2, by = attr(terms(formula[[1]]), "term.labels")), aggregate_results)
}

result <- aggregate_merge(
    data = mtcars,
    formula = list(disp ~ cyl + am, mpg ~ cyl + am, disp ~ cyl + am),
    FUN = list(\(x) mean(x), \(x) mean(x), \(x) length(x)),
    name = list("mean", "mpg", "n")
)

# > expected_output
# cyl am     mean      mpg  n
# 1   4  0 135.8667 22.90000  3
# 2   4  1  93.6125 28.07500  8
# 3   6  0 204.5500 19.12500  4
# 4   6  1 155.0000 20.56667  3
# 5   8  0 357.6167 15.05000 12
# 6   8  1 326.0000 15.40000  2

testthat::expect_identical(result, expected_output)




aggregate_merge <- function(data, formula, FUN, name) {
    aggregate_results <- lapply(seq_along(formula), function(i) {
        result <- aggregate(formula[[i]], data = data, FUN = FUN[[i]])
        terms <- attr(terms(formula[[i]]), "term.labels")
        setNames(result, c(terms, name[[i]]))
    })
    Reduce(function(df1, df2) merge(df1, df2, by = attr(terms(formula[[1]]), "term.labels")), aggregate_results)
}

result <- aggregate_merge(
    data = mtcars,
    formula = list(disp ~ cyl + am, mpg ~ cyl + am, disp ~ cyl + am),
    FUN = list(\(x) mean(x), \(x) mean(x), \(x) length(x)),
    name = list("mean", "mpg", "n")
)

# > expected_output
# cyl am     mean      mpg  n
# 1   4  0 135.8667 22.90000  3
# 2   4  1  93.6125 28.07500  8
# 3   6  0 204.5500 19.12500  4
# 4   6  1 155.0000 20.56667  3
# 5   8  0 357.6167 15.05000 12
# 6   8  1 326.0000 15.40000  2

testthat::expect_identical(result, expected_output)



aggregate_with <- function(data, response, by, name, FUN) {
    variables <- attr(terms(as.formula(disp ~ cyl + am)), "variables")
    response <- as.character(variables[attr(terms(as.formula(disp ~ cyl + am)), "response") + 1])
    formula <- paste(response,"~",paste(by, collapse = "+"))
    print(formula)
    result <- aggregate(formula, data = data, FUN = FUN)
    setNames(result, c(by, name))
}


by <- c("cyl", "am")
Reduce(function(df1, df2) merge(df1, df2, by = by), list(
    aggregate_with(mtcars, "disp", by = by, "mean", \(x) mean(x)),
    aggregate_with(mtcars, "mpg", by = by, "mpg", \(x) mean(x)),
    aggregate_with(mtcars, "disp", by = by, "n", FUN = \(x) length(x))
))



# ----------------------------------------


data <- mtcars
by = c("cyl", "am")
result <- transform(
    data, 
    mean = merge(aggregate(disp ~ cyl + am, data, \(x) mean(x)), data, by = by, all.x = TRUE)$disp,
    mpg = merge(aggregate(mpg ~ cyl + am, data, \(x) mean(x)), data, by = by, all.x = TRUE)$mpg,
    n = merge(aggregate(disp ~ cyl + am, data, \(x) length(x)), data, by = by, all.x = TRUE)$disp
)
testthat::expect_identical(result, expected_output)




data <- mtcars
by <- c("cyl", "am")

# Calculate aggregated values using aggregate
mean_disp <- aggregate(disp ~ cyl + am, data = data, FUN = mean)
mean_mpg <- aggregate(mpg ~ cyl + am, data = data, FUN = mean)
n_disp <- aggregate(disp ~ cyl + am, data = data, FUN = length)

# Merge aggregated values back into the original data frame
result <- transform(data,
    mean = merge(mean_disp, data, by = by, all.x = TRUE)$disp.y,
    mpg = merge(mean_mpg, data, by = by, all.x = TRUE)$mpg.y,
    n = merge(n_disp, data, by = by, all.x = TRUE)$disp.y
)

print(result)



aggregate_with_name <- function(formula, data, FUN, name) {
    result <- aggregate(formula, data = data, FUN = FUN)
    terms <- attr(terms(formula), "term.labels")
    setNames(result, c(terms, name))
}

merge_multiple <- function(...) {
    data_list <- list(...)
    Reduce(function(x, y) merge(x, y, all = TRUE), data_list)
}
result <- merge_multiple(
    aggregate(disp ~ cyl + am, mtcars, mean),
    aggregate(mpg ~ cyl + am, mtcars, mean),
    aggregate(disp ~ cyl + am, mtcars, length)
)
print(result)


expected_output <- mtcars %>%
    group_by(cyl, am) %>%
    summarise(mean = mean(disp), mpg = mean(mpg), n = n(), .groups = "drop") %>% 
    as.data.frame()
expected_output
by <- c("cyl", "am")
result <- Reduce(function(df1, df2) merge(df1, df2, by = by), list(
    aggregate(mtcars$disp, mtcars[by], mean) |> setNames(c(by, "mean")),
    aggregate(mtcars$mpg, mtcars[by], mean) |> setNames(c(by, "mpg")),
    aggregate(mtcars$disp, mtcars[by], length) |> setNames(c(by, "n"))
))
result
testthat::expect_identical(result, expected_output)



library(dplyr, warn.conflicts = FALSE)
expected_output <- mtcars %>%
    group_by(cyl) %>%
    summarise(mean = mean(disp), n = n())  %>% 
    as.data.frame()
expected_output
by <- c("cyl")
result <- Reduce(function(df1, df2) merge(df1, df2, by = by), list(
    aggregate(mtcars$disp, mtcars[by], mean) |> setNames(c(by, "mean")),
    aggregate(mtcars$disp, mtcars[by], length) |> setNames(c(by, "n"))
))
result
testthat::expect_identical(result, expected_output)



expected_output <- mtcars %>%
    group_by(cyl) %>%
    summarise(mean = mean(disp), n = n()) 
expected_output
by <- c("cyl")
result <- mtcars |>
    by(mtcars[by], \(x) data.frame(cyl = x$cyl[[1]], mean = mean(x$disp), n = nrow(x))) |>
    do.call(rbind, args = _) |>
    as_tibble()
result 
testthat::expect_identical(result, expected_output)


expected_output <- mtcars %>%
    group_by(cyl, am) %>%
    summarise(mean = mean(disp), mpg = mean(mpg), n = n(), .groups = "drop")
expected_output
by <- c("cyl", "am")
result <- mtcars |>
    by(mtcars[by], \(x) {
        data.frame(
            cyl = x$cyl[[1]],
            am = x$am[[1]],
            mean = mean(x$disp),
            mpg = mean(x$mpg),
            n = nrow(x))
    }) |>
    do.call(rbind, args = _) |>
    (\(df) df[order(df$cyl, df$am), ])() |>
    as_tibble()
result
testthat::expect_identical(result, expected_output)


