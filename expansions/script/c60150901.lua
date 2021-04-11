--幻想曲T致命旋律 起源
function c60150901.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c60150901.target)
	e1:SetOperation(c60150901.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c60150901.descost)
	e2:SetTarget(c60150901.destg)
	e2:SetOperation(c60150901.activate)
	c:RegisterEffect(e2)
end
function c60150901.filter(c)
	return c:IsSetCard(0x6b23) and c:IsType(TYPE_MONSTER) and not c:IsCode(60150901) and c:IsAbleToHand()
end
function c60150901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150901.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60150901.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150901.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150901.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c60150901.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60150901.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150901.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c60150901.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60150901.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.SendtoHand(tc,nil,2,REASON_EFFECT)~=0 then
			if  tc:IsType(TYPE_SYNCHRO) then
				if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
					or not Duel.IsPlayerCanSpecialSummonMonster(tp,60150987,0,0x4011,100,2000,1,RACE_FAIRY,ATTRIBUTE_DARK) then return end
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,60150987)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			else
				if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
					or not Duel.IsPlayerCanSpecialSummonMonster(tp,60150988,0,0x4011,tc:GetAttack(),tc:GetDefense(),tc:GetLevel(),RACE_FAIRY,ATTRIBUTE_DARK) then return end
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,60150988)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_BASE_ATTACK)
				e1:SetValue(tc:GetAttack()+1000)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_BASE_DEFENSE)
				e2:SetValue(tc:GetDefense())
				token:RegisterEffect(e2)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_LEVEL)
				e3:SetValue(tc:GetLevel())
				token:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c60150901.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK))
end