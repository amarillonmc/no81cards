--创生惑星 忒伊亚
function c9910819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910819+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910819.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c9910819.regcon)
	e2:SetOperation(c9910819.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c9910819.thfilter(c)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910819.rfilter(c,tp)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c9910819.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9910819.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=g1:GetCount()>0 and g2:GetCount()>0
	local b2=Duel.CheckReleaseGroup(tp,c9910819.rfilter,1,nil,tp)
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(9910819,0)) then
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910819,1),aux.Stringid(9910819,2))==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg1=g1:Select(tp,1,1,nil)
			if Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetCondition(c9910819.thcon1)
			e1:SetOperation(c9910819.thop1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg2=Duel.SelectReleaseGroup(tp,c9910819.rfilter,1,1,nil,tp)
			if Duel.Release(rg2,REASON_EFFECT)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg2)
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetCondition(c9910819.thcon2)
			e2:SetOperation(c9910819.thop2)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c9910819.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckReleaseGroup(tp,c9910819.rfilter,1,nil,tp)
end
function c9910819.thop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910819,3)) then return end
	Duel.Hint(HINT_CARD,0,9910819)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg2=Duel.SelectReleaseGroup(tp,c9910819.rfilter,1,1,nil,tp)
	if Duel.Release(rg2,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(sg2)
	Duel.SendtoHand(sg2,nil,REASON_EFFECT)
end
function c9910819.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9910819.thfilter,tp,LOCATION_DECK,0,nil)
	return g1:GetCount()>0 and g2:GetCount()>0
end
function c9910819.thop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910819,4)) then return end
	Duel.Hint(HINT_CARD,0,9910819)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9910819.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg1=g1:Select(tp,1,1,nil)
	if Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g2:Select(tp,1,1,nil)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
function c9910819.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910819.regop(e,tp,eg,ep,ev,re,r,rp)
	local rct=1
	if Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910819.tkcon)
	e1:SetOperation(c9910819.tkop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,rct)
	e1:SetLabel(Duel.GetTurnCount()+1)
	Duel.RegisterEffect(e1,tp)
end
function c9910819.tkcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=e:GetLabel() then return false end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.IsPlayerCanSpecialSummonMonster(tp,9910801,0x6951,0x4011,0,500,1,RACE_FAIRY,ATTRIBUTE_LIGHT) or Duel.IsPlayerCanSpecialSummonMonster(tp,9910802,0x6951,0x4011,500,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT))
end
function c9910819.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_CARD,0,9910819)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local flag=false
	if Duel.IsPlayerCanSpecialSummonMonster(tp,9910801,0x6951,0x4011,0,500,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
		and Duel.SelectYesNo(tp,aux.Stringid(9910819,5)) then
		local token=Duel.CreateToken(tp,9910801)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			flag=true
			ft=ft-1
		end
	end
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9910802,0x6951,0x4011,500,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
		and (not flag or Duel.SelectYesNo(tp,aux.Stringid(9910819,6))) then
		local token=Duel.CreateToken(tp,9910802)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			flag=true
		end
	end
	if flag then Duel.SpecialSummonComplete() end
end
