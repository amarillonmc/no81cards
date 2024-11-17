--[[
Hololive 虚拟YouTuber Fuwawa
HoloVTuber Fuwawa
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local CARD_HOLOVTUBER_MOCOCO = id+1
local FLAG_NEEDS_TWIN = id

if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableReviveLimit()
	--1 Tuner + 1 non-Tuner monster with the same Level as the Tuner
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,s.nontuner,1,1)
	--Cannot be used as material for a Special Summon from the Extra Deck.
	aux.CannotBeEDMaterial(c,nil,nil,true)
	--[[If this card is Synchro Summoned: Special Summon 1 "HoloVTuber Mococo" from your Extra Deck, ignoring its Summoning conditions.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.SynchroSummonedCond,nil,s.sptg,s.spop)
	c:RegisterEffect(e1)
	--[[If "HoloVTuber Mococo" declares an attack: You can change this card to Defense Position, and if you do, inflict 2000 damage to your opponent.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_POSITION|CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(
		s.poscon,
		nil,
		s.postg,
		s.posop
	)
	c:RegisterEffect(e2)
	--[[If this card Special Summoned "HoloVTuber Mococo" with its own effect, or if this card was Special Summoned by the effect of "HoloVTuber Mococo", it gains this effect:
	● If you do not control "HoloVTuber Mococo", send this card to the GY.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetCondition(s.sdcon)
	c:RegisterEffect(e3)
end
function s.nontuner(c,sync,tuner)
	return c:IsNotTuner(sync) and tuner and c:IsLevel(tuner:GetLevel())
end

--E1
function s.spfilter(c,e,tp)
	return c:IsCode(CARD_HOLOVTUBER_MOCOCO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)>0 and c:IsRelateToChain() and c:IsFaceup() then
		c:RegisterFlagEffect(FLAG_NEEDS_TWIN,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(id,1))
		g:GetFirst():RegisterFlagEffect(FLAG_NEEDS_TWIN,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(id,1))
	end
end

--E2
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsCode(CARD_HOLOVTUBER_MOCOCO)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAttackPos() and c:IsCanChangePosition()
	end
	Duel.SetCardOperationInfo(c,CATEGORY_POSITION)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsAttackPos() and Duel.ChangePosition(c,POS_FACEUP_DEFENSE)>0 then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end

--E3
function s.sdcon(e)
	local c=e:GetHandler()
	return c:HasFlagEffect(FLAG_NEEDS_TWIN) and not Duel.IsExists(false,aux.FaceupFilter(Card.IsCode,CARD_HOLOVTUBER_MOCOCO),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end