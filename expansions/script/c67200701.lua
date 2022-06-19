--枪塔的粘体
function c67200701.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200701,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCost(c67200701.spcost)
	e4:SetTarget(c67200701.sptg)
	e4:SetOperation(c67200701.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
--
function c67200701.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67f)
end
function c67200701.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200701.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200701,2))
	local g=Duel.SelectMatchingCard(tp,c67200701.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoExtraP(tc,tp,REASON_COST)
end
function c67200701.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsAbleToHand,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:GetCount()>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c67200701.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local x=0
			local y=0
			local tc=g:GetFirst()
			while tc do
				y=tc:GetBaseAttack()
				x=x+y
				tc=g:GetNext()
			end
			--
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(x)
			e1:SetReset(RESET_EVENT+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end



