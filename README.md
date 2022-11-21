# Pex

Pex overides the pipe operator in Elixir and adds the following functionality:

- Automatic result tuple wrapping and unwrapping
- Pipe into maps
- Pipe into lists
- Pipe into a specific function parameter (instead of the first)
- Pipe into function definition
- Skip over error tuples
- Transform error tuples (with `~>`)
- Inspect both result tuples (with simplified labels)
- Catch thrown values
- Rescue exceptions

## Usage

Add `use Pex` to the start of the file. This will overide the default pipe operator and intorduce the `<~` operator.

## Examples

See documentation on Hex
