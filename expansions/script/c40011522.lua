--昔日之黑暗骑士 影潜者 奥布斯克迪特
function c40011522.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c40011522.transcon)
	e2:SetOperation(c40011522.transop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,40011522)
	e3:SetTarget(c40011522.thxtg)
	e3:SetOperation(c40011522.thxop)
	c:RegisterEffect(e3)
end
function c40011522.thxfilter(c)
	return c:IsSetCard(0xaf1b) and not c:IsCode(40011522) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40011522.thxtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40011522.thxfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40011522.thxfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c40011522.thxfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c40011522.thxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		--extra attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c40011522.transcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==40011522 and c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c40011522.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(9911635,true)
	c:ReplaceEffect(9911635,0,0)
end
