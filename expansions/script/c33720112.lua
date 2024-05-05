--[[
亡命骗徒 『三带一』
Desperado Trickster - "Fullhouse"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_DESTROY|CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
end
function s.filter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(Card.IsSetCard,tp,LOCATION_DECK,0,nil,ARCHE_DESPERADO_TRICKSTER)
		return not Duel.PlayerHasFlagEffect(tp,id) and #g>0
			and (Duel.IsPlayerCanDraw(tp,1) or g:FilterCount(Card.IsAbleToHand,nil)>0)
	end
	local c=e:GetHandler()
	local p,loc=c:GetResidence()
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,c,1,p,loc)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.filter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	Duel.HintMessage(tp,HINTMSG_CONFIRM)
	local rg=g:Select(tp,1,3,nil)
	local ct=#rg
	if ct>0 then
		Duel.ConfirmCards(1-tp,rg)
		local n=Duel.AnnounceNumberMinMax(tp,1,ct)
		if Duel.SelectYesNo(1-tp,aux.Stringid(id,n)) then
			for p in aux.TurnPlayers() do
				Duel.Draw(p,n,REASON_EFFECT)
			end
		else
			local tc=rg:RandomSelect(tp,1):GetFirst()
			if tc and tc:IsAbleToHand() and Duel.SearchAndCheck(tc,tp) then
				local c=e:GetHandler()
				if c:IsRelateToChain() and Duel.Destroy(c,REASON_EFFECT)>0 then
					Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
				end
			end
		end
	end
end