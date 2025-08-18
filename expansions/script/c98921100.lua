--黑翼追猎者
function c98921100.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98921100,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(c98921100.descon)
	e4:SetCost(c98921100.descost)
	e4:SetTarget(c98921100.damtg)
	e4:SetOperation(c98921100.damop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--EFFECT_INDESTRUCTABLE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(c98921100.condition)
	c:RegisterEffect(e1)
end
function c98921100.condition(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local race_attr_tb={}
	if g:GetCount()<2 then return false end
	while tc do
		local race=tc:GetRace()
		local attr=tc:GetAttribute()
		local key=race|(attr<<16) 
		if race_attr_tb[key] then return false end
		race_attr_tb[key]=true	  
		tc=g:GetNext()
	end
	return true 
end
function c98921100.check(tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<2 then return false end
	local rac=g:GetFirst():GetRace()
	local att=g:GetFirst():GetAttribute()
	local tc=g:GetNext()
	while tc do
		if tc:GetRace()~=rac or tc:GetAttribute()~=att then return false end
		tc=g:GetNext()
	end
	return true
end
function c98921100.descon(e,tp,eg,ep,ev,re,r,rp)
	return c98921100.check(tp)
end
function c98921100.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSummonLocation(LOCATION_HAND) and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE)
end
function c98921100.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c98921100.cfilter(chkc,e,1-tp) end
	if chk==0 then return eg:IsExists(c98921100.cfilter,1,nil,e,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c98921100.cfilter,1,1,nil,e,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98921100.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98921100.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end