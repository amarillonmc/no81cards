--创刻-北河灯里『便当时间』
function c67200064.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,67200064+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200064.activate)
	c:RegisterEffect(e1)  
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetOperation(c67200064.recop)
	c:RegisterEffect(e2)	
end
function c67200064.filter(c)
	return c:IsSetCard(0x3673) and c:IsAbleToHand()
end
function c67200064.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c67200064.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200064,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c67200064.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
		Duel.Recover(tp,100,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c67200064.damval)
	Duel.RegisterEffect(e1,tp)
end
function c67200064.damval(e,re,val,r,rp,rc)
	if val>=3000 then return 0 else return val end
end
