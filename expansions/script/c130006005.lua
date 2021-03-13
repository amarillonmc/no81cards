--失乐第7机关 妲塔林
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006005)
function cm.initial_effect(c)
	local e1 = rsef.QO(c,nil,"tg",nil,"tg",nil,LOCATION_HAND,nil,cm.cost,rsop.target(Card.IsAbleToGrave,"tg",LOCATION_MZONE,LOCATION_MZONE),cm.op)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.CheckLPCost(tp,1000) end
	rsop.SelectToGrave(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),{REASON_COST})
	Duel.PayLPCost(tp,1000)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.op(e,tp)
	rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,{})
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
	if re and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) then
		return lp <= val * 2 and lp or val * 2
	else return val end
end