--源石秘术·风雪
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e4)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.drcon1)
	e1:SetOperation(cm.drop1)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cm.drcon2)
	e3:SetOperation(cm.drop2)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_SPELLCASTER) and (c:IsSetCard(0x87af) or (_G["c"..c:GetOriginalCode()] and _G["c"..c:GetOriginalCode()].named_with_Arknight)) and c:GetLevel()>=4 and Duel.GetMZoneCount(tp,c)>=c:GetLevel()//4 and (c:GetLevel()<8 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,cm.cfilter,1,REASON_EFFECT,true,nil,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.SelectReleaseGroupEx(tp,cm.cfilter,1,1,REASON_EFFECT,true,nil,tp)
	if rg and #rg>0 then
		local ct=rg:GetFirst():GetLevel()//4
		if Duel.Release(rg,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP) then
			for i=1,ct do
				local token=Duel.CreateToken(tp,m+1)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.filter(c,sp)
	return c:IsSummonPlayer(sp)
end
function cm.tfilter(c,typ)
	return c:IsType(typ) and c:IsFaceup()
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp) and not Duel.IsChainSolving() and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_RITUAL) and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.filter,nil,1-tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500*ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp) and Duel.IsChainSolving() and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_RITUAL) and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_RITUAL) and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(m)
	e:GetHandler():ResetFlagEffect(m)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500*ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end