--食时之城
function c9980192.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980192,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9980192.atktg)
	e2:SetOperation(c9980192.atkop)
	c:RegisterEffect(e2)
	--to field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980192,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,9980192)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c9980192.tfcon)
	e4:SetTarget(c9980192.tftg)
	e4:SetOperation(c9980192.tfop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9980192.desreptg)
	e3:SetValue(c9980192.desrepval)
	e3:SetOperation(c9980192.desrepop)
	c:RegisterEffect(e3)
end
function c9980192.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc8)
end
function c9980192.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9980192.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980192.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980192.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9980192.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9980192.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980192.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9980192.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetSum(Card.GetRank)
	local tc=Duel.GetFirstTarget()
	if ct>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980192,0))
end
function c9980192.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6bc8) and c:IsControler(tp)
end
function c9980192.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c9980192.cfilter,1,nil,tp)
end
function c9980192.tffilter(c)
	return c:IsSetCard(0x6bc8) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9980192.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9980192.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9980192.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9980192.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980192,0))
end
function c9980192.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_DRAGON) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9980192.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c9980192.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()==1 and eg:IsExists(c9980192.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9980192.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c9980192.desrepval(e,c)
	return c9980192.repfilter(c,e:GetHandlerPlayer())
end
function c9980192.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9980192.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980192,0))
end
