--[[
晦空士 ～来访的紫寂～
Sepialife - Visitor On Violet
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Each time your opponent Normal or Special Summons a monster(s), while the only cards you control (min. 1) are "Sepialife" cards:
	Excavate the top card of their Deck, and if it is a "Sepialife" card, shuffle both that card and the Summoned monster(s) into your Deck, and if you do,
	your opponent draws 2 cards and keeps them revealed in their hand. Otherwise send the excavated card to the GY.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS},s.cfilter,id,LOCATION_MZONE,nil,LOCATION_MZONE,nil,id+100,true)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DRAW|CATEGORY_TODECK|CATEGORY_TOGRAVE|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetFunctions(s.condition,nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.cfilter(c,e,tp,eg,ep,ev,re,r,rp,obj,event)
	return c:IsSummonPlayer(1-tp) and aux.AlreadyInRangeFilter(nil,nil,obj)
end
function s.excfilter(c)
	return c:IsFacedown() or not c:IsSetCard(ARCHE_SEPIALIFE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	return #g>0 and not g:IsExists(s.excfilter,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local opinfochk=false
	local g=aux.SelectSimultaneousEventGroup(eg,tp,id+100,1,e,id+200)
	if not g or #g==0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,LOCATION_MZONE)
	else
		Duel.SetTargetCard(g)
		local g=Duel.GetDecktopGroup(1-tp,1)
		if g and #g>0 then
			local tc=g:GetFirst()
			if tc:IsPublic() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DECK) then
				opinfochk=true
				if tc:IsSetCard(ARCHE_SEPIALIFE) then
					Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
					Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)
				else
					Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
				end
			end
		end
	end
	if opinfochk then return end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,g and g or nil,g and #g or 0,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local top=Duel.GetDecktopGroup(1-tp,1)
	if #top<1 then return end
	Duel.DisableShuffleCheck(true)
	Duel.ConfirmDecktop(1-tp,1)
	local tc=top:GetFirst()
	if tc:IsSetCard(ARCHE_SEPIALIFE) then
		local og=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not og or #og==0 then return end
		local g=og:Filter(Card.IsRelateToChain,nil)
		if #g==0 then return end
		g:AddCard(tc)
		local tg=g:Filter(Card.IsAbleToDeck,nil)
		if #tg==#og+1 and Duel.ShuffleIntoDeck(tg,tp,nil,SEQ_DECKTOP)>0 then
			Duel.ShuffleDeck(tp)
			if Duel.Draw(1-tp,2,REASON_EFFECT) then
				local drawg=Duel.GetGroupOperatedByThisEffect(e)
				local c=e:GetHandler()
				for dc in aux.Next(drawg) do
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(66)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD)
					dc:RegisterEffect(e1)
				end
			end
		end
	elseif tc:IsAbleToGrave() then
		Duel.SendtoGrave(tc,REASON_EFFECT|REASON_EXCAVATE)
	end
end