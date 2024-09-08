--[[
动物朋友 走鹃
Anifriends G. Roadrunner
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When your opponent activates a card or effect that targets an "Anifriends" monster(s) on the field, or when an "Anifriend" monster is targeted for an attack by an opponent's monster
	(Quick Effect): You can reveal this card in your hand; excavate the top 5 cards of your Deck, and if all the excavated cards are "Anifriends" cards with different names,
	negate that attack or effect, and if you do, Special Summon this card. Otherwise, place this card on the top of your Deck. Also, place the excavated cards on the top of the Deck
	in the same order.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DISABLE|CATEGORY_SPECIAL_SUMMON|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetFunctions(s.efdrcon,aux.RevealSelfCost(),s.target(REASON_EFFECT),s.operation(REASON_EFFECT))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TODECK)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetFunctions(s.btdrcon,nil,s.target(REASON_BATTLE),s.operation(REASON_BATTLE))
	c:RegisterEffect(e2)
end
--E1
function s.drconfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(ARCHE_ANIFRIENDS)
end
function s.efdrcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.drconfilter,1,nil) and Duel.IsChainDisablable(ev)
end
function s.btdrcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and s.drconfilter(tc) and Duel.GetAttacker():IsControler(1-tp)
end
function s.target(mode)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then
					if mode==REASON_BATTLE and c:HasFlagEffect(id) then return false end
					local b1=c:IsAbleToDeck()
					local b2=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (mode~=REASON_EFFECT or not re:GetHandler():IsDisabled())
					return (b1 or b2) and Duel.GetDeckCount(tp)>=5
				end
				if mode==REASON_EFFECT then
					Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
				else
					c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,0)
				end
				Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_HAND)
				Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
			end
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(mode)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local ct=5
				Duel.ConfirmDecktop(tp,ct)
				local g=Duel.GetDecktopGroup(tp,ct)
				if not g or #g<ct then return end
				local c=e:GetHandler()
				local dnct=g:GetClassCount(Card.GetCode)
				if not g:IsExists(aux.NOT(Card.IsSetCard),1,nil,ARCHE_ANIFRIENDS) and dnct==#g then
					local res=Duel.NegateAttackOrEffect(mode,ev)
					if res and c:IsRelateToChain() then
						Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
					end
					
				elseif c:IsRelateToChain() then
					Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
				end
			end
end