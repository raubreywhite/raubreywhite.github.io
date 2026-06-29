# Shared publication-card builder used by index.qmd (Key Publications) and
# publications.qmd (full list), so both render in the identical .cvpub format.

.esc <- function(x) {
  x <- gsub("[{}]", "", x)
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  gsub(">", "&gt;", x, fixed = TRUE)
}
.norm_doi <- function(doi) {
  if (is.null(doi) || is.na(doi) || !nzchar(doi)) {
    return(NA_character_)
  }
  paste0("https://doi.org/", sub("^https?://doi.org/", "", doi))
}
.get1 <- function(v) {
  if (is.null(v)) {
    return(NA_character_)
  }
  v <- trimws(as.character(v))
  v <- v[nzchar(v)]
  if (length(v)) v[1] else NA_character_
}
.fmt_authors <- function(au) {
  fam <- vapply(au, function(a) paste(a$family, collapse = " "), character(1))
  n <- length(fam)
  if (n == 1) {
    fam
  } else if (n <= 3) {
    paste(paste(fam[-n], collapse = ", "), "&", fam[n])
  } else {
    paste0(fam[1], " et al.")
  }
}
.pub_row <- function(e) {
  jr <- .get1(e$journal)
  if (is.na(jr)) {
    jr <- .get1(e$school)
  }
  if (is.na(jr)) {
    jr <- .get1(e$publisher)
  }
  if (is.na(jr)) {
    jr <- .get1(e$institution)
  }
  list(
    year = suppressWarnings(as.integer(.get1(e$year))),
    title = .esc(.get1(e$title)),
    authors = if (!is.null(e$author)) .esc(.fmt_authors(e$author)) else "",
    journal = if (is.na(jr)) NA_character_ else .esc(jr),
    url = .get1(e$url),
    doi = .norm_doi(.get1(e$doi))
  )
}

# Emit .cvpub cards. keys = NULL -> all entries, year desc. Otherwise the given
# bib keys in order. Year shown once per consecutive group.
pub_cards <- function(d, keys = NULL, number = FALSE) {
  if (is.null(keys)) {
    rows <- lapply(seq_along(d), function(i) .pub_row(d[i]))
    rows <- rows[order(
      -vapply(rows, function(r) r$year, integer(1)),
      seq_along(rows)
    )]
  } else {
    rows <- lapply(keys, function(k) .pub_row(d[k]))
  }
  n <- length(rows)
  prev <- -1L
  for (i in seq_along(rows)) {
    r <- rows[[i]]
    yr <- if (!identical(r$year, prev)) r$year else ""
    prev <- r$year
    num <- if (number) sprintf('<span class="cvpubNum">%d</span>', n - i + 1L) else ""
    jline <- r$authors
    if (!is.na(r$journal)) {
      jline <- paste0(jline, " · <em>", r$journal, "</em>")
    }
    if (!is.na(r$doi)) {
      jline <- paste0(
        jline,
        sprintf(' <a class="pubLink" href="%s">[ DOI ]</a>', r$doi)
      )
    }
    if (!is.na(r$url)) {
      jline <- paste0(
        jline,
        sprintf(' <a class="pubLink" href="%s">[ PDF ]</a>', r$url)
      )
    }
    cat(sprintf(
      '<div class="cvpub"><div class="cvpubYr">%s</div><div><p class="cvpubT">%s</p><p class="cvpubJ">%s</p></div></div>\n',
      yr,
      paste0(num, r$title),
      jline
    ))
  }
}
