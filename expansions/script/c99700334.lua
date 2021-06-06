--‌灵界极光之地&探寻者
function c99700334.initial_effect(c)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700334,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99700334)
	e1:SetCondition(c99700334.tfcon)
	e1:SetTarget(c99700334.tftg)
	e1:SetOperation(c99700334.tfop)
	c:RegisterEffect(e1)
	--toGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700334,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE+LOCATION_SZONE)
	e2:SetCondition(c99700334.tgcon)
	e2:SetTarget(c99700334.tgtg)
	e2:SetOperation(c99700334.tgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700334,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_FZONE+LOCATION_SZONE)
	e3:SetCondition(c99700334.thcon)
	e3:SetTarget(c99700334.thtg)
	e3:SetOperation(c99700334.thop)
	c:RegisterEffect(e3)
	--set field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99700334,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,99700335)
	e4:SetCondition(c99700334.sfcon)
	e4:SetTarget(c99700334.tftg)
	e4:SetOperation(c99700334.tfop)
	c:RegisterEffect(e4)
end
function c99700334.tffilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)
end
function c99700334.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99700334.tffilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c99700334.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if c==nil then return true end
end
function c99700334.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_FIELD)
		c:RegisterEffect(e1)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
		Duel.MoveSequence(c,5)
		Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c99700334.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfd03) and c:IsControler(tp) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c99700334.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99700334.cfilter,1,nil,tp) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_FIELD
end
function c99700334.tgfilter(c,tp,eg)
	return eg:IsContains(c) and Duel.IsExistingMatchingCard(c99700334.tgfilter1,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c99700334.tgfilter1(c,att)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAttribute(att) and c:IsAbleToGrave()
end
function c99700334.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99700334.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c99700334.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg)
		and Duel.GetFlagEffect(tp,99700334)==0 end
	Duel.RegisterFlagEffect(tp,99700334,RESET_CHAIN,0,1)
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c99700334.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99700334.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcc=Duel.GetFirstTarget()
	if tcc:IsRelateToEffect(e) and tcc:IsFaceup() then
		local att=tcc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c99700334.tgfilter1,tp,LOCATION_DECK,0,1,1,nil,att)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_GRAVE)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c99700334.thlimit)
			e0:SetLabel(att)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c99700334.thlimit(e,c,tp,re)
	return c:IsAttribute(e:GetLabel()) and re and re:GetHandler():IsCode(99700334)
end
function c99700334.cfilter1(c,tp)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_FZONE))
end
function c99700334.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99700334.cfilter1,1,nil,tp)
end
function c99700334.thfilter1(c,tp,eg)
	return eg:IsContains(c) and c:IsSetCard(0xfd03) and Duel.IsExistingMatchingCard(c99700334.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c99700334.thfilter(c,lv)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsLevel(lv) and c:IsAbleToHand()
end
function c99700334.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99700334.thfilter1(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c99700334.thfilter1,tp,LOCATION_GRAVE,0,1,nil,tp,eg)
		and Duel.GetFlagEffect(tp,99700334)==0 end
	Duel.RegisterFlagEffect(tp,99700334,RESET_CHAIN,0,1)
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c99700334.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99700334.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ttc=Duel.GetFirstTarget()
	if ttc:IsRelateToEffect(e) and ttc:IsLocation(LOCATION_GRAVE) then
		local lv=ttc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c99700334.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c99700334.thlimit1)
			e0:SetLabel(lv)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c99700334.thlimit1(e,c,tp,re)
	return c:IsLevel(e:GetLabel()) and re and re:GetHandler():IsCode(99700334)
end
function c99700334.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) or e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
