--[[
亡命骗徒 『老司机』
Desperado Trickster - "The Secretary"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	Auxiliary.RegisterDesperadoChallengeEffect(c,id,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON|CATEGORY_DECKDES,EFFECT_FLAG_DELAY,s.target,s.operation,s.challenge)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rvfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsMonster()
end
function s.challenge(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.rvfilter,tp,LOCATION_EXTRA,0,nil)
		if #g>=6 then
			Duel.HintMessage(tp,HINTMSG_CONFIRM)
			local rg=g:Select(tp,6,6,nil)
			if #rg>0 then
				Duel.ConfirmCards(1-tp,rg)
				return true
			end
		end
		return false
	end
	local ft=Duel.GetMZoneCountForMultipleSpSummon(tp)
	if ft<=0 then return end
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,math.min(2,ft),nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end