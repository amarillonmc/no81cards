--人偶术士克拉拉
function c51925001.initial_effect(c)
	aux.AddCodeList(c,51925001)
	c:SetSPSummonOnce(51925001)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,5,c51925001.ovfilter,aux.Stringid(51925001,0))
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,51925001)
	e1:SetCondition(c51925001.condition)
	e1:SetCost(c51925001.cost)
	e1:SetTarget(c51925001.target)
	e1:SetOperation(c51925001.operation)
	c:RegisterEffect(e1)
end
function c51925001.ovfilter(c)
	return c:IsFaceup() and c:IsCode(1482001)
end
function c51925001.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c51925001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c51925001.tgfilter(c)
	return c:IsAbleToGrave() and aux.IsCodeListed(c,51925001)
end
function c51925001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51925001.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c51925001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c51925001.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
