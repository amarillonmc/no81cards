--幻兽佣兵团 术师-赤狐
function c33200424.initial_effect(c)
	--when this card sm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200424,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33200426)
	e1:SetCondition(c33200424.con)
	e1:SetTarget(c33200424.tg)
	e1:SetOperation(c33200424.op)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33200424)
	e2:SetTarget(c33200424.thtg)
	e2:SetOperation(c33200424.thop)
	c:RegisterEffect(e2)
end

--e1
function c33200424.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c33200424.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33200426,0,0x4011,1000,1500,4,RACE_BEASTWARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33200424.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33200426,0,0x4011,1000,1500,4,RACE_BEASTWARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) then return end
	local token=Duel.CreateToken(tp,33200426)
	if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) then
		local fid=e:GetHandler():GetFieldID()
		token:RegisterFlagEffect(33200424,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(token)
		e1:SetCondition(c33200424.descon)
		e1:SetOperation(c33200424.desop)
		Duel.RegisterEffect(e1,tp)
	end 
	Duel.SpecialSummonComplete()
	if Duel.GetFlagEffect(tp,33200424)~=0 then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(33200424,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x329))
	e2:SetValue(0x1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,22404675,RESET_PHASE+PHASE_END,0,1)
end
function c33200424.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33200424)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c33200424.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end

--e2
function c33200424.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c33200424.filter2,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c33200424.filter2(c,att)
	return c:IsSetCard(0xc329) and c:IsAbleToHand() and not c:IsAttribute(att)
end
function c33200424.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(c33200424.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200424,0))
	Duel.SelectTarget(tp,c33200424.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200424.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c33200424.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
