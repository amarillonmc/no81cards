--[[
无限 ～熟悉的地方～
Ad Infinitum - Someplace I Knew -
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[When this card is activated: Send any number of other cards you control to the GY (min. 1), and if you do, record the names of those cards on this card.]]
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e0)
	--You can only control 1 "Ad Infinitum - Someplace I Knew -".
	c:SetUniqueOnField(1,0,id)
	--[[Cards with the same names as the ones recorded on this card are unaffected by other card effects, except this card's and their own effects.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	e2:SetTarget(s.etarget)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--Utility: Check names
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION|EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(5)
	e3:SetCondition(s.utilcon)
	e3:SetOperation(s.utilop)
	c:RegisterEffect(e3)
	if not s.TokenGroup then
		s.TokenGroup=Group.CreateGroup()
		s.TokenGroup:KeepAlive()
	end
end
--E0
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.Group(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then
		return #g>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.Group(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,aux.ExceptThis(c))
	if #g==0 then return end
	Duel.HintMessage(tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,#g,nil)
	if Duel.Highlight(tg) and Duel.SendtoGrave(tg,REASON_EFFECT)>0 and c:IsRelateToChain() and c:IsFaceup() then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		for tc in aux.Next(og) do
			local codes={tc:GetCode()}
			for _,code in ipairs(codes) do
				c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1,code)
			end
		end
	end
end

--E2
function s.etarget(e,c)
	local h=e:GetHandler()
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		if h:HasFlagEffectLabel(id,code) then
			return true
		end
	end
end
function s.efilter(e,re,c)
	local rc=re:GetOwner()
	return e:GetHandler()~=rc and c~=rc
end

--E3
function s.utilcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():HasFlagEffect(id)
end
function s.utilop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	for i,code in ipairs({c:GetFlagEffectLabel(id)}) do
		local tc=s.TokenGroup:Filter(Card.IsOriginalCode,nil,code):GetFirst()
		if not tc then
			tc=Duel.CreateToken(tp,code)
			if tc then
				s.TokenGroup:AddCard(tc)
			end
		end
		g:AddCard(tc)
	end
	Duel.ConfirmCards(tp,g)
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end