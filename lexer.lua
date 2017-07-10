local Token = require("token")

local Lexer = {}
Lexer.__index = Lexer

function Lexer.new(input)
    local instance = {}
    setmetatable(instance, Lexer)

    instance.input = input
    instance.inputPos = 1
    instance.tokens = {}

    return instance
end

function Lexer:addToken(tokenType, value)
    self.tokens[#self.tokens + 1] = Token.new(tokenType, value)
end

function Lexer:readNumber()
    local number = ""
    local currentChar = self.input:sub(self.inputPos, self.inputPos)

    while (true) do
        number = number..currentChar

        currentChar = self.input:sub(self.inputPos + 1, self.inputPos + 1)

        if (tonumber(currentChar)) then
            self.inputPos = self.inputPos + 1
        else
            return tonumber(number)
        end
    end
end

function Lexer:run()
    local inputLength = #self.input
    local symbol

    while (self.inputPos <= inputLength) do
        symbol = self.input:sub(self.inputPos, self.inputPos)

        if (tonumber(symbol)) then
            self:addToken(TOKEN_INT, self:readNumber())
        elseif (TOKENS[symbol]) then
            self:addToken(TOKENS[symbol])
        elseif (symbol:match("%S")) then
            error("unexpected symbol '"..symbol.."'")
        end

        self.inputPos = self.inputPos + 1
    end

    self:addToken(TOKEN_EOF)
end

function Lexer:getTokens()
    return self.tokens
end

return Lexer
