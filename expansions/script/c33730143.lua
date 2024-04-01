--[[
键★LB令 - 战斗排名！
K.E.Y L.B.O - Let's Start the Battle Ranking!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not STICKERS_LOADED then
	Duel.LoadScript("stickers.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	--When this card is activated: Shuffle 1 FIRE "K.E.Y Fragments" monster from your GY into the Deck.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--If you would place a Sticker(s) on a card your opponent controls, you can place it on this card instead.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_PLACE_STICKER_REPLACE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetOperation(s.replace)
	c:RegisterEffect(e2)
	--Your opponent gains the effects of all the Stickers that are on this card.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_GRANT_PLAYER_STICKER_EFFECT)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
end
--E1
function s.filter(c)
	return c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.Necro(s.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

--E2
function s.replace(e,tc,sticker,ct,re,rp,r,chk)
	local c=e:GetHandler()
	if chk==0 then
		return rp==e:GetHandlerPlayer() and c:IsCanAddSticker(sticker,ct,re,rp,r|REASON_REPLACE)
	end
	Duel.Hint(HINT_CARD,0,id)
	c:AddSticker(sticker,ct,re,rp,r|REASON_REPLACE)
end