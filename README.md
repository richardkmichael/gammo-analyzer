# Analysis of output from the GAMMO (Google Apps Migration for Microsoft Outlook)

## Instroduction

The `GAMMO` writes log files (`trace-.....log`) for each migration, but
it also generates an SQLite database.

This database contains information about migration failures of various
classes of "messages": email, contact and calender items are each a
"message" with particular attributes.

This tool queries the database and writes a CSV report for each class
of message.  The resulting CSV can be loaded into any spreadsheet
program (Google Apps, Excel, etc.) to filter, sort, and generally
inspect the failures.

# Usage

```shell
$ ruby analyze.rb -h

Usage: analyze [options]
    -d, --database=SQLITEDB          Path to SQLITE database file.  (Required.)
    -o, --output=DIRECTORY           Directory to write report files.  (Default: With the DB file.
    -f, --format=FORMAT              Format to write report files.  (Default: CSV)
    -h, --help                       Show this message.
```

## Resources

* FIXME: Write and link to blog post on Exchange 2007 SP1 -> Google Apps migration: experiences and best-practices

## Roadmap

* Gemify and create a standalone `bin`
* Improve output "summary" with answers to common questions
* Tests (minitest)
* Light query language on the command line, e.g. '--filter-address=foo@example.com'
* Add / augment with trace log file information
* Output JSON ([re]implement as Presenters)
* Wrap with web UI for sorting, filtering etc. (eliminate spreadsheet program)


## Contributions

I will happily accept feature requests.

I will only accept pull requests if you can prove you wrote the code
while listening to [Night Fever](https://www.youtube.com/watch?v=hLaSNF-r2gk), or an appropriately groovy track.  Include in your PR, or be ignored.
