--回收与利用
function c60150609.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60150609,3))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60150609)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c60150609.condition)
	e2:SetTarget(c60150609.target)
	e2:SetOperation(c60150609.operation)
	c:RegisterEffect(e2)
end
function c60150609.thfilter(c,tp)
    return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE) 
		and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_DECK+LOCATION_EXTRA))
end
function c60150609.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60150609.thfilter,1,nil,tp)
end
function c60150609.pfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3b21) and c:IsAbleToHand()
end
function c60150609.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.IsExistingMatchingCard(c60150609.pfilter,tp,LOCATION_EXTRA,0,1,nil)
    local op=2
	if (g or Duel.IsPlayerCanDraw(tp,1)) then
		if g and Duel.IsPlayerCanDraw(tp,1) then
			op=Duel.SelectOption(tp,aux.Stringid(60150609,2),aux.Stringid(60150609,1))
		elseif g then
			op=Duel.SelectOption(tp,aux.Stringid(60150609,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(60150609,1))+1
		end
	end
    e:SetLabel(op)
end
function c60150609.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
    else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60150609.pfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
    end
end