--术结天缘 静寂咏唱
function c67200425.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200425+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67200425.cost)
	e1:SetTarget(c67200425.target)
	e1:SetOperation(c67200425.activate)
	c:RegisterEffect(e1)  
end
--
function c67200425.excostfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c67200425.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c67200425.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x671)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c67200425.excostfilter,tp,LOCATION_ONFIELD,0,1,c) and rt>0 
	end
	local gg=Duel.GetMatchingGroup(c67200425.excostfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200425.excostfilter,tp,LOCATION_ONFIELD,0,1,gg:GetCount(),c)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100*rt*g:GetCount())
	e:SetLabel(g:GetCount())
end
function c67200425.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	local rt=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x671)
	if rt>0 then
		Duel.Damage(1-tp,100*rt*label,REASON_EFFECT)
	end
end