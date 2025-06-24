--「」下级二号
function c44401002.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	--e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	--e1:SetCost(c44401002.cost)
	e1:SetTarget(c44401002.sptg)
	e1:SetOperation(c44401002.spop)
	c:RegisterEffect(e1)
	--run!
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_QUICK_F)
	e0:SetCode(EVENT_BECOME_TARGET)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c44401002.runcon)
	e0:SetCost(c44401002.run)
	--e0:SetTarget(c44401002.runtg)
	e0:SetOperation(c44401002.runop)
	c:RegisterEffect(e0)
end
function c44401002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(44401002,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c44401002.sumfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsSummonable(true,nil)
end
function c44401002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
end
function c44401002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c44401002.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(44401002,0)) then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		local tg=Duel.GetMatchingGroup(c44401002.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local tc=tg:GetFirst()
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			tc=tg:Select(tp,1,1,nil):GetFirst()
		end
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function c44401002.runcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c44401002.run(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetLabelObject(c)
		e0:SetCountLimit(1)
		e0:SetOperation(c44401002.retop)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(44401002,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(44401001)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function c44401002.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c44401002.runtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c44401002.runop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(-500)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
