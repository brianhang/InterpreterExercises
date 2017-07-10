local Token = require("token")
local Lexer = require("lexer")
local Parser = require("parser")

Interpreter = {}
Interpreter.__index = Interpreter

local BINARY_OPERATIONS = {
    ["+"] = function(a, b) return a + b end,
    ["-"] = function(a, b) return a - b end,
    ["*"] = function(a, b) return a * b end,
    ["/"] = function(a, b) return a / b end,
    ["^"] = function(a, b) return a ^ b end
}

local UNARY_OPERATIONS = {
    ["-"] = function(a) return -a end
}

function Interpreter.new(input)
    local instance = {}
    setmetatable(instance, Interpreter)

    instance.input = input

    return instance
end

function Interpreter:run()
    local lexer = Lexer.new(self.input)
    lexer:run()

    local parser = Parser.new(lexer:getTokens())
    parser:run()

    return self:traverse(parser:getAST())
end

function Interpreter:traverse(node)
    if (node.left and node.right) then
        local op1 = self:traverse(node.left)
        local op2 = self:traverse(node.right)
        
        return BINARY_OPERATIONS[node.value](op1, op2)
    elseif (node.left and not node.right) then
        local op = self:traverse(node.left)

        return UNARY_OPERATIONS[node.value](op)
    end

    return node.value
end

do
    local i = Interpreter.new("1 - - -1^4")
    print("Got: "..i:run())
end

return Interpreter
