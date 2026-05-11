--逆袭之斗兽 鸢泽美咲
function c9910226.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c9910226.lcheck)
	c:EnableReviveLimit()
	--attack effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910226.condition)
	e1:SetCost(c9910226.cost)
	e1:SetTarget(c9910226.target)
	e1:SetOperation(c9910226.operation)
	c:RegisterEffect(e1)
end
function c9910226.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_RIGHT)
end
function c9910226.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.bpcon() or Duel.GetTurnPlayer()==1-tp
end
function c9910226.locfilter(c,tp,e)
	return c:IsOnField() and c:IsControler(tp) and c:IsRelateToEffect(e)
end
function c9910226.rmfilter(c,mg)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return g:IsExists(aux.IsInGroup,1,nil,mg) and c:IsAbleToRemoveAsCost()
end
function c9910226.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsExists(c9910226.locfilter,1,nil,tp,te) then
			g:Merge(tg:Filter(c9910226.locfilter,nil,tp,te))
		end
	end
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(c9910226.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c9910226.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c9910226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9910226)==0 end
end
function c9910226.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_BP_TWICE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_MUST_ATTACK)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.RegisterFlagEffect(tp,9910226,RESET_PHASE+PHASE_END,0,0)
end
