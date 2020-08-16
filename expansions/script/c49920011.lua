--召唤强制夺取
function c49920011.initial_effect(c)
 --control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(49920011,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c49920011.condition)
	e1:SetCost(c49920011.ctcost)
	e1:SetTarget(c49920011.cttg)
	e1:SetOperation(c49920011.ctop)
	c:RegisterEffect(e1)
end
function c49920011.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c49920011.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49920011.cfilter,1,nil,1-tp)
end
function c49920011.ncostfilter(c)
	return not c:IsAbleToGraveAsCost()
end
function c49920011.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return g:GetCount()>0 and not g:IsExists(c49920011.ncostfilter,1,nil)  end
	Duel.SendtoGrave(g,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	e:SetLabel(ct)
end
function c49920011.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c49920011.ctop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c49920011.ctfilter,tp,0,LOCATION_MZONE,e:GetLabel(),e:GetLabel(),nil)
	Duel.GetControl(g,tp)
end