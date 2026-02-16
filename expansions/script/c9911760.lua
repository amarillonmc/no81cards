--远古造物 倾齿龙
Duel.LoadScript("c9910700.lua")
function c9911760.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search or disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911760,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CUSTOM+9911760)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(c9911760.target)
	e2:SetOperation(c9911760.operation)
	c:RegisterEffect(e2)
	if not c9911760.global_check then
		c9911760.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c9911760.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911760.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c9911760.regop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_HAND then
		Duel.RaiseEvent(re:GetHandler(),EVENT_CUSTOM+9911760,re,r,rp,ep,ev)
	end
end
function c9911760.thfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToHand()
end
function c9911760.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9911760.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,9911760)==0
	local b2=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,9911761)==0
	if chk==0 then return b1 or b2 end
end
function c9911760.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c9911760.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,9911760)==0
	local b2=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,9911761)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9911760,1),aux.Stringid(9911760,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9911760,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(9911760,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c9911760.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
		Duel.RegisterFlagEffect(tp,9911760,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g2=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g2)
		local sc=g2:GetFirst()
		if not sc:IsCanBeDisabledByEffect(e) then return end
		Duel.NegateRelatedChain(sc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		sc:RegisterEffect(e2)
		if sc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			sc:RegisterEffect(e3)
		end
		Duel.RegisterFlagEffect(tp,9911761,RESET_PHASE+PHASE_END,0,1)
	end
end
