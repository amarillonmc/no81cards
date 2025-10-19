--暗黑能乐灵气
function c95101207.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c95101207.desreptg)
	e1:SetValue(c95101207.desrepval)
	e1:SetOperation(c95101207.desrepop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c95101207.thtg)
	e2:SetOperation(c95101207.thop)
	c:RegisterEffect(e2)
end
function c95101207.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsCode(95101209) and c:IsFaceup()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c95101207.desfilter(c,e,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x3bb0) and c:IsFaceup()
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c95101207.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c95101207.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c95101207.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c95101207.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c95101207.desrepval(e,c)
	return c95101207.repfilter(c,e:GetHandlerPlayer())
end
function c95101207.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,95101207)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c95101207.thilter(c)
	return c:IsSetCard(0xbbb0) and (c:GetOriginalType()&0x1)~=0 and c:IsFaceup() and c:GetEquipTarget()
end
function c95101207.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c95101207.thilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95101207.thilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c95101207.thilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c95101207.eqfilter(c)
	return c:IsSetCard(0xbbb0) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c95101207.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ec=tc:GetEquipTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingTarget(c95101207.eqilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(95101207,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local mc=Duel.SelectMatchingCard(tp,c32549749.eqfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		Duel.Equip(tp,mc,ec)
	end
end
