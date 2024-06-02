--[[
大志雷马
Great Zeorymer
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,7,7,s.altmat,aux.Stringid(id,0),s.altop)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.atcon)
	e0:SetTarget(aux.RelationTarget)
	e0:SetOperation(s.atop)
	c:RegisterEffect(e0)
	--[[Gains 500 ATK for each material attached to it.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--[[Once per battle, during the Damage Step, when this card battles (Quick Effect): You can detach 1 material from this card; apply the following effects until the end of this turn:
	● This card is unaffected by your opponent's card effects.
	● Change all monsters your opponent controls to Attack Position, also they lose ATK equal to this card's ATK.
	● If this card destroys a monster by battle, inflict damage to your opponent equal to the DEF of the destroyed monster.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_POSITION|CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(s.condition)
	e2:SetCost(aux.DetachSelfCost())
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
end
function s.altmat(c)
	return c:IsFaceup() and c:IsCode(CARD_ZEORYMER_OF_THE_SKY)
end
function s.atfilter(c,tp)
	return c:IsMonster() and c:IsRace(RACE_MACHINE|RACE_PSYCHO) and c:IsCanOverlay(tp)
end
function s.altop(e,tp,chk)
	local g=Duel.Group(s.atfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,nil,tp)
	if chk==0 then return g:CheckSubGroup(aux.dncheck,7,7) end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_TOFIELD,0,0)
end

--E0
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:HasFlagEffect(id)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) then return end
	local g=Duel.Group(s.atfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,nil,tp)
	if #g<7 then return end
	Duel.HintMessage(tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,7,7)
	if #sg>0 then
		Duel.Attach(sg,c)
	end
end

--E1
function s.atkval(e,c)
	return c:GetOverlayCount()*500
end

--E2
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and Duel.IsPhase(PHASE_DAMAGE) and not Duel.IsDamageCalculated()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:HasFlagEffect(id+100) end
	c:RegisterFlagEffect(id+100,RESET_PHASE|PHASE_DAMAGE_CAL,0,1)
	Duel.SetTargetParam(c:GetAttack())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local e1=Effect.CreateEffect(c)
		e1:Desc(id,2)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		e1:SetOwnerPlayer(tp)
		c:RegisterEffect(e1)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLE_DESTROYING)
		e4:SetCondition(aux.bdcon)
		e4:SetOperation(s.damop)
		e4:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		c:RegisterEffect(e4)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_ATTACK)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-Duel.GetTargetParam())
	e3:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetHandler():GetBattleTarget():GetDefense()
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end