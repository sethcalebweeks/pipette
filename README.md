# Pipette

## Usage

Add `use Pipette` to the start of the file. This will take care of overiding the default pipe operator.

## Examples

### Bonus: simple lambdas

Instead of writing inline function like this:

```elixir
fn val -> val * val end
```

You can simply write this:

```elixir
val ~> val * val
```

### Normal pipes

```elixir
%{hello: "world"}
|> Map.get(:hello) # {:ok, "world"}
```

### Pipe into a map

```elixir
# Pipe to value
"world"
|> %{hello: &1} # {:ok, %{hello: "world"}}

# Pipe to key
:hello
|> %{&1 => "world"} # {:ok, %{hello: "world"}}
```

### Pipe into a list

```elixir
# Pipe to position in list
2
|> [1, &1, 3] # {:ok, [1, 2, 3]}

# Pipe to head of list
1
|> [&1 | [2, 3]] # {:ok, [1, 2, 3]}

# Pipe to tail of list
[2, 3]
|> [1 | &1] # {:ok, [1, 2, 3]}
```

### Pipe to specific position

```elixir
%{hello: "world"}
|> Map.get(:hello)
|> Map.put(%{}, :goodbye, &1) # {:ok, %{goodbye: "world"}}
```

### Pipe into function definition

```elixir
%{hello: "world"}
|> Map.get(:hello)
|> value ~> "hello " <> value # {:ok, "hello world"}
```

### Ignore error tuples

```elixir
{:error, "Something went wrong"}
|> Map.get(:hello)
|> Map.put(%{}, :goodbye, &1) # {:error, "Something went wrong"}
```

### Transform error tuples

```elixir
# Leave as error
{:error, "Something went wrong"}
|> Tuple.to_list
<~ error ~> error <> "\nInfo" # {:error, "Something went wrong\nInfo"}

# Recover to ok tuple
{:error, "Something went wrong"}
<~ _ ~> {:ok, "recovered"}
|> _ ~> "hello world" # {:ok, "hello world"}
```

### Inspect error and ok tuples

```elixir
{:error, "Something went wrong"}
|> IO.inspect("error") # With label
<~ _ ~> {:ok, "recovered"}
|> IO.inspect # Without label
|> _ ~> "hello world"
```
