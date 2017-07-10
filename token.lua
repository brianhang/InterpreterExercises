TOKEN_INT     = 1
TOKEN_PLUS    = 2
TOKEN_MINUS   = 3
TOKEN_TIMES   = 4
TOKEN_DIV     = 5
TOKEN_EOF     = 6
TOKEN_LPARENS = 7
TOKEN_RPARENS = 8
TOKEN_CARET   = 9

TOKENS = {
    ["+"] = TOKEN_PLUS,
    ["-"] = TOKEN_MINUS,
    ["*"] = TOKEN_TIMES,
    ["/"] = TOKEN_DIV,
    ["("] = TOKEN_LPARENS,
    [")"] = TOKEN_RPARENS,
    ["^"] = TOKEN_CARET
}

local Token = {}
Token.__index = Token

function Token.new(tokenType, value)
    local instance = {}
    setmetatable(instance, Token)

    instance.type = tokenType
    instance.value = value

    return instance
end

return Token
