--镜像对决
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)   
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.lmcon)
	e1:SetOperation(s.xxop) 
	c:RegisterEffect(e1)
end

function s.cfilter(c)
	return not c:IsType(TYPE_NORMAL) or c:IsType(TYPE_PENDULUM)
end
function s.lmcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,0,1,c)
end
function s.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.ConfirmCards(1-tp,c)
	local g=Duel.GetFieldGroup(tp,0xff,0)
	local ec=g:GetFirst()
	while ec do
		if KOISHI_CHECK then Duel.Exile(ec,0) else Duel.Remove(ec,POS_FACEDOWN,REASON_RULE,nil) end
		ec=g:GetNext()
	end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g1)
	local ec1=g1:GetFirst()
	local loc=0
	while ec1 do
		local token=Duel.CreateToken(tp,ec1:GetCode())
		if ec1:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			Duel.SendtoDeck(token,tp,2,REASON_RULE,nil)
		elseif ec1:IsLocation(LOCATION_HAND) then
			Duel.SendtoHand(token,tp,REASON_RULE,nil)
		end
		ec1=g1:GetNext()
	end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,LOCATION_HAND,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
end