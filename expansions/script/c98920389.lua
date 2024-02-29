--防火龙·暗流体-负质量
function c98920389.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c98920389.lcheck)
	c:EnableReviveLimit()
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920389,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920389.negcon)
	e2:SetTarget(c98920389.negtg)
	e2:SetOperation(c98920389.negop)
	c:RegisterEffect(e2)
--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c98920389.matcon)
	e5:SetOperation(c98920389.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c98920389.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920389,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,98920389)
	e3:SetCondition(c98920389.condition2)
	e3:SetTarget(c98920389.target2)
	e3:SetOperation(c98920389.operation2)
	c:RegisterEffect(e3)
end
function c98920389.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x18f)
end
function c98920389.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and c:GetFlagEffectLabel(98920390) and c:GetFlagEffectLabel(98920390)>0
end
function c98920389.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(98920389)<c:GetFlagEffectLabel(98920390) end
	c:RegisterFlagEffect(98920389,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920389.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98920389.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function c98920389.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920390,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c98920389.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsLinkSetCard,nil,0x18f)
	e:GetLabelObject():SetLabel(ct)
end
function c98920389.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c98920389.tgfilter2(c,check)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end
function c98920389.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920389.tgfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920389.tgfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920389.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920389.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end