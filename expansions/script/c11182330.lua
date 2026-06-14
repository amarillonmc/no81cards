--地岩纵宸
function c11182330.initial_effect(c)
	aux.AddCodeList(c,ATTRIBUTE_EARTH)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11182330)
	e1:SetOperation(c11182330.op)
	c:RegisterEffect(e1)
	--special
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11182330+1)
	e2:SetCondition(c11182330.dspcon)
	e2:SetTarget(c11182330.dsptg)
	e2:SetOperation(c11182330.dspop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e22)
end
function c11182330.dspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if c:IsReason(REASON_BATTLE) then tc=c:GetBattleTarget() end
	if c:IsReason(REASON_EFFECT+REASON_COST) then tc=re:GetHandler() end
	return tc and tc:IsSetCard(0x6454)
end
function c11182330.dspfilter(c,e,tp)
	return c:IsSetCard(0x6454) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11182330.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182330.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11182330.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11182330.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11182330.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6454))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local ch=Duel.GetCurrentChain()
	if ch>1 then
		local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
		if code==11182330  then
			local g=Duel.GetMatchingGroup(aux.AND(Card.IsSetCard,Card.IsFaceup),tp,0x4,0,nil)
			local tc=g:GetFirst()
			while tc do
				--immune
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetValue(c11182330.efilter)
				e3:SetReset(RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				tc=g:GetNext()
			end
		end
	end
end
function c11182330.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end