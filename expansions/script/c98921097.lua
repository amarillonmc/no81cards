--翼神-不知火
function c98921097.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2,c98921097.lcheck)
	c:EnableReviveLimit()	
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921097,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22662015)
	e2:SetCost(c98921097.setcost)
	e2:SetTarget(c98921097.settg)
	e2:SetOperation(c98921097.setop)
	c:RegisterEffect(e2)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921097,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98922097)
	e2:SetCost(c98921097.damcost)
	e2:SetOperation(c98921097.damop)
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921097,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,98921097)
	e1:SetCondition(c98921097.thcon)
	e1:SetTarget(c98921097.thtg)
	e1:SetOperation(c98921097.thop)
	c:RegisterEffect(e1)
end
function c98921097.matfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_FIRE)
end
function c98921097.lcheck(g,lc)
	return g:IsExists(c98921097.matfilter,1,nil)
end
function c98921097.costfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsDefense(0) and c:IsAbleToGraveAsCost()
end
function c98921097.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c98921097.costfilter,tp,LOCATION_DECK,0,1,nil) and ft>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98921097.costfilter,tp,LOCATION_DECK,0,1,1,nil,ft)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c98921097.setfilter(c,tp)
	return (c:IsCode(40005099) or aux.IsCodeListed(c,40005099)) and (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS))
		and c:GetActivateEffect():IsActivatable(tp)
end
function c98921097.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921097.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c98921097.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c98921097.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function c98921097.cfilter(c)
	return c:IsDefense(0) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost() and not c:IsCode(98921097)
end
function c98921097.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c98921097.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98921097.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98921097.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c98921097.atktg)
	e1:SetValue(600)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98921097.atktg(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function c98921097.spfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO)
end
function c98921097.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921097.spfilter,1,nil,tp)
end
function c98921097.thfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsRace(RACE_ZOMBIE)
end
function c98921097.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98921097.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98921097.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98921097.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c98921097.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_RETURN)
		Duel.SendtoGrave(c,REASON_RETURN)
	end
end	