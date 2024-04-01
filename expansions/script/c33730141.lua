--[[
键★LB令 - 任务派发！
K.E.Y L.B.O - Let's Issue A Mission!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--When this card is activated: Add 1 FIRE "K.E.Y Fragments" monster from your Deck to your hand.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--You can shuffle this card you control into your Deck; place 1 "K.E.Y L.B.O" card, except "K.E.Y L.B.O - Let's Issue A Mission!" from your Deck into your Spell & Trap Zone, face-up.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetFunctions(nil,aux.ToDeckSelfCost,s.pctg,s.pcop)
	c:RegisterEffect(e2)
end
--E1
function s.filter(c)
	return c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--E2
function s.actfilter(c,tp)
	return c:IsSetCard(ARCHE_KEY_LBO) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(id,true) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ft=(e:IsCostChecked() and c:IsInBackrow()) and -1 or 0
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft and Duel.IsExists(false,s.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function s.pcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.Select(HINTMSG_OPERATECARD,false,tp,s.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end