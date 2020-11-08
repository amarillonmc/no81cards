--甜心机仆 初见的礼物
function c9910559.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3951))
	e1:SetValue(c9910559.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c9910559.regop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3951))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to grave/hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,9910559)
	e4:SetCondition(c9910559.thcon)
	e4:SetTarget(c9910559.thtg)
	e4:SetOperation(c9910559.thop)
	c:RegisterEffect(e4)
end
function c9910559.val(e,c)
	local ct=e:GetHandler():GetFlagEffectLabel(9910559)
	if not ct then return 0 end
	return ct
end
function c9910559.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) then
		local ct=c:GetMaterialCount()
		c:RegisterFlagEffect(9910559,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0,ct*500)
	end
end
function c9910559.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910559.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910559,0))
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
end
function c9910559.locfilter(c,sp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(sp)
end
function c9910559.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SelectOption(tp,aux.Stringid(9910559,1),aux.Stringid(9910559,2))==0 then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	else
		Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(c9910559.locfilter,nil,1-tp)
		if ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
			Duel.ShuffleHand(1-tp)
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			Duel.ShuffleHand(1-tp)
		end
	end
end

