--电子龙二型超载
function c98920817.initial_effect(c)
	--code
	aux.EnableChangeCode(c,70095154,LOCATION_MZONE+LOCATION_GRAVE)	
	--special summon (grave)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920817,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,1142881)
	e3:SetTarget(c98920817.sptg2)
	e3:SetOperation(c98920817.spop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCondition(c98920817.effcon)
	e5:SetOperation(c98920817.effop)
	c:RegisterEffect(e5)
end
function c98920817.filter(c,e,tp)
	return c:IsCode(70095154) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920817.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920817.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920817.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920817.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920817.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if c:GetLevel()~=5 and Duel.SelectYesNo(tp,aux.Stringid(98920817,0)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(5)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c98920817.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_XYZ)~=0 and e:GetHandler():GetReasonCard():IsRace(RACE_MACHINE)
end
function c98920817.effop(e,tp,eg,ep,ev,re,r,rp)
	--atkchange
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e2=Effect.CreateEffect(rc)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(98920817,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c98920817.atktg)
	e2:SetOperation(c98920817.atkop)
	e2:SetCountLimit(1)
	rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920817,5))
end
function c98920817.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsAttack(2000) end
end
function c98920817.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetOperation(c98920817.tgop)
		e3:SetReset(RESET_EVENT+0xc6e0000)
		c:RegisterEffect(e3)
	end
end
function c98920817.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end