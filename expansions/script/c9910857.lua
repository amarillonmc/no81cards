--千恋起舞
function c9910857.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c9910857.effcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(c9910857.atklimit)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910857,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9910857)
	e4:SetCondition(c9910857.rmcon)
	e4:SetTarget(c9910857.rmtg)
	e4:SetOperation(c9910857.rmop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--set
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,9910858)
	e6:SetTarget(c9910857.settg)
	e6:SetOperation(c9910857.setop)
	c:RegisterEffect(e6)
end
function c9910857.effcon(e)
	return Duel.IsExistingMatchingCard(Card.IsDefensePos,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9910857.atklimit(e,c)
	return c:IsDefensePos()
end
function c9910857.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0xa951)
end
function c9910857.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910857.cfilter,1,nil,tp)
end
function c9910857.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function c9910857.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if ct<=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetTargetRange(0xff,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,9910850))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e1:SetValue(-ct)
	Duel.RegisterEffect(e1,tp)
end
function c9910857.setfilter(c)
	return c:IsSetCard(0xa951) and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910857.thfilter(c)
	return c:IsCode(9910850) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c9910857.sumfilter(c)
	return c:IsCode(9910850) and c:IsSummonable(true,nil)
end
function c9910857.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(c9910857.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c9910857.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9910857.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910857.setfilter,tp,LOCATION_REMOVED,0,1,nil)
		and g1:GetCount()+g2:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c9910857.setfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c9910857.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local g1=Duel.GetMatchingGroup(c9910857.thfilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(c9910857.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectOption(tp,1190,1151)==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=g2:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			if sc then Duel.Summon(tp,sc,true,nil) end
		end
	end
end
