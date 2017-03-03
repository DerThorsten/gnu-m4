# strsignal.m4 serial 3
dnl Copyright (C) 2008, 2009, 2010 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_STRSIGNAL],
[
  dnl Persuade glibc <string.h> to declare strsignal().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  AC_CHECK_DECLS_ONCE([strsignal])
  if test $ac_cv_have_decl_strsignal = no; then
    HAVE_DECL_STRSIGNAL=0
  fi

  AC_CHECK_FUNCS([strsignal])
  if test $ac_cv_func_strsignal = yes; then
    dnl Check if strsignal behaves reasonably for out-of-range signal numbers.
    dnl On Solaris it returns NULL; on AIX 5.1 it returns (char *) -1.
    AC_CACHE_CHECK([whether strsignal always returns a string],
      [gl_cv_func_working_strsignal],
      [AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
            [[#include <string.h>
            ]],
            [[char *s = strsignal (-1);
              return !(s != (char *) 0 && s != (char *) -1);]])],
         [gl_cv_func_working_strsignal=yes],
         [gl_cv_func_working_strsignal=no],
         [case "$host_os" in
            solaris* | aix*) gl_cv_func_working_strsignal=no;;
            *)               gl_cv_func_working_strsignal="guessing yes";;
          esac])])
  else
    gl_cv_func_working_strsignal=no
  fi

  if test "$gl_cv_func_working_strsignal" = no; then
    if test $ac_cv_func_strsignal = yes; then
      REPLACE_STRSIGNAL=1
    fi
    AC_LIBOBJ([strsignal])
    gl_PREREQ_STRSIGNAL
  fi
])

# Prerequisites of lib/strsignal.c.
AC_DEFUN([gl_PREREQ_STRSIGNAL], [
  AC_REQUIRE([AC_DECL_SYS_SIGLIST])
  AC_CHECK_DECLS([_sys_siglist], [], [], [#include <signal.h>])
])
