--聆音(注：狸子DIY)
function c77770048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77770048+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c77770048.condition)
	e1:SetTarget(c77770048.target)
	e1:SetOperation(c77770048.activate)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77770048,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c77770048.retcon)
	e2:SetTarget(c77770048.rettg)
	e2:SetOperation(c77770048.retop)
	c:RegisterEffect(e2)
end
function c77770048.cfilter(c)
	return c:IsFaceup() and c:IsCode(77770025)
end
function c77770048.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77770048.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c77770048.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x234) and c:IsAbleToHand()
end
function c77770048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77770048.filter(chkc)
		else return false end
	end
	local b1=Duel.IsExistingMatchingCard(c77770048.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(c77770048.filter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,3,nil,70095154) then
			op=Duel.SelectOption(tp,aux.Stringid(77770048,0),aux.Stringid(77770048,1),aux.Stringid(77770048,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(77770048,0),aux.Stringid(77770048,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(77770048,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(77770048,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectTarget(tp,c77770048.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
	end
end
function c77770048.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c77770048.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			if op==2 then Duel.BreakEffect() end
			Duel.SendtoHand(tc,nil,2,REASON_EFFECT)
		end
	end
end
function c77770048.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c77770048.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77770048.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
