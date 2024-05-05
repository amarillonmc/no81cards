--[[
亡命铁心之怨
Karma of Desperado Heart
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_KARMA_OF_DESPERADO_HEART,LOCATION_SZONE|LOCATION_MZONE)
	c:Activation(false,false,false,false,s.regop)
	--[[Each time a "Desperado Trickster" monster destroys a monster by battle: Place 1 counter on this card.]]
	local SZChk=aux.AddThisCardInSZoneAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetLabelObject(SZChk)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--[[Once per turn: You can remove any number of counters from this card; destroy an equal number of cards on the field.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:OPT()
	e2:SetCost(aux.DummyCost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--[[During your Main Phase, except the turn this card was activated: You can Special Summon this card from your Spell & Trap Zone to your field as an Effect Monster named
	"Desperado Heart" (FIRE/Psychic/Level 1/ATK 0/DEF 0) and with the following effects.
	● Cannot be destroyed by battle.
	● If this card declares an attack: Activate this effect; before damage calculation, inflict damage to your opponent equal to the number of counters on this card x 500,
	also if this card is attacking a monster with less DEF than that amount, send that monster to the GY.]]
	aux.RegisterDesperadoSpellMonsterEffect(c,id,COUNTER_KARMA_OF_DESPERADO_HEART)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(aux.ProcSummonedCond)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:Desc(3)
	e4:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,0)
end

--E1
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsRelateToBattle()
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.AlreadyInRangeFilter(e,s.cfilter),1,nil)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,COUNTER_KARMA_OF_DESPERADO_HEART)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCanAddCounter(COUNTER_KARMA_OF_DESPERADO_HEART,1) then
		c:AddCounter(COUNTER_KARMA_OF_DESPERADO_HEART,1)
	end
end

--E2
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then
		if not e:IsCostChecked() or #g<=0 then return false end
		for i=1,#g do
			if c:IsCanRemoveCounter(tp,COUNTER_KARMA_OF_DESPERADO_HEART,i,REASON_COST) then
				return true
			end
		end
		return false
	end
	local nums={}
	for i=1,#g do
		if c:IsCanRemoveCounter(tp,COUNTER_KARMA_OF_DESPERADO_HEART,i,REASON_COST) then
			table.insert(nums,i)
		end
	end
	if #nums==0 then return end
	local n=Duel.AnnounceNumber(tp,table.unpack(nums))
	c:RemoveCounter(tp,COUNTER_KARMA_OF_DESPERADO_HEART,n,REASON_COST)
	Duel.SetTargetParam(n)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,n,PLAYER_ALL,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTargetParam()
	if not ct or ct<=0 then return end
	local g=Duel.Select(HINTMSG_DESTROY,false,tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	if #g==ct then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--E3
function s.condition(e)
	return e:GetHandler()==Duel.GetAttacker()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local val=c:GetCounter(COUNTER_KARMA_OF_DESPERADO_HEART)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
	local d=Duel.GetAttackTarget()
	if d and d:IsRelateToBattle() then
		Duel.SetTargetCard(d)
		local f=(d:IsFaceup() and d:IsDefenseBelow(val-1)) and Duel.SetOperationInfo or Duel.SetPossibleOperationInfo
		local p,loc=d:GetResidence()
		f(0,CATEGORY_TOGRAVE,d,1,p,loc)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local val=c:GetCounter(COUNTER_KARMA_OF_DESPERADO_HEART)*500
		if val>0 then
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
		val=c:GetCounter(COUNTER_KARMA_OF_DESPERADO_HEART)*500
		local d=Duel.GetFirstTarget()
		if c:IsRelateToBattle() and c==Duel.GetAttacker() and d and d==Duel.GetAttackTarget() and d:IsRelateToChain() and d:IsRelateToBattle() and d:IsFaceup() and d:IsDefenseBelow(val-1) and d:IsAbleToGrave() then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
	end
end