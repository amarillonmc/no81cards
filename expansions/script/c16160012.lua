--吉尔·德·雷
local m=16160012
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
   aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_FUSION),1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.inval)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
c16160012.material_type=TYPE_SYNCHRO
function cm.inval(e,c)
	return c:IsType(TYPE_TOKEN)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonMonster(tp,16160013,nil,0x4011,3500,3500,10,RACE_SEASERPENT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonMonster(tp,16160013,nil,0x4011,3500,3500,10,RACE_SEASERPENT,ATTRIBUTE_WATER) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,16160013)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			token:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,0)
		end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(16160012,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.desop)
			Duel.RegisterEffect(e1,tp)
		Duel.SpecialSummonComplete()
	end
end
function cm.filter1(c)
	return c:IsType(TYPE_TOKEN) and c:GetFlagEffect(m)>0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then e:Reset() end
	local tep=Duel.TossCoin(tp,1)
	local rev=Duel.GetCurrentChain()
	local te,cp=Duel.GetChainInfo(rev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if cp==tep then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(rev)
	if (not condition or condition(te,tep,ceg,cep,cev,cre,cr,crp)) and (not cost or cost(te,tep,ceg,cep,cev,cre,cr,crp,0)) and (not target or target(te,tep,ceg,cep,cev,cre,cr,crp,0)) then
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,2))
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,2))
		Duel.ClearTargetCard()
		te:SetProperty(te:GetProperty())
		if cost then cost(te,tep,ceg,cep,cev,cre,cr,crp,1) end
		if target then target(te,tep,ceg,cep,cev,cre,cr,crp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and g:GetCount()>0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(te)
				tg=g:GetNext()
			end
		end
		Duel.ChangeChainOperation(rev,cm.op2)
		if operation then operation(te,tep,ceg,cep,cev,cre,cr,crp) end
		if g and g:GetCount()>0 then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(te)
				tg=g:GetNext()
			end
		end
	else
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,3))
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,3))	 
		Duel.ChangeChainOperation(rev,cm.op2)
	end
end
function cm.op2(e,tp)
	return false 
end




----