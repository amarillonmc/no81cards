--[[
Hololive 虚拟YouTuber Mococo
HoloVTuber Mococo
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local CARD_HOLOVTUBER_FUWAWA = id-1
local FLAG_NEEDS_TWIN = CARD_HOLOVTUBER_FUWAWA

if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableReviveLimit()
	--2 Level 4 monsters, including 1 Tuner and 1 non-Tuner monster
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)
	--Cannot be used as material for a Special Summon from the Extra Deck.
	aux.CannotBeEDMaterial(c,nil,nil,true)
	--[[If this card is Xyz Summoned: Special Summon 1 "HoloVTuber Fuwawa" from your Extra Deck, ignoring its Summoning conditions.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.XyzSummonedCond,nil,s.sptg,s.spop)
	c:RegisterEffect(e1)
	--[[If "HoloVTuber Fuwawa" declares an attack: You can change this card to Defense Position, and if you do, that attacking monster gains 2000 ATK during this Battle Phase only]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_POSITION|CATEGORY_ATKCHANGE)
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
	--[[If this card Special Summoned "HoloVTuber Fuwawa" with its own effect, or if this card was Special Summoned by the effect of "HoloVTuber Fuwawa", it gains this effect:
	● If you do not control "HoloVTuber Fuwawa", send this card to the GY.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetCondition(s.sdcon)
	c:RegisterEffect(e3)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,4)
end
function s.xyzcheck(g)
	return g:IsExists(s.tuner,1,nil,g)
end
function s.tuner(c,g)
	return c:IsXyzType(TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsXyzType),1,c,TYPE_TUNER)
end

--E1
function s.spfilter(c,e,tp)
	return c:IsCode(CARD_HOLOVTUBER_FUWAWA) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
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
	return Duel.GetAttacker():IsCode(CARD_HOLOVTUBER_FUWAWA)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAttackPos() and c:IsCanChangePosition()
	end
	Duel.SetCardOperationInfo(c,CATEGORY_POSITION)
	local a=Duel.GetAttacker()
	Duel.SetTargetCard(a)
	Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,a,1,0,0,2000)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsAttackPos() and Duel.ChangePosition(c,POS_FACEUP_DEFENSE)>0 then
		local a=Duel.GetAttacker()
		if a and a:IsRelateToChain() and a:IsFaceup() and not a:IsStatus(STATUS_ATTACK_CANCELED) then
			a:UpdateATK(2000,RESET_PHASE|PHASE_BATTLE,{e:GetHandler(),true})
		end
	end
end

--E3
function s.sdcon(e)
	local c=e:GetHandler()
	return c:HasFlagEffect(FLAG_NEEDS_TWIN) and not Duel.IsExists(false,aux.FaceupFilter(Card.IsCode,CARD_HOLOVTUBER_FUWAWA),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end