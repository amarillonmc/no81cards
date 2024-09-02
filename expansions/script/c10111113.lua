function c10111113.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10111113.lcheck)
	c:EnableReviveLimit() 
   	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111113,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10111113)
	e1:SetTarget(c10111113.thtg)
	e1:SetOperation(c10111113.thop)
	c:RegisterEffect(e1)
    	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c10111113.aclimit)
	c:RegisterEffect(e2)
    	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111113,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetCountLimit(1,101111130)
	e3:SetTarget(c10111113.adtg)
	e3:SetOperation(c10111113.adop)
	c:RegisterEffect(e3)
end
function c10111113.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x12d)
end
function c10111113.thfilter(c)
	return c:IsSetCard(0x12d) and c:IsAbleToHand()
end
function c10111113.rettfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsSummonable(true,nil)
end
function c10111113.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111113.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c10111113.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10111113.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c10111113.rettfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(10111113,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c10111113.rettfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function c10111113.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE)
end
function c10111113.adfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST)
end
function c10111113.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111113.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10111113.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10111113.adfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end