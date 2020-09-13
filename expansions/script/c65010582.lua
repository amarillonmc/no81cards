--白月骑士的激斗
if not pcall(function() require("expansions/script/c65010579") end) then require("script/c65010579") end
local m,cm=rscf.DefineCard(65010582,"WMKnight")
function cm.initial_effect(c)
	local e1=rswk.EquipEffect(c,m)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(rscon.phmp)
	e2:SetCost(rscost.lpcost(800))
	e2:SetTarget(rsop.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD))
	e2:SetOperation(cm.desop)
	rswk.GainEffect(c,e2)   
end
function cm.desop(e,tp)
	rsop.SelectDestroy(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
end