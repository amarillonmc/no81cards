--fucg_lib
local m=20000000
if not pcall(function() require("expansions/script/c20099999") end) then require("script/c20099999") end
local fu = fucg
if fu.lib then return end
fu.lib = true
--------------------------------------------------------------------------"Effect Function"
function fu.ef.Creat(c,f,v,rc)
--Creat Effect
	--Delete nil
	local s = {}
	for i,F in pairs(f) do
		if type(F) == "string" and not v[i] then
			table.insert(s,i)
		end
	end
	for i,S in pairs(s) do
		for j = S-i+1,(math.max(#f,#v)) do
			f[j] = f[j+1] or nil
			v[j] = v[j+1] or nil
		end
	end
	--Check clone
	s = {}
	local t = 1
	for i,V in pairs(v) do
		if type(V) == "table" and not (f[i] == "PRO" or f[i] == "RAN" or f[i] == "CTL" or f[i] == "RES" or f[i] == "TRAN") then
			t = #v[i] > t and #v[i] or t
			table.insert(s,i)
		end
	end
	if #s == 1 and f[s[1] ] == "DES" then s = {};t = 1 end
	local e = {}
	local V = table.move(v,1,#v,1,{})
	--Set and Register effect
	for i = 1,t do
		for _,S in ipairs(s) do
			V[S] = v[S][i]
		end
		e[i] = fu.ef.Set(fu.eff.CRE(fu.sf.GetCardTable(c)[1]),f,V)
	end
	if rc then fu.ef.Register(e,rc) end
	return table.unpack(e)
end
function fu.ef.Set(e,f,v)
--Set Effect detail
	e = type(e) == "table" and e or { e }
	f = type(f) == "table" and f or { f }
	v = type(v) == "table" and v or { v }
	for _,E in pairs(e) do
		if #f == 1 then
			(type(f[1]) == "string" and fu.eff[f[1] ] or f[1])(E,table.unpack(v))
		else
			for i,F in pairs(f) do
				v[i] = type(v[i]) == "table" and v[i] or { v[i] }
				(type(F) == "string" and fu.eff[F] or F)(E,table.unpack(v[i]))
			end
		end
	end
	return table.unpack(e)
end
function fu.ef.Register(e,c)
--Register Effect
	c = type(c) == "table" and c or { c }
	local Handler = type(c[1]) == "number" and c[1] or fu.sf.GetCardTable(c[1])
	local Ignore = c[2] or false
	for _,E in ipairs(type(e) == "table" and e or {e}) do
		if type(Handler) == "number" then
			Duel.RegisterEffect(E,Handler)
		else
			for i,C in ipairs(Handler) do
				C:RegisterEffect(E,Ignore)
			end
		end
	end
end
--------------------------------------------------------------------------"Effect_Activate"
--Activate Effect: Base set
function fu.ef.A(c,des,cat,cod,pro,ctl,con,cos,tg,op,rc,res,lab,obj)
	cod = cod or EVENT_FREE_CHAIN 
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","CTL","CON","COS","TG","OP","RES","LAB","LABOBJ"},
		{des,cat,EFFECT_TYPE_ACTIVATE,cod,pro,ctl,con,cos,tg,op,res,lab,obj},rc)
end  
--------------------------------------------------------------------------"Effect_Single"
--Single Effect: Base set
function fu.ef.S(c,des,cod,pro,ran,val,ctl,con,rc,res,lab,obj)
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","RAN","VAL","CTL","CON","RES","LAB","LABOBJ"},{des,EFFECT_TYPE_SINGLE,cod,pro,ran,val,ctl,con,res,lab,obj},rc)
end
--------------------------------------------------------------------------"Effect_Field"
--Field Effect: Base set
function fu.ef.B_F(c,des,typ,cod,pro,ran,tran,val,ctl,con,tg,rc,res,lab,obj)
	typ = EFFECT_TYPE_FIELD | (typ or 0)
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","RAN","TRAN","VAL","CTL","CON","TG","RES","LAB","LABOBJ"},
		{des,typ,cod,pro,ran,tran,val,ctl,con,tg,res,lab,obj},rc)
end
function fu.ef.F(c,des,cod,pro,ran,tran,val,ctl,con,tg,rc,res,lab,obj)
	return fu.ef.B_F(c,des,nil,cod,pro,ran,tran,val,ctl,con,tg,rc,res,lab,obj)
end
--------------------------------------------------------------------------"Effect_Qucik"
--Quick Effect : Base set
function fu.ef.B_Q(c,des,cat,typ,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	cod = cod or EVENT_FREE_CHAIN 
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","RAN","CTL","CON","COS","TG","OP","RES","LAB","LABOBJ"},
		{des,cat,typ,cod,pro,ran,ctl,con,cos,tg,op,res,lab,obj},rc)
end
--Quick Effect No Force: Base set
function fu.ef.QO(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	cod = cod or EVENT_FREE_CHAIN 
	return fu.ef.B_Q(c,des,cat,EFFECT_TYPE_QUICK_O,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--Quick Effect Force: Base set
function fu.ef.QF(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.B_Q(c,des,cat,EFFECT_TYPE_QUICK_F,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end 
--------------------------------------------------------------------------"Effect_Continuous"
--Continues: Base set
function fu.ef.B_C(c,des,typ,cod,pro,ran,ctl,con,op,rc,res,lab,obj)
	typ = EFFECT_TYPE_CONTINUOUS | (typ or 0)
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","RAN","CTL","CON","OP","RES","LAB","LABOBJ"},{des,typ,cod,pro,ran,ctl,con,op,res,lab,obj},rc)
end
--Single Continues: Base set
function fu.ef.SC(c,des,cod,pro,ctl,con,op,rc,res,lab,obj)
	return fu.ef.B_C(c,des,1,cod,pro,nil,ctl,con,op,rc,res,lab,obj)
end
--Field Continues: Base set
function fu.ef.FC(c,des,cod,pro,ran,ctl,con,op,rc,res,lab,obj)
	return fu.ef.B_C(c,des,2,cod,pro,ran,ctl,con,op,rc,res,lab,obj)
end
--------------------------------------------------------------------------"Effect_Ignition"
--Ignition Effect: Base set
function fu.ef.I(c,des,cat,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.Creat(c,{"DES","CAT","TYP","PRO","RAN","CTL","CON","COS","TG","OP","RES","LAB","LABOBJ"},
		{des,cat,EFFECT_TYPE_IGNITION,pro,ran,ctl,con,cos,tg,op,res,lab,obj},rc)
end
--------------------------------------------------------------------------"Effect_Tigger"
--Tigger Effect: Base set
function fu.ef.B_T(c,des,typ,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","RAN","CTL","CON","COS","TG","OP","RES","LAB","LABOBJ"},
		{des,cat,typ,cod,pro,ran,ctl,con,cos,tg,op,res,lab,obj},rc)
end
--Field Tigger Effect No Force: Base set
function fu.ef.FTO(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.B_T(c,des,258,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--Field Tigger Effect Force: Base set
function fu.ef.FTF(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.B_T(c,des,1026,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--Self Tigger Effect No Force: Base set
function fu.ef.STO(c,des,cat,cod,pro,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.B_T(c,des,257,cat,cod,pro,nil,ctl,con,cos,tg,op,rc,res,lab,obj)
end 
--Self Tigger Effect Force: Base set
function fu.ef.STF(c,des,cat,cod,pro,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fu.ef.B_T(c,des,1025,cat,cod,pro,nil,ctl,con,cos,tg,op,rc,res,lab,obj)
end