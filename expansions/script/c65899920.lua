--反多元防空炮
function c65899920.initial_effect(c)
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
	e1:SetCountLimit(1,65899920+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c65899920.xxcon) 
	e1:SetOperation(c65899920.xxop) 
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65899920,ACTIVITY_CHAIN,c65899920.counterfilter)
end
function c65899920.counterfilter(c)
	return c:GetOwner()==1
end
function c65899920.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==0 and Duel.GetTurnCount()==1
end 
function c65899920.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.ConfirmCards(1-tp,c) 
	Duel.Hint(HINT_CARD,0,65899920) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65899920.spcon)
	e1:SetOperation(c65899920.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c65899920.spcon1)
	e2:SetOperation(c65899920.disop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,e:GetHandlerPlayer())
end

function c65899920.cfilter(c,tp,se)
	return c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c65899920.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65899920.cfilter,1,nil,tp)
end
function c65899920.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(65899920,1-tp,ACTIVITY_CHAIN)==5
end
function c65899920.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65899920)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if sg:GetCount()>5 then
		local cg=sg:RandomSelect(1-tp,sg:GetCount()-5)
		Duel.SendtoDeck(cg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end