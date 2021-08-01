--银河眼光子幻龙
function c40009226.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009226)
	e1:SetCondition(c40009226.spcon)
	e1:SetOperation(c40009226.spop)
	c:RegisterEffect(e1)   
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009226,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009227)
	e2:SetTarget(c40009226.target)
	e2:SetOperation(c40009226.operation)
	c:RegisterEffect(e2)
end
function c40009226.cfilter1(c)
	return c:IsCode(93717133) and not c:IsPublic() 
end
function c40009226.cfilter2(c,tp)
	return c:IsSetCard(0x55) and not c:IsPublic() and not c:IsCode(40009226)
		and Duel.IsExistingMatchingCard(c40009226.cfilter3,tp,LOCATION_HAND,0,1,c)
end
function c40009226.cfilter3(c)
	return c:IsSetCard(0x7b) and not c:IsPublic() and not c:IsCode(40009226)
end
function c40009226.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c40009226.cfilter1,tp,LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(c40009226.cfilter2,tp,LOCATION_HAND,0,1,nil))
end
function c40009226.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local b1=Duel.IsExistingMatchingCard(c40009226.cfilter1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c40009226.cfilter2,tp,LOCATION_HAND,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(40009226,2))) then
		local gg=Duel.SelectMatchingCard(tp,c40009226.cfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.ConfirmCards(1-tp,gg)
		Duel.ShuffleHand(tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g1=Duel.SelectMatchingCard(tp,c40009226.cfilter2,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g2=Duel.SelectMatchingCard(tp,c40009226.cfilter3,tp,LOCATION_HAND,0,1,1,g1)
		g1:Merge(g2)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
	end
end
function c40009226.filter(c)
	return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToHand()
end
function c40009226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009226.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c40009226.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009226.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
