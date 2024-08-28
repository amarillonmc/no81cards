--[[
本能的惊惧
Natural Fear
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--You can only control 1 "Natural Fear".
	c:SetUniqueOnField(1,0,id)
	--[[If a player(s) reveals or excavates a card(s), or if a player(s) adds a card(s) from their Deck to their hand: That player(s) takes 100 damage for each card they revealed,
	excavated and/or added.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_SZONE)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:Desc(1,id)
	e2:SetCode(EVENT_CUSTOM+50000000)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:Desc(2,id)
	e3:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		
		local _ConfirmCards, _ConfirmExtratop = Duel.ConfirmCards, Duel.ConfirmExtratop
		
		function Duel.ConfirmCards(p,g)
			if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
			local rg=g:Filter(Card.IsControler,nil,1-p)
			if #rg>0 then
				Duel.RaiseEvent(rg,EVENT_CUSTOM+id,nil,0,PLAYER_NONE,1-p,0)
			end
			return _ConfirmCards(p,g)
		end
		
		function Duel.ConfirmExtratop(p,ct)
			local rg=Duel.GetExtraTopGroup(p,ct)
			if #rg>0 then
				Duel.RaiseEvent(rg,EVENT_CUSTOM+id,nil,0,PLAYER_NONE,p,0)
			end
			return _ConfirmExtratop(p,ct)
		end
	end
end

function s.cfilter(c,p)
	return c:IsControler(p) and c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(p)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetCode()~=EVENT_TO_HAND and eg or eg:Filter(s.cfilter,nil,ep)
	if chk==0 then
		return #g>0
	end
	Duel.SetTargetPlayer(ep)
	local val=#g*100
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,ep,val)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end