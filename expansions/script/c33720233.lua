--[[
背景音台 - 化物宇宙
Sound Stage - Monster Universe
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--[[Each time a player activates a card or effect that would negate the activation of an effect, an activated effect OR the effects of a card(s), they must pay X LP when that effect resolves
	(X = 500 x the number of times this effect of "Sound Stage - Monster Universe" was applied this turn and negated an effect), otherwise they negate that effect, and if they do,
	they destroy that card. Also, if LP was paid, Special Summon 1 "Monster Universe Token"(Fiend/DARK/Level 1) to both players' fields.
	The ATK/DEF of those Tokens become equal to the amount of LP paid, also they cannot be used as a material for a Summon from the Extra Deck, they are unaffected by other card effects,
	and they can attack directly.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetFunctions(s.regcon,nil,nil,s.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetFunctions(s.negcon,nil,nil,s.negop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		--Temporary fix for scripts that do not set operation infos
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:OPT()
		ge1:SetOperation(s.addmods)
		Duel.RegisterEffect(ge1,0)
	end
end
s.modcodes={
	[10045474]=110045474;	--Infinite Impermanence
}

function s.modfilter(c)
	return s.modcodes[c:GetOriginalCode()]
end
function s.addmods(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.modfilter,0,LOCATION_ALL,LOCATION_ALL,nil)
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		local modcode=s.modcodes[code]
		tc:ReplaceEffect(modcode,0,0)
	end
end

local FLAG_REGISTER_NEGATION_EFFECT = id
local FLAG_SUCCESSFULLY_APPLIED		= id+100

local STRING_ASK_PAYMENT = aux.Stringid(id,1)

--E1
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,ct=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	local ex2,tg2,ct2=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	if not ex and not ex2 then return false end
	if ev>1 then
		return (ex and s.NegateActivationOrActivatedEffectCheck(ct,ev,i)) or (ex2 and s.NegateActivationOrActivatedEffectCheck(ct2,ev,i))
	else
		return ex2 and tg2~=nil and ct2>0
	end
end
function s.NegateActivationOrActivatedEffectCheck(ct,ev,i)
	if ct>1 then
		for i=1,ev-1 do
			local ce=Duel.GetChainInfo(ev-i,CHAININFO_TRIGGERING_EFFECT)
			if ce then
				return true
			end
		end
	elseif ct==1 then
		local ce=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
		return ce
	end
	return false
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(FLAG_REGISTER_NEGATION_EFFECT,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,((ep<<16)|ev)&0x7fffffff)
end

--E2
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:HasFlagEffect(FLAG_REGISTER_NEGATION_EFFECT) then return false end
	local labelset={c:GetFlagEffectLabel(FLAG_REGISTER_NEGATION_EFFECT)}
	for _,label in ipairs(labelset) do
		local actev,actep=label&0xffff,label>>16
		if actev==ev and actep==ep then
			return Duel.IsChainDisablable(ev)
		end
	end
	return false
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local X=Duel.PlayerHasFlagEffect(0,FLAG_SUCCESSFULLY_APPLIED) and Duel.GetFlagEffectLabel(0,FLAG_SUCCESSFULLY_APPLIED) or 0
	local lpcost=X*500
	local lp=Duel.GetLP(ep)
	if X>0 and lp>=lpcost and Duel.SelectYesNo(ep,STRING_ASK_PAYMENT) then
		Duel.PayLPCost(ep,lpcost)
		local lpdiff=Duel.GetLP(ep)-lp
		if lpdiff<0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
			local stat=-lpdiff
			for p=0,1 do
				if not (Duel.GetMZoneCount(p,nil,tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_MONSTER_UNIVERSE,0,TYPES_TOKEN_MONSTER,stat,stat,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,p)) then
					return
				end
			end
			local c=e:GetHandler()
			for p in aux.TurnPlayers() do
				local tk=Duel.CreateToken(tp,TOKEN_MONSTER_UNIVERSE)
				if Duel.SpecialSummonStep(tk,0,tp,p,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetCode(EFFECT_SET_ATTACK)
					e1:SetValue(stat)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD)
					tk:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_SET_DEFENSE)
					tk:RegisterEffect(e2,true)
					local e3=e1:Clone()
					e3:SetCode(EFFECT_DIRECT_ATTACK)
					e3:SetValue(1)
					tk:RegisterEffect(e3,true)
					aux.CannotBeEDMaterial(tk,nil,nil,true,RESET_EVENT|RESETS_STANDARD,c,nil,false,true)
					tk:Unaffected(UNAFFECTED_OTHER,nil,RESET_EVENT|RESETS_STANDARD,c,nil,EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE,nil,true)
				end
			end
			Duel.SpecialSummonComplete()
		end
	else
		Duel.Hint(HINT_CARD,0,id)
		if Duel.NegateEffect(ev) then
			if not Duel.PlayerHasFlagEffect(0,FLAG_SUCCESSFULLY_APPLIED) then
				Duel.RegisterFlagEffect(0,FLAG_SUCCESSFULLY_APPLIED,RESET_PHASE|PHASE_END,0,1)
			end
			Duel.UpdateFlagEffectLabel(0,FLAG_SUCCESSFULLY_APPLIED)
			if rc:IsRelateToChain(ev) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
		end
	end
end