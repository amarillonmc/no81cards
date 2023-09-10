--恶魔娘 切莉丝
function c98920673.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920673,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920673)
	e1:SetCost(c98920673.cost)
	e1:SetTarget(c98920673.target)
	e1:SetOperation(c98920673.operation)
	c:RegisterEffect(e1)
end
function c98920673.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c98920673.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c98920673.cfilter,2,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c98920673.cfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c98920673.setfilter(c)
	return c:GetType()==TYPE_TRAP and (c:IsAbleToHand() or c:IsSSetable())
end
function c98920673.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920673.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c98920673.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c98920673.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_TRAP) then
			   local e1=Effect.CreateEffect(e:GetHandler())
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			   e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			end
		end
	end
end