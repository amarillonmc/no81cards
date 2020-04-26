--韶光少女 僧间理亚
function c9910451.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c9910451.spcon)
	e1:SetCost(c9910451.spcost)
	e1:SetTarget(c9910451.sptg)
	e1:SetOperation(c9910451.spop)
	c:RegisterEffect(e1)
end
function c9910451.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9910451.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9910451.pufilter(c)
	return not c:IsPublic()
end
function c9910451.costfilter(c,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c9910451.pufilter,tp,LOCATION_HAND,0,1,c)
end
function c9910451.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c9910451.costfilter,tp,LOCATION_HAND,0,1,nil,tp)
		else
			return Duel.IsExistingMatchingCard(c9910451.pufilter,tp,LOCATION_HAND,0,1,nil)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c9910451.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910451.thfilter(c,tp)
	return c:IsSetCard(0x9950) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,c:GetCode())
end
function c9910451.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c9910451.pufilter,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			if g:GetCount()==0 then return end
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			if g:GetClassCount(Card.GetCode)==g:GetCount()
				and Duel.IsExistingMatchingCard(c9910451.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(9910451,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,c9910451.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
				if sg:GetCount()>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end 
end
