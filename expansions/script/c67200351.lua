--烂漫的神杰 瓦雷弗尔
function c67200351.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c) 

	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200351,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c67200351.spcon)
	e2:SetTarget(c67200351.sptg)
	e2:SetOperation(c67200351.spop)
	c:RegisterEffect(e2)   
end
--
function c67200351.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c67200351.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200351.cfilter,1,nil)
end
function c67200351.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200351.thfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(c67200351.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c67200351.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c67200351.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local eeg=eg:Filter(c67200351.thfilter1,nil,tp) 
		if eeg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200351,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200351,7))
			local cg=eeg:Select(tp,1,1,nil)
			Duel.HintSelection(cg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c67200351.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetCode())
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end