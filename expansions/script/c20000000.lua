xpcall(function() dofile("expansions/script/c20099997.lua") end,function() dofile("script/c20099997.lua") end)
if fuef then return end
fuef = { }
--------------------------------------------------------------------------metamethods
function fuef:New(_typ, _cod)
	local E = setmetatable({ }, self)
	self.__index = self 
	E.temp = {
		typ = _typ,
		cod = _cod
	}
	return E
end
-- fuef() : clone fuef and return clone
function fuef:__call(_cod, _handler)
	local clone_E = setmetatable({ }, getmetatable(self))
	clone_E.e = self.e:Clone()
	clone_E.cod = _cod and fusf.Get_Code_Constant(clone_E.e:GetOwner():GetOriginalCode(), _cod) or self.cod
	clone_E.handler = _handler or self.handler
	for _,_key in ipairs(fusf.CutString("typ,des,cat,pro,ran,tran,ctl,val,con,tg,op,res", ",", nil, "fuef:__call")) do
		clone_E[_key] = self[_key] or nil
	end
	return clone_E:SetKey():Reg()
end
function fuef:Get_Func(_val)
	local _var
	if type(_val) == "string" then 
		local lib = self.e:GetOwner().lib or {}
		local cm = _G["c"..self.e:GetOwner():GetCode()]
		-- find lib, cm and aux
		_var = lib[_val] or cm[_val] or aux[_val]
		-- _val = func*a*b => func(a,b) 
		if not _var and _val:match("*") then 
			local _func_val = fusf.CutString(_val, "*", nil, "fuef:Get_Func")
			local _func = table.remove(_func_val, 1)
			if aux[_func] then _var = aux[_func](table.unpack(_func_val)) end
			if cm[_func] then _var = cm[_func](table.unpack(_func_val)) end
			if lib[_func] then _var = lib[_func](table.unpack(_func_val)) end
		end
	end
	return _var or _val
end
function fuef:Owner_chk(_key, _val)
	if not self.e then self.temp[_key] = _val end
	return not self.e
end
function fuef:Nil_chk(_key, _val)
	if not fusf.NotNil(_val) then Debug.Message(self.e:GetOwner():GetOriginalCode().." :".._key.." value is nil") end
	return not fusf.NotNil(_val)
end
--------------------------------------------------------------------------"Effect function"
-- Set all keys in the effect
function fuef:SetKey()
	if not self.e then return self end
	if self.typ then self.e:SetType(self.typ) end
	if self.des then self.e:SetDescription(self.des) end
	if self.cod then self.e:SetCode(self.cod) end
	if self.cat then self.e:SetCategory(self.cat) end
	if self.pro then self.e:SetProperty(self.pro) end
	if self.ran then self.e:SetRange(self.ran) end
	if self.tran then self.e:SetTargetRange(table.unpack(self.tran)) end
	if self.ctl then self.e:SetCountLimit(table.unpack(self.ctl)) end
	if self.val then self.e:SetValue(self.val) end
	if self.con then self.e:SetCondition(self.con) end
	if self.cos then self.e:SetCost(self.cos) end
	if self.tg then self.e:SetTarget(self.tg) end
	if self.op then self.e:SetOperation(self.op) end
	if self.res then self.e:SetReset(table.unpack(self.res)) end
	if self.lab then self.e:SetLabel(table.unpack(self.lab)) end
	if self.obj then self.e:SetLabelObject(self.obj) end
	return self
