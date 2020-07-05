--虚拟水神泳者
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020209,"VrAqua")
function cm.initial_effect(c)
	local e1,e2,e3=rsva.MonsterEffect(c,m,cm.op)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FV_CANNOT_BE_TARGET({c,tp},"effect",aux.tgoval,cm.tg,{LOCATION_MZONE,0},nil,rsreset.pend)
	local e2=rsef.FV_INDESTRUCTABLE({c,tp},"effect",1,cm.tg,{LOCATION_MZONE,0},nil,rsreset.pend)
end
function cm.tg(e,c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsLevel(10)
end