--[[
亡命骗徒 『大盗』
Desperado Trickster - "The Supplier"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	Auxiliary.RegisterDesperadoChallengeEffect(c,id,CATEGORIES_SEARCH|CATEGORY_GRAVE_ACTION,nil,s.target,s.operation,s.challenge)
end

function s.thfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Search(g,tp)
	end
end
function s.rvfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsMonster() and c:IsLevelAbove(1) and not c:IsPublic()
end
function s.lvcheck(g)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,12)
end
function s.challenge(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #hand==0 then return false end
		local g=hand:Filter(s.rvfilter,nil)
		if g:CheckSubGroup(s.lvcheck,1,12) then
			Duel.HintMessage(tp,HINTMSG_CONFIRM)
			local rg=g:SelectSubGroup(tp,s.lvcheck,false,1,12)
			if #rg>0 then
				Duel.ConfirmCards(1-tp,rg)
				return true
			end
		end
		return false
	end
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,aux.Necro(s.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,3,nil)
	if #g>0 then
		Duel.Search(g,tp)
	end
end