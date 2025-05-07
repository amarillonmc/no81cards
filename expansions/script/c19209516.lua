--判决牢狱的囚犯 02樫木优乃
function c19209516.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209516)
	e1:SetCondition(c19209516.spcon)
	e1:SetTarget(c19209516.sptg)
	e1:SetOperation(c19209516.spop)
	c:RegisterEffect(e1)
	--monster effect
	--to pzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209517)
	e2:SetTarget(c19209516.pztg)
	e2:SetOperation(c19209516.pzop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1190)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e4:SetCountLimit(1,19209518)
	e4:SetCondition(c19209516.thcon)
	e4:SetTarget(c19209516.thtg)
	e4:SetOperation(c19209516.thop)
	c:RegisterEffect(e4)
end
function c19209516.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209516.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209516.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetTarget(c19209516.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(19209516,0))
	end
	Duel.SpecialSummonComplete()
end
function c19209516.efilter(e,c,rp,r,re)
	return c==e:GetHandler() and re and r&REASON_EFFECT>0 and rp==1-e:GetHandlerPlayer()
end
function c19209516.pfilter(c)
	return c:IsCode(19209511) and not c:IsForbidden()
end
function c19209516.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c19209516.pfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c19209516.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.CheckLocation(tp,LOCATION_PZONE,0)
		and Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c19209516.pfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c19209516.chkfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_EXTRA)
		and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP)
end
function c19209516.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19209516.chkfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c19209516.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c19209516.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
