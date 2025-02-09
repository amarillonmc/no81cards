--[[
动物朋友 蓝脸鲣鸟
Anifriends Masked Booby
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[If this card is Summoned: Shuffle, into the Deck, the first non-Warrior "Anifriends" monster found in your GY (starting from the bottom), and if you do, replace this effect with that monster's
	effects, also this card gains ATK/DEF equal to that monster's respective ATK/DEF.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TODECK|CATEGORIES_ATKDEF)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
	--[[During your End Phase, if this card is in your GY: You can discard 1 card; add this card to your hand.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:OPT()
	e2:SetFunctions(aux.TurnPlayerCond(0),aux.DiscardCost(),s.rthtg,s.rthop)
	c:RegisterEffect(e2)
end
--E1
function s.filter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and not c:IsRace(RACE_WARRIOR)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	local g=Duel.Group(s.filter,tp,LOCATION_GRAVE,0,nil)
	if #g==0 then
		Duel.SetPossibleCustomOperationInfo(0,CATEGORIES_ATKDEF,e:GetHandler(),1,tp,0,OPINFO_FLAG_HIGHER)
	else
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,0,tc:GetAttack())
		Duel.SetCustomOperationInfo(0,CATEGORY_DEFCHANGE,e:GetHandler(),1,tp,0,tc:GetDefense())
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(aux.Necro(s.filter),tp,LOCATION_GRAVE,0,nil)
	if #g==0 then return false end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	if tc:IsAbleToDeck() and Duel.ShuffleIntoDeck(tc)>0 then
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() then
			local code=tc:GetOriginalCodeRule()
			c:CopyEffect(code,RESET_EVENT|RESETS_STANDARD,1)
			c:UpdateATKDEF(tc:GetAttack(),tc:GetDefense(),true)
		end
	end
end

--E2
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetCardOperationInfo(c,CATEGORY_TOHAND)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end