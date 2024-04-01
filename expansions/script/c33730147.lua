--[[
键★LB令 - 大闹一番！
K.E.Y L.B.O - Let's Make a Ruckus!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	c:Activation()
	--All FIRE "K.E.Y" monsters gain 100 ATK/DEF.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetValue(100)
	c:RegisterEffect(e1)
	e1:UpdateDefenseClone(c)
	--[[Once per turn: You can shuffle 1 FIRE "K.E.Y Fragments" monster into the Deck, and if you do, if that monster has an effect that places exactly 1 Sticker on itself when it is Summoned,
	you can place 1 such Sticker on this card.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCustomCategory(CATEGORY_PLACE_STICKER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:OPT()
	e2:SetFunctions(nil,nil,s.tdtg,s.tdop)
	c:RegisterEffect(e2)
	--FIRE "K.E.Y" monsters in the same column as this card gain the effects of all Stickers on this card.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_GRANT_STICKER_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.granttg)
	c:RegisterEffect(e3)
end
--E1
function s.target(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end

--E2
function s.tdfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.tdfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND|LOCATION_MZONE)
	local c=e:GetHandler()
	Duel.SetPossibleCustomOperationInfo(0,CATEGORY_PLACE_STICKER,c,1,c:GetControler(),c:GetLocation())
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_TODECK,false,tp,s.tdfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.ShuffleIntoDeck(g)>0 then
			local c=e:GetHandler()
			if not c:IsRelateToChain() then return end
			local tc=g:GetFirst()
			local ce=tc:IsHasEffect(33730147)
			if ce then
				local sticker=ce:GetValue()
				if c:IsCanAddSticker(sticker,1,e,tp,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					c:AddSticker(sticker,1,e,tp,REASON_EFFECT)
				end
			end
		end
	end
end

--E3
function s.granttg(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE) and e:GetHandler():GetColumnGroup():IsContains(c)
end