--[[
茜 永恒之标
Akane, Sign to Eternity
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")

local FLAG_TOKEN_MAT_COUNT	= id
local FLAG_BANISH_TEMP		= id+100
local FLAG_MAXX				= id+200
local FLAG_DELAYED_EVENT	= id+300
local FLAG_SIMULT_CHECK		= id+400
local FLAG_SIMULT_EXCLUDE	= id+500
local FLAG_BANISH_TEMP2		= id+600

function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 Tuner + 1 non-Tuner monster
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--[[This card gains the following effects, based on the number of Tokens used for its Synchro Summon.
	● 4+: If a card(s) would be banished by this card's effect, it returns to the hand instead.]]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetLabel(0)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	--● 1+: If a non-Token monster declares an attack: Banish it until the End Phase.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(id,0)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetFunctions(s.tkcon(1,s.rmcon1),nil,s.rmtg1,s.rmop1)
	c:RegisterEffect(e1)
	--● 2+: Each time a card(s) is banished by this card's effect, both players take 300 damage for each. 
	aux.RegisterMaxxCEffect(c,FLAG_MAXX,nil,LOCATION_MZONE,EVENT_REMOVE,s.tkcon(2,s.damcon),s.damopOUT,s.damopIN,s.flaglabel)
	--● 3+: If a non-Token monster(s) is Summoned: Banish it until the End Phase.
	aux.RegisterMergedDelayedEventGlitchy(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS,EVENT_FLIPSUMMON_SUCCESS},s.evfilter,FLAG_DELAYED_EVENT,LOCATION_MZONE,nil,LOCATION_MZONE,nil,FLAG_SIMULT_CHECK,true)
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(aux.AddThisCardInMZoneAlreadyCheck(c))
	e2:SetFunctions(s.tkcon(3),nil,s.rmtg2,s.rmop2)
	c:RegisterEffect(e2)
end
function s.tkcon(ct,cond)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				return c:IsSynchroSummoned() and c:HasFlagEffect(FLAG_TOKEN_MAT_COUNT) and c:GetFlagEffectLabel(FLAG_TOKEN_MAT_COUNT)>=ct and (not cond or cond(e,tp,eg,ep,ev,re,r,rp))
			end
end

--E0
function s.valcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSynchroType,nil,TYPE_TOKEN)
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_UNION,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(id,math.min(4,ct)))
end

--E1
function s.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return tc and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN)
end
function s.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.GetAttacker()
	Duel.SetTargetCard(tc)
	Duel.SetTargetParam(s.tkcon(4)(e,tp,eg,ep,ev,re,r,rp) and 1 or 0)
	Duel.SetCardOperationInfo(tc,CATEGORY_REMOVE)
end
function s.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToChain() and tc:IsAbleToRemoveTemp() then
		local v=Duel.GetTargetParam()
		if v==0 then
			Duel.BanishUntil(tc,e,tp,nil,nil,FLAG_BANISH_TEMP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

--E2
function s.cfilter(c,h)
	return c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler()==h
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler())
end
function s.flaglabel(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.cfilter,nil,e:GetHandler())
end
function s.damopOUT(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local g=eg:Filter(s.cfilter,nil,e:GetHandler())
	for p in aux.TurnPlayers() do
		Duel.Damage(p,#g*300,REASON_EFFECT,true)
	end
	Duel.RDComplete()
end
function s.damopIN(e,tp,eg,ep,ev,re,r,rp,n)
	Duel.Hint(HINT_CARD,tp,id)
	local labels={Duel.GetFlagEffectLabel(tp,FLAG_MAXX)}
	local ct=0
	for i=1,#labels do
		ct=ct+labels[i]
	end
	for p in aux.TurnPlayers() do
		Duel.Damage(p,ct*300,REASON_EFFECT,true)
	end
	Duel.RDComplete()
end

--E3
function s.evfilter(c,e)
	return c:IsFacedown() or not c:IsType(TYPE_TOKEN)
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(s.tkcon(4)(e,tp,eg,ep,ev,re,r,rp) and 1 or 0)
	local c=e:GetHandler()
	local sg=aux.SelectSimultaneousEventGroup(eg,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	if sg then
		Duel.SetTargetCard(sg)
		Duel.SetCardOperationInfo(sg,CATEGORY_REMOVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_NONE,LOCATION_MZONE)
	end
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards():Filter(Card.IsAbleToRemoveTemp,nil)
	if g and #g>0 then
		local v=Duel.GetTargetParam()
		if v==0 then
			Duel.BanishUntil(g,e,tp,nil,nil,FLAG_BANISH_TEMP2)
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end