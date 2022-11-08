# luahook
Framework for Serialization of Lua Metatables in Lua 5.1+

___

## About & Features
This is a simple utility function developers can use for **serialization** of [Lua](https://lua.org) tables/data-structures. This script natively supports Lua 5.1+.

### Features:
- Full serialization and output of basic types `number`, `string`, `table`, `boolean`, and `nil` for keys/values.
- "Pretty Printing" & custom indentation config.
- **(Currently Unimplemented)** `typeof()` support for custom Roblox datatypes such as `Instance`, `UDim`, `Vector`, `DateTime`, etc..
- Raw key/value set with `FunctionsReturnRaw`. (See API below for more info)

___

## Usage
```lua
-- Basic usage example
-- github.com/XeSoftworks/luahook

local LuaEncode = require(script.LuaEncode)

local SomeTable = {
    foo = "bar",
    baz = {
        ["i love men"] = "i am racist",
        [5] = "qux",
        [{123, 456, 789}] = {
            1,
            2,
            "goodbye"
        },
        syn = "shitballs",
        "example",
    },
}

local Encoded = LuaEncode({
    Table = SomeTable,
    FunctionsReturnRaw = true, -- `false` by default
    PrettyPrint = true, -- `false` by default
    IndentCount = 4, -- `0` by default
})

print(Encoded)
```

Expected Output:
```lua
{
    baz = {
        "example",
        syn = "tax",
        [{123, 456, 789}] = {
            1,
            2,
            "goodbye"
        },
        [5] = "qux",
        ["hi mom"] = "hello world"
    },
    foo = "bar"
}
```

___

## API
```lua
<string> hook(<table?: {}> args)
```
| Argument | Type | Description |
|----------|------|-------------|
| Table | `<table?: {}>` | Input table to serialize and return. |
| FunctionsReturnRaw | `<bool?: false>` | If functions in said table return back a "raw" value to place in the output as the key/value. |
| PrettyPrint | `<bool?: false>` | Whether or not the output should use "pretty printing". |
| IndentCount | `<number?: 0>` | The amount of "spaces" that should be indented per entry. |

___


