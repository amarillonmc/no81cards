--[[
多维破裂
Disarray
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When an Xyz Monster on the field activates its effect: Send, from your Deck to the GY, 2 monsters with a Level equal to that monster's Rank; negate that effect, and if you do, destroy it.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DISABLE|CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc&LOCATION_MZONE>0 and re:IsActiveType(TYPE_XYZ) and Duel.IsChainDisablable(ev)
end
function s.tgfilter(c,rk)
	return c:IsMonster() and c:IsLevel(rk) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local TriggerLocation,TriggerRank=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_RANK)
	local tc=re:GetHandler()
	local rk=(Duel.IsChainSolving() or (tc:IsRelateToChain(ev) and tc:IsFaceup() and tc:IsLocation(TriggerLocation))) and tc:GetRank() or TriggerRank
	if chk==0 then
		return Duel.IsExists(false,s.tgfilter,tp,LOCATION_DECK,0,2,nil,rk)
	end
	local g=Duel.Select(HINTMSG_TOGRAVE,false,tp,s.tgfilter,tp,LOCATION_DECK,0,2,2,nil,rk)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToChain(ev) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToChain(ev) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
