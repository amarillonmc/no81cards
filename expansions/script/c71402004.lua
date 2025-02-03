--风来之国的旅者 约翰与珊
function c71402004.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c71402004.lcheck)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c71402004.atkval)
	c:RegisterEffect(e1)
	--[[
	--activate field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71402004,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71402004)
	e2:SetCondition(c71402004.con2)
	e2:SetCost(c71402004.cost2)
	e2:SetTarget(c71402004.tg2)
	e2:SetOperation(c71402004.op2)
	c:RegisterEffect(e2)
	]]
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71402004,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,71402004)
	e2:SetTarget(c71402004.tg2)
	e2:SetOperation(c71402004.op2)
	c:RegisterEffect(e2)
end
function c71402004.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c71402004.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE+LOCATION_GRAVE,nil,TYPE_FIELD)
	return g:GetClassCount(Card.GetCode)*500
end
--[[
function c71402004.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c71402004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c71402004.filter2a(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
		and not Duel.IsExistingMatchingCard(c71402004.filter2b,tp,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE+LOCATION_GRAVE,1,nil,c:GetCode())
end
function c71402004.filter2b(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())
end
function c71402004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71402004.filter2a,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c71402004.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71402004,0))
	local tc=Duel.SelectMatchingCard(tp,c71402004.filter2a,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
]]
function c71402004.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function c71402004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71402004.filter,tp,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c71402004.filter,tp,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71402004.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71402004.filter,tp,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE+LOCATION_GRAVE,1,1,nil)
	local sc=g:GetFirst()
	local c=e:GetHandler()
	if Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and sc:IsLocation(LOCATION_DECK) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end