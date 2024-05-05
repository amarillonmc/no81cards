--[[
亡命骗徒 『老司机』
Desperado Trickster - "The Pupil"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	Auxiliary.RegisterDesperadoChallengeEffect(c,id,CATEGORIES_SEARCH,nil,s.target,s.operation,s.challenge)
end
function s.thfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_HEART) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Search(g,tp)
	end
end
function s.rvfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsMonster()
end
function s.challenge(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetHand(tp)
		if g:FilterCount(Card.IsPublic,nil)~=#g then
			Duel.ConfirmCards(1-tp,g)
			if not g:IsExists(Card.IsType,1,nil,TYPE_SPELL|TYPE_TRAP) then
				return true
			end
		end
		return false
	end
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if #g>0 then
		Duel.Search(g,tp)
	end
end