end
-- just Register Effect
function fuef:Reg(_handler)
	-- handler nil chk
	_handler =  _handler or self.handler
	if not _handler then return self end
	_handler = type(_handler) == "table" and _handler or { _handler }
	-- reset handler
	self.handler =  _handler
	-- Register e
	-- Handler is player
	if type(_handler[1]) == "number" then
		Duel.RegisterEffect(self.e, _handler[1])
	-- rc or rg or {rc, 1} or {rg, 1}
	else
		-- check handler is card or card group
		local Handler = fusf.GetCardTable(_handler[1])
		-- check is force Register
		local Ignore = _handler[2] or false
		-- Handler is card
		if #Handler == 1 then
			Handler[1]:RegisterEffect(self.e, Ignore)
		-- Handler is card group
		else
			-- Register self
			table.remove(Handler):RegisterEffect(self.e, Ignore)
			-- Register other card
			self.gclo = { }
			for i = 1,#Handler do
				local E = self.e:Clone()
				self.gclo[#self.gclo + 1] = E
				Handler[i]:RegisterEffect(E, Ignore)
			end
		end
	end
	return self
end
-- do Reset, SetKey and Register
function fuef:Reload()
	if aux.GetValueType(self.e) == "Effect" then
		local _owner = self.e:GetOwner()
		self.e:Reset()
		self.e = Effect.CreateEffect(_owner)
		if self.gclo then 
			for _,gcloe in ipairs(self.gclo) do
				gcloe:Reset()
			end
			self.gclo = nil
		end
	end
	return self:SetKey():Reg()
end
----------------------------------------------------------------Owner
function fuef:Owner(_owner, _handler)
	if not fusf.NotNil(_owner) then return self end
	self.e = Effect.CreateEffect(fusf.GetCardTable(_owner)[1])
	local handler = _handler or _owner
	if (_handler == false) then handler = nil end
	self:TYP(self.temp.typ):Reg(handler)

	if self.temp.des then self:DES(table.unpack(self.temp.des)) end
	if self.temp.cod then self:COD(self.temp.cod) end
	if self.temp.cat then self:CAT(self.temp.cat) end
	if self.temp.pro then self:PRO(self.temp.pro) end
	if self.temp.ran then self:RAN(self.temp.ran) end
	if self.temp.tran then self:TRAN(table.unpack(self.temp.tran)) end
	if self.temp.ctl then self:CTL(table.unpack(self.temp.ctl)) end
	if self.temp.val then self:VAL(self.temp.val) end
	if self.temp.con then self:CON(self.temp.con) end
	if self.temp.cos then self:COS(self.temp.cos) end
	if self.temp.tg then self:TG(self.temp.tg) end
	if self.temp.op then self:OP(self.temp.op) end
	if self.temp.res then self:RES(table.unpack(self.temp.res)) end
	if self.temp.lab then self:LAB(table.unpack(self.temp.lab)) end
	if self.temp.obj then self:OBJ(self.temp.obj) end

	return self:Reload()
end
----------------------------------------------------------------typ, owner, cod and handler
-- need cod
for _,typ in ipairs(fusf.CutString("I,QO,QF,F+TO,F+TF,S+TO,S+TF", ",", nil, "fuef:typ_reg_1")) do
	local name = ""
	for _,var in ipairs(fusf.CutString(typ, "+", nil, "fuef:typ_reg_2")) do
		name = name..var
	end
	fuef[name] = function(_owner, _cod, _handler)
		return fuef:New(typ, _cod):Owner(_owner, _handler)
	end
end
-- cod = cod or FC
for _,typ in ipairs(fusf.CutString("A,S,S+C,F,F+C,F+G,E,E+C,X", ",", nil, "fuef:typ_reg_3")) do
	local name = ""
	for _,var in ipairs(fusf.CutString(typ, "+", nil, "fuef:typ_reg_4")) do
		name = name..var
	end
	fuef[name] = function(_owner, _cod, _handler)
		return fuef:New(typ, _cod or "FC"):Owner(_owner, _handler)
	end
end
-- no cod 
function fuef.FG(_owner, _handler)
	return fuef:New("F+G", false):Owner(_owner, _handler)
end
----------------------------------------------------------------DES
function fuef:DES(_val, _val2)
	-- owner chk and nil chk
	if self:Owner_chk("des", {_val, _val2}) or self:Nil_chk("DES", _val) then return self end
	-- _val = code, _val2 = id
	if _val2 then
		_val = aux.Stringid(_val, _val2)
	-- {code,id}
	elseif type(_val) == "table" then
		_val = aux.Stringid(table.unpack(_val))
	elseif type(_val) == "string" then
		-- "code+id" or "code+" , code can be other card code
		if _val:match("+") then 
			_val = fusf.CutString(_val, "+", nil, "fuef:DES")
			local code = tonumber(_val[1])
			code = (code < 19999999) and (code + 20000000) or code
			_val = aux.Stringid(code, fusf.NotNil(_val[2]) and tonumber(_val[2]) or 0)
		-- key in fucs.des
		else
			_val = fucs.des[_val]
		end
	-- key in strings.conf or id in owner card
	elseif type(_val) == "number" then
		_val = (_val < 17) and aux.Stringid(self.e:GetOwner():GetOriginalCode(), _val) or _val
	end
	self.des = _val
	return self:Reload()
end
----------------------------------------------------------------TYP, COD, CAT and PRO
function fuef:TYP(_val)
	-- owner chk and nil chk
	if self:Owner_chk("typ", _val) or self:Nil_chk("TYP", _val) then return self end
	self.typ = fusf.Get_Constant("etyp", _val)
	return self:Reload()
end
function fuef:COD(_val)
	-- owner chk and nil chk
	if self:Owner_chk("cod", _val) or self:Nil_chk("COD", _val) then return self end
	self.cod = fusf.Get_Code_Constant(self.e:GetOwner():GetOriginalCode(), _val)
	return self:Reload()
end
function fuef:CAT(_val)
	-- owner chk and nil chk
	if self:Owner_chk("cat", _val) or self:Nil_chk("CAT", _val) then return self end
	self.cat, _des = fusf.Get_Constant("cat", _val)
	if not self.des and _des then self:DES(_des) end
	return self:Reload()
end
function fuef:PRO(_val)
	-- owner chk and nil chk
	if self:Owner_chk("pro", _val) or self:Nil_chk("PRO", _val) then return self end
	self.pro = fusf.Get_Constant("pro", _val)
	return self:Reload()
end
----------------------------------------------------------------RAN and TRAN
function fuef:RAN(_val)
	-- owner chk and nil chk
	if self:Owner_chk("ran", _val) then return self end
	self.ran = fusf.Get_Loc(_val, nil, self.e:GetOwner():GetOriginalCode().." :RAN value is nil")
	return self.ran and self:Reload() or self
end
function fuef:TRAN(_val1, _val2)
	-- owner chk and nil chk
	if self:Owner_chk("tran", {_val1, _val2}) then return self end
	self.tran = {fusf.Get_Loc(_val1, _val2, self.e:GetOwner():GetOriginalCode().." :TRAN value is nil")}
	return self.tran and self:Reload() or self
end
----------------------------------------------------------------CTL
function fuef:CTL(_val1, _val2)
	-- owner chk and nil chk
	if self:Owner_chk("ctl", {_val1, _val2}) or self:Nil_chk("CTL", {_val1, _val2}) then return self end
	-- count, code + effect_count_code
	local ctl = { 1 }
	-- _val2 chk
	if _val2 then
		ctl[2] = (type(_val2) == "string") and 0 or _val2
		if type(_val2) == "string" then
			for i,_val in ipairs(fusf.CutString(_val2, "+", nil, "fuef:CTL_1")) do
				if _val:match("%d") then 
					ctl[2] = ctl[2] + tonumber(_val)
				elseif _val:match("m") then
					ctl[2] = ctl[2] + self.e:GetOwner():GetOriginalCode()
				elseif _val:match("[ODS]") then
					ctl[3] = fucs.ctl[_val]
				else
					ctl[2] = ctl[2] + (self.e:GetOwner().lib or {})[_val]
				end
			end
		end
	end
	-- _val1 type string
	if type(_val1) == "string" then
		-- count + code + effect_count_code
		for i,_val in ipairs(fusf.CutString(_val1, "+", nil, "CTL")) do
			if _val:match("%d") then 
				if i == 1 then  
					ctl[1] = tonumber(_val)
				else 
					ctl[2] = (ctl[2] or 0) + tonumber(_val) 
				end
			elseif _val:match("m") then
				ctl[2] = (ctl[2] or 0) + self.e:GetOwner():GetOriginalCode()
			elseif _val:match("[ODS]") then
				ctl[3] = fucs.ctl[_val]
			else
				ctl[2] = (ctl[2] or 0) + (self.e:GetOwner().lib or {})[_val]
			end
		end
	-- _val1 type number
	else
		-- chk is count or code
		ctl[(_val1 > 99) and 2 or 1] = _val1 
	end
	if ctl[3] and not ctl[2] then ctl[2] = self.e:GetOwner():GetOriginalCode() end
	ctl[2] = (ctl[2] or 0) + (ctl[3] or 0)
	ctl[3] = nil
	self.ctl = ctl
	return self:Reload()
end
----------------------------------------------------------------VAL, CON, COS, TG and OP
function fuef:Func(_val1, _val2)
	-- nil chk
	if self:Nil_chk("Func", {_val1, _val2}) then return self end
	-- "val,con,cos,tg,op" or "con1,op1" , if cant chk then Follow a sequence
	local _seqs = {"val", "con", "cos", "tg", "op"}
	-- _val2 chk : (val, other func)
	if _val2 then self.val, _val1 = _val1, _val2 end
	local _funcs = fusf.CutString(_val1, ",", nil, "fuef:Func")
	for i,_func in ipairs(_funcs) do
		if fusf.NotNil(_func) then
			-- chk
			local _place, _chk = 0, 0
			for j,_seq in ipairs(_seqs) do
				local _pre = _func:find(_seq)
				if _pre and (_pre > _chk) then _chk, _place = _pre, j end
			end
			-- cant chk
			if (_place == 0) then _place = i end
			-- set
			if not self.e then 
				self.temp[_place == 1 and "val" or _seqs[_place] ] = _func
			elseif _place == 1 then
				self.val = tonumber(_func) or fucs.val[_func] or self:Get_Func(_func)
			else
				self[_seqs[_place] ] = self:Get_Func(_func)
			end
		end
	end
	if self.e then return self:Reload() end
	return self
end
function fuef:VAL(_val)
	-- owner chk and nil chk
	if self:Owner_chk("val", _val) or self:Nil_chk("VAL", _val) then return self end
	self.val = tonumber(_val) or fucs.val[_val] or self:Get_Func(_val)
	return self:Reload()
end
function fuef:CON(_val)
	-- owner chk and nil chk
	if self:Owner_chk("con", _val) or self:Nil_chk("CON", _val) then return self end
	self.con = self:Get_Func(_val)
	return self:Reload()
end
function fuef:COS(_val)
	-- owner chk and nil chk
	if self:Owner_chk("cos", _val) or self:Nil_chk("COS", _val) then return self end
	self.cos = self:Get_Func(_val)
	return self:Reload()
end
function fuef:TG(_val)
	-- owner chk and nil chk
	if self:Owner_chk("tg", _val) or self:Nil_chk("TG", _val) then return self end
	self.tg = self:Get_Func(_val)
	return self:Reload()
end
function fuef:OP(_val)
	-- owner chk and nil chk
	if self:Owner_chk("op", _val) or self:Nil_chk("OP", _val) then return self end
	self.op = self:Get_Func(_val)
	return self:Reload()
end
----------------------------------------------------------------RES
function fuef:RES(_val, _val2)
	-- owner chk and nil chk
	if self:Owner_chk("res", {_val, _val2}) or self:Nil_chk("RES", {_val, _val2}) then return self end
	-- a + b/b1/b2 + c |1
	local _res = type(_val) == "string" and 0 or _val
	if type(_val) == "string" then
		_val = fusf.CutString(_val, "|", nil, "fuef:RES_1")
		for _,V1 in ipairs(fusf.CutString(_val[1], "+", nil, "fuef:RES_2")) do
			V1 = fusf.CutString(V1, "/", nil, "fuef:RES_3")
			_res = _res + fucs.res[V1[1] ]
			if V1[2] then
				local _index = "_"..table.remove(V1,1)
				for _,V2 in ipairs(V1) do
					_res = _res + fucs.res[_index][V2:upper()]
				end
			end
		end
		_val = _val[2] and tonumber(_val[2]) or 1
	end
	self.res = {_res, _val2 or _val}
	return self:Reload()
end
----------------------------------------------------------------LAB
function fuef:LAB(...)
	local _labs = {...}
	-- owner chk and nil chk
	if self:Owner_chk("lab", _labs) or self:Nil_chk("LAB", _labs) then return self end
	local labs = { }
	for _,_lab in ipairs(_labs) do
		if type(_lab) == "string" then 
			for _,lab in ipairs(fusf.CutString(_lab, "+", nil, "fuef:LAB")) do
				labs[#labs + 1] = (lab == "m") and self.e:GetOwner():GetOriginalCode() or tonumber(lab)
			end
		else
			labs[#labs + 1] = _lab
		end
	end
	self.lab = labs
	return self:Reload()
end
----------------------------------------------------------------OBJ
function fuef:OBJ(_val)
	-- owner chk and nil chk
	if self:Owner_chk("obj", _val) or self:Nil_chk("OBJ", _val) then return self end
	self.obj = _val
	return self:Reload()
end