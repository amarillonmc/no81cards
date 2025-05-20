-- 面灵气 秦心※心貌百面
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.equip(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Hnk.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
	or Duel.IsExistingMatchingCard(Hnk.eqfilter,tp,LOCATION_HAND,0,1,nil,c,tp)
	or Duel.IsExistingMatchingCard(Hnk.eqfilter,tp,LOCATION_GRAVE,0,1,nil,c,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(Hnk.eqfilter,tp,LOCATION_HAND,0,1,nil,c,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eqc=Duel.SelectMatchingCard(tp,Hnk.eqfilter,tp,LOCATION_HAND,0,1,1,nil,c,tp)
			Duel.Equip(tp,eqc:GetFirst(),c,true,true)
		end
		if Duel.IsExistingMatchingCard(Hnk.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eqc=Duel.SelectMatchingCard(tp,Hnk.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c,tp)
			Duel.Equip(tp,eqc:GetFirst(),c,true,true)
		end
		if Duel.IsExistingMatchingCard(Hnk.eqfilter,tp,LOCATION_GRAVE,0,1,nil,c,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eqc=Duel.SelectMatchingCard(tp,Hnk.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,c,tp)
			Duel.Equip(tp,eqc:GetFirst(),c,true,true)
		end
		Duel.EquipComplete()
	end
end
function s.replace(c)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.desreptg)
	e2:SetValue(s.desrepval)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
end
function s.defilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.repfilter(c)
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.defilter,1,nil,tp) and Duel.GetFlagEffect(tp,id)==0
		and c:GetEquipGroup():FilterCount(s.repfilter,nil)>0 end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desrepval(e,c)
	return s.defilter(c,e:GetHandlerPlayer())
end
function s.eqfilter2(c,tc)
	return c:IsType(TYPE_EQUIP) and c:GetEquipTarget()==tc
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup():Filter(s.repfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=eqg:Select(Card.IsAbleToGrave,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
	Duel.Hint(HINT_CARD,0,id)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.tohand(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function s.tgfilter(c,tc)
	return c:IsType(TYPE_EQUIP) and c:GetEquipTarget()==tc and c:IsAbleToGrave()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	local c=e:GetHandler()
	local code=re:GetHandler():GetCode()
    if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,c)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,code) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.thfilter(c,code)
	return c:IsSetCard(0x3c10) and c:IsType(TYPE_TRAP) and not c:IsCode(code) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=re:GetHandler():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	local thc=g:GetFirst()
	Duel.SendtoHand(thc,tp,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	thc:RegisterEffect(e1)
	if tc and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function s.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,4,s.lcheck)

    s.equip(c)
    s.replace(c)
	s.tohand(c)
end
function s.lfilter(c)
	return c:IsLinkSetCard(0x3c10) and c:IsType(TYPE_LINK)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
end