local Token = require("token")

Parser = {}
Parser.__index = Parser

function Parser.new(tokens)
    local instance = {}
    setmetatable(instance, Parser)

    instance.currentToken = 1
    instance.tokens = tokens
    instance.ast = nil

    return instance
end

function Parser:fetch(tokenType)
    local topToken = self:getCurrentToken()
    local found = false

    if (type(tokenType) == "table") then
        for typeIndex = 1, #tokenType do
            if (topToken.type == tokenType[typeIndex]) then
                found = true

                break
            end
        end
    elseif (topToken.type == tokenType) then
        found = true
    end

    if (found) then
        self.currentToken = self.currentToken + 1

        return topToken
    end
    
    if (type(tokenType) == "table") then
        error("expected token type "..table.concat(tokenType, "|"))
    else
        error("expected token type "..tokenType)
    end
end

function Parser:getCurrentToken()
    return self.tokens[self.currentToken]
end

function Parser:term3()
    local token = self:fetch({TOKEN_MINUS, TOKEN_LPARENS, TOKEN_INT})

    if (token.type == TOKEN_LPARENS) then
        local node = self:expr()
        self:fetch(TOKEN_RPARENS)

        return node
    elseif (token.type == TOKEN_MINUS) then
        return {left = self:expr(), right = nil, value = "-"}
    end

    return {left = nil, right = nil, value = token.value}
end

function Parser:term2()
    local node = self:term3()
    local operator = self:getCurrentToken()
    local operand

    while (operator.type == TOKEN_CARET) do
        operator = self:fetch(TOKEN_CARET)
        operand = self:term3()

        node = {left = node, right = operand, value = "^"}
        operator = self:getCurrentToken()
    end

    return node
end

function Parser:term()
    local node = self:term2()
    local operator = self:getCurrentToken()
    local operand

    while (operator.type == TOKEN_TIMES or operator.type == TOKEN_DIV) do
        operator = self:fetch({TOKEN_TIMES, TOKEN_DIV})
        operand = self:term2()

        if (operator.type == TOKEN_TIMES) then
            operator = "*"
        else
            operator = "/"
        end

        node = {left = node, right = operand, value = operator}
        operator = self:getCurrentToken()
    end

    return node
end

function Parser:expr()
    local node = self:term()
    local operator = self:getCurrentToken()
    local operand

    while (operator.type == TOKEN_PLUS or operator.type == TOKEN_MINUS) do
        operator = self:fetch({TOKEN_PLUS, TOKEN_MINUS})
        operand = self:term()

        if (operator.type == TOKEN_PLUS) then
            operator = "+"
        else
            operator = "-"
        end

        node = {left = node, right = operand, value = operator}
        operator = self:getCurrentToken()
    end

    return node
end

function Parser:run()
    self.ast = self:expr()
end

function Parser:getAST()
    return self.ast
end

return Parser
