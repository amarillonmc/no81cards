--[[
不完美的莱特
Lumière, The Imperfect
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[If this card is Summoned: Declare 1 Monster Card name, then look at your opponent's Deck and send 1 card with that name to their GY, and if you do, choose 1 monster in your opponent's Deck, and
	this card gains ATK/DEF equal to that monster's ATK/DEF and its original effects, but shuffle it into your opponent's Deck when it leaves the field. If you cannot send a card to the GY this way,
	your opponent can look at your Deck, then add 1 card from it to their hand, also they can take control of this card.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_ANNOUNCE|CATEGORY_TOGRAVE|CATEGORY_DECKDES|CATEGORIES_ATKDEF|CATEGORY_TOHAND|CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
end
s.PreventWrongRedirect=false

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetPossibleCustomOperationInfo(0,CATEGORIES_ATKDEF,c,1,0,0,-2,OPINFO_FLAG_UNKNOWN)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK,1-tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
end
function s.filter(c,code)
	return c:IsAbleToGrave() and c:IsCode(code)
end
function s.copyfilter(c)
	return c:IsMonster() and (c:IsType(TYPE_EFFECT) or c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function s.thfilter(c,p)
	return Duel.IsPlayerCanSendtoHand(p,c)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(c).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
	Duel.BreakEffect()
	local deck=Duel.GetDeck(1-tp)
	Duel.ConfirmCards(tp,deck)
	local tg=deck:FilterSelect(tp,s.filter,1,1,nil,ac)
	if #tg>0 and Duel.SendtoGraveAndCheck(tg) then
		if c:IsRelateToChain() and c:IsFaceup() then
			local cg=Duel.Select(HINTMSG_OPERATECARD,false,tp,s.copyfilter,tp,0,LOCATION_DECK,1,1,nil)
			if #cg>0 then
				Duel.ConfirmCards(1-tp,cg)
				local cc=cg:GetFirst()
				c:UpdateATKDEF(cc:GetAttack(),cc:GetDefense(),true,c)
				if cc:IsType(TYPE_EFFECT) then
					c:CopyEffect(cc:GetOriginalCode(),RESET_EVENT|RESETS_STANDARD,1)
				end
				local e1=Effect.CreateEffect(c)
				e1:Desc(1,id)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT|EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCondition(function()
					return not s.PreventWrongRedirect
				end)
				e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
				e1:SetValue(LOCATION_DECKSHF)
				c:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EVENT_LEAVE_FIELD_P)
				e2:SetLabel(1-tp)
				e2:SetCondition(function()
					return not s.PreventWrongRedirect
				end)
				e2:SetOperation(s.bfdop)
				e2:SetReset(RESET_EVENT|RESETS_REDIRECT)
				c:RegisterEffect(e2,true)
			end
		end
	else
		deck=Duel.GetDeck(tp)
		if #deck>0 and deck:IsExists(s.thfilter,1,nil,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
			Duel.ConfirmCards(1-tp,deck)
			Duel.BreakEffect()
			Duel.HintMessage(1-tp,HINTMSG_ATOHAND)
			local tg=deck:FilterSelect(1-tp,s.thfilter,1,1,nil,1-tp)
			if #tg>0 then
				Duel.SendtoHand(tg,1-tp,REASON_EFFECT)
			end
		end
		if c:IsRelateToChain() and c:IsControlerCanBeChanged() and Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
			Duel.GetControl(c,1-tp)
		end
	end
end
function s.bfdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.PreventWrongRedirect=true
	Duel.SendtoDeck(c,e:GetLabel(),SEQ_DECKSHUFFLE,c:GetReason()|REASON_REDIRECT)
	s.PreventWrongRedirect=false
end