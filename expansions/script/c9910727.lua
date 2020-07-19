--远古造物栖所 冈瓦纳
require("expansions/script/c9910106")
function c9910727.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910727.target)
	e1:SetOperation(c9910727.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c9910727.desreptg)
	e2:SetValue(c9910727.desrepval)
	e2:SetOperation(c9910727.desrepop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910727.setcon)
	e3:SetTarget(c9910727.settg)
	e3:SetOperation(c9910727.setop)
	c:RegisterEffect(e3)
end
function c9910727.cfilter(c,lv)
	return c:IsFaceup() and c:IsLevel(lv)
end
function c9910727.thfilter(c,tp)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c9910727.cfilter,tp,LOCATION_MZONE,0,1,nil,c:GetLevel())
		and not Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel())
end
function c9910727.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910727.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910727.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910727.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910727.repfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9910727.desfilter(c,e,tp)
	return c:IsFacedown() and c:IsControler(tp) and c:IsDestructable(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c9910727.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9910727.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9910727.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c9910727.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c9910727.desrepval(e,c)
	return c9910727.repfilter(c,e:GetHandlerPlayer())
end
function c9910727.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910727)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c9910727.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c9910727.setfilter(c,id,e)
	local op=c:GetOwner()
	return c:GetTurnID()==id and c:IsType(TYPE_MONSTER)
		and Duel.GetLocationCount(op,LOCATION_SZONE)>0 and Zcd.SetFilter(c,e)
end
function c9910727.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local id=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c9910727.setfilter(chkc,id,e) end
	if chk==0 then return Duel.IsExistingTarget(c9910727.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,id,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9910727.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,id,e)
end
function c9910727.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local op=tc:GetOwner()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(op,LOCATION_SZONE)>0 and Zcd.SetFilter(tc,e) then
		Duel.MoveToField(tc,tp,op,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.ConfirmCards(1-tp,tc)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
