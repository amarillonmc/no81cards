if not pcall(function() require("expansions/script/c20099998") end) then require("script/c20099998") end
if fuef then return end
fuef = { }  --"Effect function"
--------------------------------------------------------------------------"Effect function"
function fuef.Creat(owner,handler,...)
	local e = fuef.Set(fucg.eff.CRE(fusf.GetCardTable(owner)[1]),...)
	if handler then fuef.Register(e,handler) end
	return e
end
function fuef.Clone(effect,handler,...)
	local e = fuef.Set(fucg.eff.CLO(effect),...)
	if handler then fuef.Register(e,handler) end
	return e
end
function fuef.Set(e,...)
	e = type(e) == "table" and e or { e }
	local setlist = {...}
	if #setlist == 0 then return table.unpack(e) end
	if type(setlist[1]) ~= "table" then setlist = {setlist} end
	for _,E in ipairs(e) do
		for _,set in ipairs(setlist) do
			local f = type(set[1]) == "string" and fucg.eff[set[1] ] or set[1]
			table.remove(set,1)
			f(E,table.unpack(set))
		end
	end
	return e
end
function fuef.Register(e,handler)
	handler = type(handler) == "table" and handler or { handler }
	local Ignore = handler[2] or false
	local Handler = type(handler[1]) == "number" and handler[1] or fusf.GetCardTable(handler[1])
	for _,E in ipairs(type(e) == "table" and e or {e}) do
		if type(Handler) == "number" then
			Duel.RegisterEffect(E,Handler)
		else
			for _,C in ipairs(Handler) do
				C:RegisterEffect(E,Ignore)
			end
		end
	end
end
function fuef.Act(typ,dis)
	return function(c,rc,...)
		local v, var = fusf.Value_Trans({...}), { }
		for i,val in ipairs(fusf.CutDis("DES,CAT,COD,PRO,RAN,CTL,CON,COS,TG,OP,RES,LAB,OBJ",dis)) do
			if val == "COD" then
				var[#var + 1] = { val , fusf.NotNil(v[i]) and v[i] or "FC" }
			elseif fusf.NotNil(v[i]) then
				var[#var + 1] = { val , v[i] }
			end
		end
		return fuef.Creat(c,rc,{"TYP",typ},table.unpack(var))
	end
end
function fuef.NoAct(typ,dis)
	return function(c,rc,...)
		local v, var = fusf.Value_Trans({...}), { }
		for i,val in ipairs(fusf.CutDis("DES,COD,PRO,RAN,TRAN,VAL,CTL,CON,TG,OP,RES,LAB,OBJ",dis)) do
			if fusf.NotNil(v[i]) then
				var[#var + 1] = { val , v[i] }
			end
		end
		return fuef.Creat(c,rc,{"TYP",typ},table.unpack(var))
	end
end 
fuef.B_A = fuef.Act(EFFECT_TYPE_ACTIVATE,"RAN")
fuef.A   = function(c,rc,cod) return fuef.B_A(c,rc or c,",",cod) end
fuef.I   = fuef.Act(EFFECT_TYPE_IGNITION,"")
fuef.QO  = fuef.Act(EFFECT_TYPE_QUICK_O,"")
fuef.QF  = fuef.Act(EFFECT_TYPE_QUICK_F,"")
fuef.FTO = fuef.Act(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O,"")
fuef.FTF = fuef.Act(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F,"")
fuef.STO = fuef.Act(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O,"RAN")
fuef.STF = fuef.Act(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F,"RAN")
fuef.S   = fuef.NoAct(EFFECT_TYPE_SINGLE,"TRAN,TG")
fuef.SC  = fuef.NoAct(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,"RAN,TRAN,VAL,TG")
fuef.F   = fuef.NoAct(EFFECT_TYPE_FIELD,"")
fuef.FC  = fuef.NoAct(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,"TRAN,VAL,TG")
fuef.FG  = fuef.NoAct(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT,"COD,PRO,VAL,CTL,TG,OP")
fuef.E   = fuef.NoAct(EFFECT_TYPE_EQUIP,"DES,RAN,TRAN,CTL,TG,OP")
fuef.EC  = fuef.NoAct(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS,"DES,PRO,RAN,TRAN,VAL,CTL")