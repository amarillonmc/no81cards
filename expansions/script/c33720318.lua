--[[
花花变身·动物朋友 飞棍
H-Anifriends Skyfish
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 Synchro Monster OR "Anifriends" Tuner + 1 non-Tuner monster OR "Anifriends" Synchro Monster
	aux.AddSynchroProcedure(c,s.synmat1,s.synmat2,1,1)
	--Must be Synchro Summoned.
	c:MustBeSummoned(SUMMON_TYPE_SYNCHRO)
	--[[Your opponent cannot target other cards you control with card effects or for attacks.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(s.atlimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Cannot be destroyed by battle
	c:CannotBeDestroyedByBattle()
	--Unaffected by opponent's card effects that target this card.
	c:Unaffected(s.efilter)
	--Your opponent must attack this card, if able.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e4:SetValue(function(e,c) return c==e:GetHandler() end)
	c:RegisterEffect(e4)
	--If you would take battle damage from a battle involving this card, gain LP equal to that amount, instead
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_REVERSE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(s.revdam)
	c:RegisterEffect(e5)
	--When this card is destroyed, or Tributed, by your opponent: You can target 1 "Anifriends" monster in your GY; Special Summon it, ignoring its Summoning conditions.
	local e6=Effect.CreateEffect(c)
	e6:Desc(0,id)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e7)
end
function s.synmat1(c,sync)
	return c:IsType(TYPE_SYNCHRO) or (sync and c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsTuner(sync))
end
function s.synmat2(c,sync)
	return (sync and c:IsNotTuner(sync)) or (c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsType(TYPE_SYNCHRO))
end

--E1
function s.atlimit(e,c)
	return c~=e:GetHandler()
end

--immunity
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end

--E5
function s.revdam(e,re,r,rp,rc)
	local c=e:GetHandler()
	return r&REASON_BATTLE~=0 and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end

--E6
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReasonPlayer(1-tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end