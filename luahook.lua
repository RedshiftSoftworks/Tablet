
-- Xe Softworks 2022
--                                                                                                   
--                              :~!!:                                                                  
--                           ~YB&@@@&Y                                                                 
--                         !B@@@@@@@@@G:                                                               
--                        .&@@@@@@@@@@@#^                                                              
--                         ?@@@@@@@@@@@@&~                                                             
--                          !&@@@@@@@@@@@@7                            .                               
--                           ^B@@@@@@@@@@@@J                        ^5##B57^                           
--                            .P@@@@@@@@@@@@5                      ?&@@@@@@@G?.                        
--                              J@@@@@@@@@@@@G.                   5@@@@@@@@@@@#:                       
--                               !&@@@@@@@@@@@B:                :G@@@@@@@@@@@@5.                       
--                                ^B@@@@@@@@@@@#~              !&@@@@@@@@@@@@J                         
--                                 .P@@@@@@@@@@@&!            J@@@@@@@@@@@@#~                          
--                                   J@@@@@@@@@@@@?         .P@@@@@@@@@@@@P.                           
--                                    !&@@@@@@@@@@@Y       ^B@@@@@@@@@@@@J                             
--                                     ^B@@@@@@@@@@@P.    7&@@@@@@@@@@@#~                              
--                                      .P@@@@@@@@@@@B^  J@@@@@@@@@@@@P:                               
--                                        J@@@@@@@@@@@&?P@@@@@@@@@@@&?                                 
--                                         !&@@@@@@@@@@@@@@@@@@@@@@B^                                  
--                                          ^B@@@@@@@@@@@@@@@@@@@@5.                                   
--                                           .5@@@@@@@@@@@@@@@@@&7                                     
--                                             Y@@@@@@@@@@@@@@@G^                                      
--                                              G@@@@@@@@@@@@@B.                                       
--                                              B@@@@@@@@@@@@@G                                        
--                                            .P@@@@@@@@@@@@@@@5                                       
--                                           ^B@@@@@@@@@@@@@@@@@G:                                     
--                                          7&@@@@@@@@@@@@@@@@@@@#^                                    
--                                         Y@@@@@@@@@@@@@@@@@@@@@@&!                                   
--                                       :G@@@@@@@@@@@&#@@@@@@@@@@@@?                                  
--                                      ~#@@@@@@@@@@@P: J@@@@@@@@@@@@J                                 
--                                     ?@@@@@@@@@@@@Y    ?@@@@@@@@@@@@5.                               
--                                   .5@@@@@@@@@@@@?      !&@@@@@@@@@@@G:                              
--                                  :G@@@@@@@@@@@&!        ^#@@@@@@@@@@@B:                             
--                                 !&@@@@@@@@@@@B^          :B@@@@@BY!~~~:                             
--                                J@@@@@@@@@@@@P.            :G@@B~  7GB#P~                            
--                              .5@@@@@@@@@@@@Y               .GG.  Y@@@@@&.                           
--                             ^B@@@@@@@@@@@@?                 ..   !777777.                           
--                            !&@@@@@@@@@@@&!                      .?JJJJJJYYY?                        
--                           7@@@@@@@@@@@@#^                        G@@@@@@@@@@Y                       
--                          J@@@@@@@@@@@@B:                         :B@@@@@@&?^GY                      
--                         Y@@@@@@@@@@@@G.                            !J55Y7:.J&@Y                     
--                        Y@@@@@@@@@@@@P.                            .^::^~75&@@@@J                    
--                       ^@@@@@@@@@@@@P                               5@@@@@@@@@@@@~                   
--                        Y#@@@@@@@@@P.                                5@@@@@@@@@@B:                   
-- --                        .~!?JJYYY!                                   ~J55YYYY?~.      
-- -- https://xesoft.works      
local function hook(args)
    args = args or {}
    local Table = args.Table or {}
    local FunctionsReturnRaw = args.FunctionsReturnRaw or false
    local PrettyPrint = args.PrettyPrint or false
    local IndentCount = args.IndentCount or 0
    local StackLevel = args._StackLevel or 1

    local IndentString = string.rep(" ", IndentCount)
    local NewEntryString = (PrettyPrint == true and "\n") or ""

    IndentString = (PrettyPrint == true and string.rep(IndentString, StackLevel)) or IndentString

    local Output = "{" .. NewEntryString
    if PrettyPrint == true then
        Output = Output .. IndentString
    end

    local KeyIndex = 1
    for Key, Value in next, Table do
        local ExplicitlyDefinedKeyAdded = false

        local KeyTypeCases = {
            ["number"] = function()
                if Key == KeyIndex then
                    KeyIndex = KeyIndex + 1
                else
                    KeyIndex = Key
                    Output = Output .. string.format("[%d]", Key)
                    ExplicitlyDefinedKeyAdded = true
                end
            end,
            ["string"] = function()
                if string.match(Key, "^[A-Za-z_][A-Za-z0-9_]*$") then
                    Output = Output .. Key
                else
                    Output = Output .. string.format("[%q]", Key)
                end

                ExplicitlyDefinedKeyAdded = true
            end,
            ["table"] = function()
                Output = Output .. string.format(
                    "[%s]",
                    hook({
                        Table = Key,
                        FunctionsReturnRaw = FunctionsReturnRaw,
                        PrettyPrint = false,
                        IndentCount = (PrettyPrint == false and IndentCount) or 1,
                        _StackLevel = 1,
                    })
                )

                ExplicitlyDefinedKeyAdded = true
            end,
            ["boolean"] = function()
                local BoolAsString = (Key == true and "true") or (Key == false and "false")

                Output = Output .. string.format(
                    "[%s]",
                    BoolAsString
                )

                ExplicitlyDefinedKeyAdded = true
            end,
            ["nil"] = function()
                Output = Output .. string.format("[%s]", "nil")
                ExplicitlyDefinedKeyAdded = true
            end,
            ["function"] = function()
                if FunctionsReturnRaw then
                    Output = Output .. tostring(Key())
                end

                ExplicitlyDefinedKeyAdded = true
            end,
        }

        local ValueTypeCases = {
            ["number"] = function()
                Output = Output .. Value
            end,
            ["string"] = function()
                Output = Output .. string.format("%q", Value)
            end,
            ["table"] = function()
                Output = Output .. hook({
                    Table = Value,
                    FunctionsReturnRaw = FunctionsReturnRaw,
                    PrettyPrint = PrettyPrint,
                    IndentCount = IndentCount,
                    _StackLevel = StackLevel + 1,
                })
            end,
            ["boolean"] = function()
                Output = Output .. ((Value == true and "true") or (Value == false and "false"))
            end,
            ["nil"] = function()
                Output = Output .. "nil"
            end,
            ["function"] = function()
                Output = Output .. tostring(Value())
            end,
        }

        local KeyType = type(Key)
        local ValueType = type(Value)

        if KeyTypeCases[KeyType] and ValueTypeCases[ValueType] then
            KeyTypeCases[KeyType]()

            if ExplicitlyDefinedKeyAdded then
                Output = Output .. ((PrettyPrint == true and " = ") or "=")
            end

            ValueTypeCases[ValueType]()
        end

        if next(Table, Key) then
            Output = Output .. "," .. NewEntryString .. IndentString
        else
            Output = Output .. NewEntryString
        end
    end

    local EndingIndentString = (#IndentString > 0 and string.sub(IndentString, 1, -IndentCount - 1)) or ""
    Output = Output .. EndingIndentString ..  "}"
    return Output
end

return hook
