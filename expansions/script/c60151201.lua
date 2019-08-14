--无我心 两仪式
function c60151201.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60151201.condition2)
	e1:SetOperation(c60151201.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151201,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,60151201)
	e2:SetCondition(c60151201.spcon)
	e2:SetTarget(c60151201.sptg)
	e2:SetOperation(c60151201.spop)
	c:RegisterEffect(e2)
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c60151201.rlevel)
	c:RegisterEffect(e3)
end
function c60151201.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xab23) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c60151201.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c60151201.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		if c:GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
			Duel.Hint(HINT_CARD,0,60151201)
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			local atk=c:GetAttack()
			local atk1=tc:GetAttack()
			local def1=tc:GetDefense()
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
				Duel.Hint(HINT_CARD,0,60151201)
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
end
function c60151201.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function c60151201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151201.cfilter,1,nil)
end
function c60151201.filter(c)
	return c:IsSetCard(0xab23) and c:IsType(TYPE_MONSTER) and not c:IsCode(60151201) and c:IsAbleToHand()
end
function c60151201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151201.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151201.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60151201.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end