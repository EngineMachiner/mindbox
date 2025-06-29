
-- Modified version of Astro.Table.concat for OutFox.

--[[

    Concatenates any arguments including tables. 
    This algorithm has cycle detection and special formatting for readibility
    using constants like "showID", "showIndex", "wideMode" and "indentation".

]]

------------------------------------------------------------------------------------------------------------------------

local astro = Astro.Type                    local isVector = Astro.Vector.isVector

local isNumber = astro.isNumber             local isString = astro.isString
local isTable = astro.isTable               local isNil = astro.isNil

------------------------------------------------------------------------------------------------------------------------

astro = Astro.Config.Concat

local showID = astro.showID                         local showIndex = astro.showIndex
local wideMode = astro.wideMode                     local indentation = astro.indentation
local keyQuotes = astro.keyQuotes

local showChildren = mindbox.Config.showChildren

------------------------------------------------------------------------------------------------------------------------

astro = Astro.Table         local isObject = tapLua.Type.isObject

local table = astro.table { "insert", "pack", "concat",         isEmpty = astro.isEmpty }

------------------------------------------------------------------------------------------------------------------------

-- Remove useless data.

local function purge(tbl) tbl.ctx = nil end

local function onObject( former, copy )
    
    purge(copy)         local isValid = showChildren and isObject(former)

    isValid = isValid and former.GetChildren            if not isValid then return end

    copy.Children = former:GetChildren()

end

------------------------------------------------------------------------------------------------------------------------

local function concat(...) local s = {...}      return table.concat(s) end

local function brackets(s)

    return showIndex and concat( '[', s ,']' ) or s

end

local function quotes(a)

    local s = tostring(a)           local c = #s > 1 and '"' or "'"

    return isString(a) and concat( c, s, c ) or s

end

local function key(k)
    
    local key = tostring(k)         local quotes = quotes(k)
    
    if keyQuotes and isString(k) then key = quotes end
    
    if showIndex then key = brackets(quotes) else
      
        key = isNumber(k) and '' or key
      
    end

    return key

end

local sequences = {

    ['\a'] = '\\a',     ['\b'] = '\\b',     ['\f'] = '\\f',     ['\n'] = '\\n',
    ['\r'] = '\\r',     ['\t'] = '\\t',     ['\v'] = '\\v'

}

local function escape(a)

    for k,v in pairs(sequences) do a = a:gsub( k, v ) end

    return a

end

local function tableFormat( a, s )

    local isTable = isTable(a)      if showID then return s end

    
    -- Remove the addresses.

    if isTable and not isObject(a) then return '' end

    return s:gsub(" (.*", '')

end

local function format(a)

    local s = tostring(a)       s = escape(s)       if isString(a) then return quotes(s) end

    return tableFormat( a, s )

end

-- Get and format the name of a value.

local function name(a)
    
    local s = format(a)         local isEmpty = s == ''
    
    return isEmpty and s or concat( s, ' ' )

end

-- Returns a special copy of the table.

local function copy(tbl)

    local copy = astro.Copy.shallow(tbl)

    -- Parse indexed nil values to strings. This is why there's a copy.

    -- Iterating the Def table freezes the game forever: https://github.com/TeamRizu/OutFox/issues/769

	for i,v in ipairs(tbl) do if isNil(v) then copy[i] = "nil" end end

    -- If you need to erase values, you should do it here.

    onObject( tbl, copy )           return copy

end

local function cycleName(name)

  if not showID then return '' end              name = name:sub( 1, #name - 1 )
  
  return concat( ' ', name )
  
end

local function notEmpty(a)
    
    return isTable(a) and not table.isEmpty(a) 

end

local function pack(tbl)

    local former = tbl -- We need it later.

    local t = {} -- Table containing all the strings.


    local processed = {} -- Track tables we've already processed to avoid infinite recursion.
    
    local function wasProcessed(tbl) return processed[tbl] end
    

    local function isGap(a, b) 
  
        if not wideMode then return end
  
        if wasProcessed(a) or wasProcessed(b) then return end
  
        local isValid1 = notEmpty(a) and not notEmpty(b)
        local isValid2 = notEmpty(b) and not notEmpty(a)
        local isValid3 = notEmpty(a) and notEmpty(b)
      
        return isValid1 or isValid2 or isValid3
      
    end


    local function add( s, indent )
        
        indent = indent or 0            indent = indentation:rep(indent)
        
        s = concat( indent, s )             table.insert( t, s )
    
    end

    local recursivePack

    local function addValue( v, indent )
    
        if isVector(v) then add( tostring(v) ) return end

        if isTable(v) then recursivePack( v, indent ) return end

        local name = format(v)        add(name)

    end

    recursivePack = function( tbl, indent )

        indent = indent or 0


        local copy = copy(tbl)          local name = name(tbl)
        
        local isEmpty = table.isEmpty(copy)         local isFormer = tbl == former
        
        
        local cycleName = cycleName(name)           cycleName = concat( "<cycle>", cycleName )

        if processed[tbl] then add(cycleName) return end            processed[tbl] = true
        

        local curly = concat( name, '{' )

        if isFormer then indent = indent - 1 else add(curly) end


        local firstKey, lastKey

        for k,v in pairs(copy) do

            local a, b = next( copy, k )        
            
            firstKey = firstKey or k            if isNil(a) then lastKey = k end
            
            local isFirst = k == firstKey           local isLast = k == lastKey
            
            
            local indent = indent + 1           local isGap = isGap(v, b)

            local n = wideMode and "\n\n" or '\n'
            

            if isFirst and not isFormer then add( n, indent ) end
            

            local key = key(k)        if #key > 0 then key = concat( key, " = " ) end

            add( key, indent )        addValue( v, indent )


            if isLast then if not isFormer then add(n) end else add(",\n") end
              
            if not isLast and isGap then add('\n') end

        end

        
        if isFormer then return end         if isEmpty then indent = 0 end
        
        add( '}', indent )
        
    end


    recursivePack(tbl)         return t

end

-- Older Lua versions don't have table.pack.

local function wrap(...)

    if not table.pack then return {...} end             local tbl = table.pack(...)     tbl.n = nil

    return tbl
    
end


local tbl = wrap(...)       tbl = pack(tbl)         return table.concat(tbl)
