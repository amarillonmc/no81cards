--fucgcg_lib
if not pcall(function() require("expansions/script/c20099999") end) then require("script/c20099999") end
local m=20000000
if fucg.lib then return end
fucg.lib = true
--------------------------------------------------------------------------"Effect function"
function fuef.Creat(owner,handler,...)
--Creat Effect
	--Delete nil
	local list = {...}
	local setlist = fusf.DeleteNil(list)
	--Set and Register effect
	local e = fuef.Set(fucg.eff.CRE(fusf.GetCardTable(owner)[1]),table.unpack(setlist))
	if handler then fuef.Register(e,handler) end
	return e
end
function fuef.Clone(e,handler,...)
--Clone Effect
	--Delete nil
	local list = {...}
	local setlist = fusf.DeleteNil(list)
	--Set and Register effect
	local e = fuef.Set(fucg.eff.CLO(e),table.unpack(setlist))
	if handler then fuef.Register(e,handler) end
	return e
end
function fuef.Set(e,...)
--Set Effect detail
	e = type(e) == "table" and e or { e }
	local setlist = {...}
	setlist = fusf.DeleteNil(setlist)
	if #setlist == 0 then return table.unpack(e) end
	if type(setlist[1]) ~= "table" then setlist = {setlist} end
	for _,E in ipairs(e) do
		for _,set in ipairs(setlist) do
			local f = type(set[1]) == "string" and fucg.eff[set[1] ] or set[1]
			table.remove(set,1)
			f(E,table.unpack(set))
		end
	end
	return table.unpack(e)
end
function fuef.Register(e,handler)
--Register Effect
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
--------------------------------------------------------------------------"Effect_Action"
--Action Effect: Base set
function fuef.Act(c,des,cat,typ,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Creat(c,rc,{"DES",des},{"CAT",cat},{"TYP",typ},{"COD",cod},{"PRO",pro},{"RAN",ran},
		{"CTL",ctl},{"CON",con},{"COS",cos},{"TG",tg},{"OP",op},{"RES",res},{"LAB",lab},{"LABOBJ",obj})
end  
--------------------------------------------------------------------------"Effect_Activate"
--Activate Effect: Base set
function fuef.B_A(c,des,cat,cod,pro,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_ACTIVATE,cod or "FC",pro,nil,ctl,con,cos,tg,op,rc,res,lab,obj)
end  
function fuef.A(c,cod,rc)
	return fuef.B_A(c,nil,nil,cod,nil,nil,nil,nil,nil,nil,rc)
end
--------------------------------------------------------------------------"Effect_Ignition"
--Ignition Effect: Base set
function fuef.I(c,des,cat,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_IGNITION,nil,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--------------------------------------------------------------------------"Effect_Qucik"
--Quick Effect No Force: Base set
function fuef.QO(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_QUICK_O,cod or "FC",pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--Quick Effect Force: Base set
function fuef.QF(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_QUICK_F,cod or "FC",pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--------------------------------------------------------------------------"Effect_Tigger"
--Field Tigger Effect No Force: Base set
function fuef.FTO(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O,cod or "FC",pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--Field Tigger Effect Force: Base set
function fuef.FTF(c,des,cat,cod,pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F,cod or "FC",pro,ran,ctl,con,cos,tg,op,rc,res,lab,obj)
end
--Self Tigger Effect No Force: Base set
function fuef.STO(c,des,cat,cod,pro,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O,cod or "FC",pro,nil,ctl,con,cos,tg,op,rc,res,lab,obj)
end 
--Self Tigger Effect Force: Base set
function fuef.STF(c,des,cat,cod,pro,ctl,con,cos,tg,op,rc,res,lab,obj)
	return fuef.Act(c,des,cat,EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F,cod or "FC",pro,nil,ctl,con,cos,tg,op,rc,res,lab,obj)
end   
--------------------------------------------------------------------------"Effect_NoAction"
--NoAction Effect: Base set
function fuef.NoAct(c,des,typ,cod,pro,ran,tran,val,ctl,con,tg,op,rc,res,lab,obj)
	return fuef.Creat(c,rc,{"DES",des},{"TYP",typ},{"COD",cod},{"PRO",pro},{"RAN",ran},{"TRAN",tran},{"VAL",val},
		{"CTL",ctl},{"CON",con},{"TG",tg},{"OP",op},{"RES",res},{"LAB",lab},{"LABOBJ",obj})
end  
--------------------------------------------------------------------------"Effect_Single"
--Single Effect: Base set
function fuef.S(c,des,cod,pro,ran,val,ctl,con,op,rc,res,lab,obj)
	return fuef.NoAct(c,des,EFFECT_TYPE_SINGLE,cod,pro,ran,nil,val,ctl,con,nil,op,rc,res,lab,obj)
end
function fuef.SC(c,des,cod,pro,ctl,con,op,rc,res,lab,obj)
	return fuef.NoAct(c,des,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,cod,pro,nil,nil,nil,ctl,con,nil,op,rc,res,lab,obj)
end
--------------------------------------------------------------------------"Effect_Field"
--Field Effect: Base set
function fuef.F(c,des,cod,pro,ran,tran,val,ctl,con,tg,op,rc,res,lab,obj)
	return fuef.NoAct(c,des,EFFECT_TYPE_FIELD,cod,pro,ran,tran,val,ctl,con,tg,op,rc,res,lab,obj)
end
function fuef.FC(c,des,cod,pro,ran,ctl,con,op,rc,res,lab,obj)
	return fuef.NoAct(c,des,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,cod,pro,ran,nil,nil,ctl,con,nil,op,rc,res,lab,obj)
end