# Architecture decision records

An [architecture
decision](https://cloud.google.com/architecture/architecture-decision-records)
is a software design choice that evaluates:

-   a functional requirement (features).
-   a non-functional requirement (technologies, methodologies, libraries).

The purpose is to understand the reasons behind the current architecture, so
they can be carried-on or re-visited in the future.

## Image prompt

> A black, white, and green Celtic-style gravure of Eagleyeix with a
> touch of Pre-Raphaelite Brotherhood style. Eagleyeix, a Gaulish hero

## Initial idea

Loggers are often not useful in the browser, as the development team
typically cannot access them. Furthermore, these logs may contain private
user information. Instead, we propose a system of metrics to count successful
and unsuccessful events. These metrics should be anonymised and uploaded to
the server, enabling the development team to investigate issues. The metrics
will generally fall into three categories: critical failures (bugs) that
should never occur, poor user experience due to slow response times, and
usage events that help identify features that are either rarely or frequently
used. This approach ensures user privacy while providing valuable insights
for improving the application.
