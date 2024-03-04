--都市之翼 脑叶公司
local s,id,o=GetID()
s.setcard="moon_City"
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(s.condition)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--td
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TURN_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(s.eefilter)
	c:RegisterEffect(e5)
	--cannot activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetValue(s.efilter1)
	c:RegisterEffect(e6)
	--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SSET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetTarget(s.efilter2)
	c:RegisterEffect(e7)
end
function s.spfilter(c,e,tp)
	return c.setcard=="Abnormality" and c:IsAbleToHand()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,c) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,g,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	Duel.SetChainLimit(s.chainlm)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,c)
	if sg then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.BreakEffect()
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,4,nil,e,tp)
			if g then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end
function s.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER) and not e:GetHandler():IsType(TYPE_SPELL) and not e:GetHandler():IsType(TYPE_TRAP)
end
function s.thfilter(c)
   return c.setcard=="Abnormality" and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ConfirmCards(1-tp,spcard)
		Duel.ShuffleHand(tp)
	else Duel.ShuffleDeck(tp) end
end
function s.tdfilter(c)
   return c.setcard=="Abnormality" and c:IsAbleToDeck()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.eefilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.efilter1(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) or rc:IsType(TYPE_MONSTER) and rc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and rc.setcard~="Abnormality"
end
function s.efilter2(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
