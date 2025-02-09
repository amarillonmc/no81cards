--[[
动物朋友 蓬尾浣熊
Anifriends Ringtail
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--Cannot be Tributed, nor used as a material for a Special Summon from the Extra Deck, except for an "Anifriends" monster.
	aux.CannotBeTributeOrMaterial(c,aux.FilterBoolFunction(Card.IsSetCard,ARCHE_ANIFRIENDS))
	--[[If you control an "Anifriends" Warrior monster (Quick Effect): You can reveal this card in your hand; Special Summon this card.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetFunctions(
		aux.LocationGroupCond(s.cfilter,LOCATION_MZONE,0,1),
		aux.RevealSelfCost(),
		s.sptg,
		s.spop
	)
	c:RegisterEffect(e1)
	--Your opponent cannot target "Anifriends" Warrior monsters you control for attacks or with card effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
--E1
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsRace(RACE_WARRIOR)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--E2
function s.atlimit(e,c)
	return s.cfilter(c)
end
function s.tglimit(e,c)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsRace(RACE_WARRIOR)
end