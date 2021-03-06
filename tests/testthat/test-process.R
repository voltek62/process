
context("process")

test_that("process works", {

  skip_on_cran()

  dir.create(tmp <- tempfile())
  on.exit(unlink(tmp), add = TRUE)

  win  <- c("ping", "-n", "6", "127.0.0.1")
  unix <- c("sleep", "5")
  cmd <- if (os_type() == "windows") win else unix

  p <- process$new(cmd[1], cmd[-1])
  on.exit(try_silently(p$kill(grace = 0)), add = TRUE)

  expect_true(p$is_alive())
})

test_that("children are removed on kill()", {

  skip_on_cran()

  ## tmp1 will call tmp2, and we'll start tmp1 from process$new
  ## Then we kill the process and see if tmp2 was removed as well
  tmp1 <- tempfile(fileext = ".bat")
  on.exit(unlink(tmp1), add = TRUE)

  tmp2 <- tempfile(fileext = ".bat")
  on.exit(unlink(tmp2), add = TRUE)

  if (os_type() == "windows") {
    cat("cmd /c ", shQuote(tmp2), "\n", sep = "", file = tmp1)
    cat("ping -n 61 127.0.0.1\n", file = tmp2)

  } else {
    cat("sh ", tmp2, "\n", sep = "", file = tmp1)
    cat("sleep 60\n", file = tmp2)
  }

  Sys.chmod(tmp1, "700")
  Sys.chmod(tmp2, "700")

  p <- process$new(tmp1)
  on.exit(try_silently(p$kill(grace = 0)), add = TRUE)

  ## Wait until everything surely starts
  Sys.sleep(1)

  ## Child should be alive now
  pid <- get_pid_by_name(basename(tmp2), children = FALSE)
  expect_true(!is.null(pid))

  ## Kill the process
  p$kill()

  ## Check on the child
  pid <- get_pid_by_name(basename(tmp2), children = FALSE)

  ## If alive, then kill it
  if (!is.null(pid)) pskill(pid)

  ## But it should not have been alive
  expect_null(pid)
})
