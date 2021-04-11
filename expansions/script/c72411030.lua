--马纳历亚防御阵
function c72411030.initial_effect(c)
	aux.AddCodeList(c,72411031)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c72411030.target)
	e1:SetOperation(c72411030.activate)
	c:RegisterEffect(e1)   
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,72411030)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c72411030.thcon)
	e2:SetTarget(c72411030.thtg)
	e2:SetOperation(c72411030.thop)
	c:RegisterEffect(e2)
end
function c72411030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72411031,0,0x4011,1000,1000,1,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c72411030.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,72411031,0,0x4011,1000,1000,1,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,72411031)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(c72411030.linklimit)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e6:SetValue(c72411030.synlimit)
		token:RegisterEffect(e6)
	end
	Duel.SpecialSummonComplete()
end
function c72411030.linklimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end
function c72411030.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end
--e2
function c72411030.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5729)
end
function c72411030.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c72411030.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c72411030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c72411030.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end