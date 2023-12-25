xpcall(function() dofile("expansions/script/c20099998.lua") end,function() dofile("script/c20099998.lua") end)
if fuef then return end
fuef = { }
--------------------------------------------------------------------------"Effect function"
function fuef:New(owner,handler,isAct,typ,dis)
	local E = setmetatable({ }, self)
	self.__index = self
	function self:__add(var) return self:Set(table.unpack(fusf.CutString(var,",",nil,"__add"))):Register() end
	function self:__call(cod,handler,...) --copy
		local sets = {...}
		sets = type(sets) == "table" and #sets == 1 and sets[1] or sets
		if type(sets) == "string" and not sets:match(":") then
			local var = {self.e:GetOwner(), handler or self.gettor, cod or self.e:GetCode(), sets}
			if self.detial[2] == "I" or self.detial[2] == "F+G" then var = {self.e:GetOwner(), handler or self.gettor, sets} end
			return fuef.T_reg(table.unpack(self.detial))(table.unpack(var))
		else
			local E = setmetatable({ }, getmetatable(self))
			E.gettor = handler or self.gettor
			E.e = self.e:Clone()
			return E:Set({"COD",cod or self.e:GetCode()},...):Register()
		end
	end
	function self:__eq(table) Debug.Message(getmetatable(self) == table) end
if aux.GetValueType(fusf.GetCardTable(owner)[1])~="Card" then Debug.Message(aux.GetValueType(owner)) end
	E.e = fucg.eff.CRE(fusf.GetCardTable(owner)[1])
	E.gettor = handler
	E.detial = {isAct,typ,dis}
	return E
end
function fuef:Set(...)
	local sets = {...}
	if #sets == 0 then return self end
	if #sets <= 2 and type(sets[1]) == "string" and not sets[1]:find(":") then sets = {sets} end
	sets = fusf.Value_Trans(table.unpack(sets))
	for _,set in ipairs(sets) do
		if type(set) == "string" and set:find(":") then set = fusf.CutString(set,":",nil,"Set") end
		set = type(set) == "table" and set or {set}
		local f = type(set[1]) == "string" and fucg.eff[set[1] ] or set[1]
		table.remove(set,1)
		f(self,table.unpack(set))
	end
	return self
end
function fuef:Register(handler)
	handler =  handler or self.gettor
	if not handler then return self end
	handler = type(handler) == "table" and handler or { handler }
	self.gettor =  handler
	local Ignore = handler[2] or false
	local Handler = type(handler[1]) == "number" and handler[1] or fusf.GetCardTable(handler[1])
	local E = self.e:Clone()
	self.e:Reset()
	if self.gclo then 
		for _,ge in ipairs(self.gclo) do
			ge:Reset()
		end
		self.gclo = {}
	end
	self.e = E
	if type(Handler) == "number" then
		Duel.RegisterEffect(self.e,Handler)
	else
		table.remove(Handler):RegisterEffect(self.e,Ignore)
		for _,C in ipairs(Handler) do
			E = self.e:Clone()
			self.gclo = self.gclo or {}
			self.gclo[#self.gclo+1] = E
			C:RegisterEffect(E,Ignore)
		end
	end
	return self
end
function fuef.T_reg(isAct,typ,dis)
	return function(c,rc,...)
		local v,var = fusf.Value_Trans(...),{ }
		if isAct then 
			local _cod = dis:match("COD") and 1 or table.remove(v,1)
			var = dis:match("COD") and { } or { {"COD" , fusf.NotNil(_cod) and _cod or "FC"} }
		end
		local dis = (#dis>0 and dis.."," or "")..(isAct and "COD,TRAN,VAL" or "CAT,COS")
		for i,val in ipairs(fusf.CutString("COD,DES,CAT,PRO,RAN,TRAN,VAL,CTL,CON,COS,TG,OP,RES,LAB,OBJ",",",dis)) do
			var[#var + 1] = fusf.NotNil(v[i]) and { val , v[i] } or nil
		end
		return fuef:New(c,rc,isAct,typ,dis):Set("TYP:"..typ,table.unpack(var)):Register()
	end
end
function fuef.typ_register(isAct,str)
	for _,set in ipairs(fusf.CutString(str,"|",nil,"typ_register1")) do
		set = fusf.CutString(set,":",nil,"typ_register2")
		local name = ""
		for _,var in ipairs(fusf.CutString(set[1],"+",nil,"typ_register3")) do
			name = name..var
		end
		fuef[name] = fuef.T_reg(isAct,set[1],set[2] or "")
	end
end
fuef.B_A = fuef.T_reg(1,"A","RAN")
fuef.A   = function(c,rc) return fuef.B_A(c,rc or c) end
fuef.typ_register(1,"I:COD|QO|QF|F+TO|F+TF|S+TO:RAN|S+TF:RAN")
fuef.typ_register(nil,"S:TRAN,TG|S+C:TRAN,VAL,TG|F|F+C:TRAN,VAL,TG|F+G:DES,COD,PRO,VAL,CTL,OP|E:DES,RAN,TRAN,CTL,TG,OP|E+C:DES,PRO,RAN,TRAN,VAL,CTL")
fuef.typ_register(nil,"X:TRAN,TG")