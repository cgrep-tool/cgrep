# cgrep

Easily usable column-based grep tool with advanced expression, regex and varaibles. An intutive alternative to awk.

# Example

```bash
cgrep "$3 = 'Sweden'" cities.csv
```

# Relational operators

cgrep supports wide range of relational operators.
  * Equals `=`
  * Not equals `!=` `<>`
  * Less than `<`
  * Less than or equal`<=`
  * Greater than `>`
  * Greater than or equal `>=`
  * Like `%%`

```bash
TODO
```

# Multiple conditions

Use `&&` and `||` logical operators to use multiple conditions to filter rows.

```bash
TODO
```

# Built-in types

## Date

> TODO

## Interval

> TODO

# Skip header

> TODO

# Data files

*cities.csv*:
```csv
echo -e "Stockholm,Sweden\r\nBerlin,Germany\r\nMalmö,Sweden\r\nGöteborg,Sweden\r\nMunich,Germany\r\nOslo,Norway" > cities.csv
```