--fucg_lib
local m=20000000
if not pcall(function() require("expansions/script/c20099999") end) then require("script/c20099999") end
local fu = fucg
if fu.lib then return end
fu.lib = true
--------------------------------------------------------------------------"Effect Function"
function fu.ef.Creat(c,f,v,rc)
--Creat Effect
	local t = 1
	local s = {}
	for i,V in pairs(v) do
		if type(V) == "table" and not (f[i] == "RAN" or f[i] == "CTL" or f[i] == "RES" or f[i] == "TRAN") then
			t = #v[i] > t and #v[i] or t
			table.insert(s,i)
		end
	end
	if #s == 1 and f[s[1] ] == "DES" then s = {};t = 1 end
	local e = {}
	local V = table.move(v,1,#v,1,{})
	for i = 1,t do
		for _,S in ipairs(s) do
			V[S] = v[S][i]
		end
		e[i] = fu.ef.Set(fu.eff.CRE(fu.sf.GetCardTable(c)[1]),f,V)
		if rc then fu.ef.Register(e,rc)end
	end
	return table.unpack(e)
end
function fu.ef.Set(e,f,v)
--Set Effect detail
	e = type(e) == "table" and e or { e }
	f = type(f) == "table" and f or { f }
	v = type(v) == "table" and v or { v }
	for _,E in ipairs(e) do
		if #f == 1 then
			(type(f[1]) == "string" and fu.eff[f[1] ] or f[1])(E,table.unpack(v))
		else
			for i,F in ipairs(f) do
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
function fu.ef.A(c,des,cat,cod,pro,ctl,res,con,cos,tg,op,rc)
	if not cod then cod = EVENT_FREE_CHAIN end
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","CTL","RES","CON","COS","TG","OP"},{des,cat,EFFECT_TYPE_ACTIVATE,cod,pro,ctl,res,con,cos,tg,op},rc)
end  
--------------------------------------------------------------------------"Effect_Single"
--Single Effect: Base set
function fu.ef.S(c,des,cod,pro,ran,val,ctl,res,con,rc)
	if des then pro = pro | EFFECT_FLAG_CLIENT_HINT end 
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","RAN","VAL","CTL","RES","CON"},{des,EFFECT_TYPE_SINGLE,cod,pro,ran,val,ctl,res,con},rc)
end
--------------------------------------------------------------------------"Effect_Field"
--Field Effect: Base set
function fu.ef.B_F(c,des,typ,cod,pro,ran,tran,val,ctl,res,con,tg,lab,labobj,rc)
	typ = EFFECT_TYPE_FIELD | (typ or 0)
	pro = pro | (des and EFFECT_FLAG_CLIENT_HINT or 0)
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","RAN","TRAN","VAL","CTL","RES","CON","TG","LAB","LABOBJ"},
		{des,typ,cod,pro,ran,tran,val,ctl,res,con,tg,lab,labobj},rc)
end
function fu.ef.F(c,des,cod,pro,ran,tran,val,ctl,res,con,tg,rc)
	return fu.ef.B_F(c,des,nil,cod,pro,ran,tran,val,ctl,res,con,tg,nil,nil,rc)
end
--------------------------------------------------------------------------"Effect_Qucik"
--Quick Effect No Force: Base set
function fu.ef.B_QO(c,des,cat,typ,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
	if not cod then cod = EVENT_FREE_CHAIN end
	local Typ = typ and typ + EFFECT_TYPE_QUICK_O or EFFECT_TYPE_QUICK_O
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","RAN","CTL","RES","CON","COS","TG","OP"},{des,cat,Typ,cod,pro,ran,ctl,res,con,cos,tg,op},rc)
end 
--Quick Effect Force: Base set
function fu.ef.B_QF(c,des,cat,typ,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
	if not cod then cod = EVENT_FREE_CHAIN end
	local Typ = typ and typ + EFFECT_TYPE_QUICK_F or EFFECT_TYPE_QUICK_F
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","RAN","CTL","RES","CON","COS","TG","OP"},{des,cat,Typ,cod,pro,ran,ctl,res,con,cos,tg,op},rc)
end 
--Quick Effect No Force: Base set
function fu.ef.QO(c,des,cat,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
	return fu.ef.B_QO(c,des,cat,nil,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
end 
--Quick Effect Force: Base set
function fu.ef.QF(c,des,cat,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
	return fu.ef.B_QF(c,des,cat,nil,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
end 
--------------------------------------------------------------------------"Effect_Single_Continuous"
--Single Continues: Base set
function fu.ef.SC(c,des,cod,pro,ctl,res,con,op,rc)
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","CTL","RES","CON","OP"},{des,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,cod,pro,ctl,res,con,op},rc)
end
--------------------------------------------------------------------------"Effect_Field_Continuous"
--Field Continues: Base set
function fu.ef.B_FC(c,des,typ,cod,pro,ran,ctl,res,con,op,rc)
	local Typ = typ and typ + EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS or EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS 
	return fu.ef.Creat(c,{"DES","TYP","COD","PRO","RAN","CTL","RES","CON","OP"},{des,Typ,cod,pro,ran,ctl,res,con,op},rc)
end
--Field Continues: Base set
function fu.ef.FC(c,des,cod,pro,ran,ctl,res,con,op,rc)
	return fu.ef.B_FC(c,des,nil,cod,pro,ran,ctl,res,con,op,rc)
end
--------------------------------------------------------------------------"Effect_Ignition"
--Ignition Effect: Base set
function fu.ef.I(c,des,cat,pro,ran,ctl,res,con,cos,tg,op,rc)
	return fu.ef.Creat(c,{"DES","CAT","TYP","PRO","RAN","CTL","RES","CON","COS","TG","OP"},{des,cat,EFFECT_TYPE_IGNITION,pro,ran,ctl,res,con,cos,tg,op},rc)
end
--------------------------------------------------------------------------"Effect_Tigger"
--Field Tigger Effect No Force: Base set
function fu.ef.FTO(c,des,cat,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","RAN","CTL","RES","CON","COS","TG","OP"},
						{des,cat,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD,cod,pro,ran,ctl,res,con,cos,tg,op},rc)
end
--Field Tigger Effect Force: Base set
function fu.ef.FTF(c,des,cat,cod,pro,ran,ctl,res,con,cos,tg,op,rc)
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","RAN","CTL","RES","CON","COS","TG","OP"},
						{des,cat,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD,cod,pro,ran,ctl,res,con,cos,tg,op},rc)
end
--Self Tigger Effect No Force: Base set
function fu.ef.STO(c,des,cat,cod,pro,ctl,res,con,cos,tg,op,rc)
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","CTL","RES","CON","COS","TG","OP"},
						{des,cat,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE,cod,pro,ctl,res,con,cos,tg,op},rc)
end 
--Self Tigger Effect Force: Base set
function fu.ef.STF(c,des,cat,cod,pro,ctl,res,con,cos,tg,op,rc)
	return fu.ef.Creat(c,{"DES","CAT","TYP","COD","PRO","CTL","RES","CON","COS","TG","OP"},
						{des,cat,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE,cod,pro,ctl,res,con,cos,tg,op},rc)
end