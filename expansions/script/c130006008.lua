--久远第4机关 普罗维登斯
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006008)
function cm.initial_effect(c)
	local e1 = rsef.QO(c,nil,nil,nil,"tg",nil,LOCATION_HAND,nil,cm.cost,rsop.target(cm.tgfilter,"tg",0,LOCATION_ONFIELD),cm.act)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,c) and Duel.CheckLPCost(tp,1000) end
	rsop.SelectToGrave(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,c,{REASON_COST})
	Duel.PayLPCost(tp,1000)
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.act(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,{})
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LPCOST_CHANGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.lp)
	Duel.RegisterEffect(e1,tp)
end
function cm.lp(e,re,rp,val)
	local lp = Duel.GetLP(rp)
	if re and re:IsActivated() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		return lp <= val * 2 and lp or val * 2
	else return val end
end