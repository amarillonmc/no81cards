--奥西里斯的万雷牢
function c11579800.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1) 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c11579800.xxcon1) 
	e1:SetTarget(c11579800.xxtg1) 
	e1:SetOperation(c11579800.xxop1) 
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	local e3=e1:Clone() 
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c11579800.xxcon2) 
	e1:SetTarget(c11579800.xxtg2) 
	e1:SetOperation(c11579800.xxop2) 
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	local e3=e1:Clone() 
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
end
function c11579800.xxcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10000020) end,tp,LOCATION_MZONE,0,1,nil) and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end 
function c11579800.xckfil1(c,tp) 
	return c:IsFaceup() and c:IsAttackPos() and c:IsSummonPlayer(1-tp)  
end 
function c11579800.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=eg:Filter(c11579800.xckfil1,nil,tp)
	if chk==0 then return true end 
	Duel.SetTargetCard(g)
end 
function c11579800.xxop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)  
end 
function c11579800.xxcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10000020) end,tp,LOCATION_MZONE,0,1,nil) and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) 
end 
function c11579800.xckfil2(c,tp) 
	return c:IsFaceup() and c:IsDefensePos() and c:IsSummonPlayer(1-tp)  
end 
function c11579800.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=eg:Filter(c11579800.xckfil2,nil,tp)
	if chk==0 then return true end 
	Duel.SetTargetCard(g)
end 
function c11579800.xxop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local predef=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)  
end 




