<div align=right>
<h2 align=right> Xe Softworks </h2>
<img src="https://camo.githubusercontent.com/beb0b377380084d9906e6c317706af49db4463f2fd37818cb7758bd21f5867ed/68747470733a2f2f64726976652e6c756c7a622e696e2f66696c652e7068703f713d363336386165616263663838312e706e672367682d6461726b2d6d6f64652d6f6e6c79" height=130 width=130>
</div>

# luahook
Framework for Serialization of Lua Tables/Metatables in Lua 5.1+

___

## About & Features
This is a simple utility function developers can use for **serialization** of [Lua](https://lua.org) tables/data-structures. This script natively supports Lua 5.1+.

___

## Usage
```lua
-- Basic usage example
-- github.com/XeSoftworks/luahook

local luahook = require(script.hook)

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

local ser = luahook({
    Table = SomeTable,
    FunctionsReturnRaw = true, -- `false` by default
    PrettyPrint = true, -- `false` by default
    IndentCount = 4, -- `0` by default
})

print(ser)
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


