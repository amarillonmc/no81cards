--[[
键★断片 - 叶留佳 〔无忧无虑·欢乐无限·喧嚣少女〕
K.E.Y Fragments - Haruka 〔Easygoing Noisy Girl〕
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	STICKERS_TABLE[STICKER_EASYGOING_NOISY_GIRL]	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_HARUKA] 			= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerQE(c,800,STICKER_EASYGOING_NOISY_GIRL)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_EASYGOING_NOISY_GIRL,STICKER_LOST_TO_HARUKA)
	
	--[[A monster with this Sticker gains the following effect.
	● Once per turn: You can Special Summon 1 FIRE "K.E.Y Fragments" monster from your hand. (You can only Special Summon 1 monster by this effect each turn.)]]
	aux.RegisterStickerEffect(STICKER_EASYGOING_NOISY_GIRL,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:OPT()
		e1:SetTarget(s.sptg)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● At the end of the Battle Phase, if a monster(s) you control inflicted battle damage to your opponent during this Battle Phase,
	your opponent can take control of any number of those monsters, until the end of their next turn. ]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_HARUKA,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetCategory(CATEGORY_CONTROL)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE|PHASE_BATTLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:OPT()
		e1:SetCondition(s.discon)
		e1:SetTarget(s.distg)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		if not aux.lost_to_hakura_check then
			aux.lost_to_hakura_check=true
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_BATTLE_DAMAGE)
			ge1:SetOperation(s.checkop)
			Duel.RegisterEffect(ge1,0)
		end
		return e1
	end
	)
	
	if not aux.lost_to_hakura_check then
		aux.lost_to_hakura_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1)
	end
end

--E1
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.PlayerHasFlagEffect(tp,id) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	end
end

--E2
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-e:GetHandlerPlayer() and Duel.IsExists(false,Card.HasFlagEffect,tp,0,LOCATION_MZONE,1,nil,id)
end
function s.filter(c)
	return c:HasFlagEffect(id) and c:IsControlerCanBeChanged()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.Group(s.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,tp,LOCATION_MZONE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)
	local g=Duel.Group(s.filter,tp,0,LOCATION_MZONE,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=g:Select(tp,1,math.min(ft,#g),nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		local tct=1
		if Duel.GetTurnPlayer()~=tp
			then tct=2
		elseif Duel.GetCurrentPhase()==PHASE_END then
			tct=3
		end
		Duel.GetControl(sg,tp,PHASE_END,tct)
	end
end