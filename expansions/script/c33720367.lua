--[[
动物朋友 山本五郎左卫门
Anifriends Sanmoto Gorozaemon
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,CARD_MEMORIES_OF_THE_SANDSTAR)
	--3+ "Anifriends" monsters
	aux.AddXyzProcedureLevelFree(c,s.matfilter,nil,3,99)
	--[[If this card is Summoned: Send 1 "Memories of the Sandstar" from your hand or Deck to the GY, OR send this card to the GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.tgtg,s.tgop)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
	--[[You can detach all materials from this card, then look at your opponent's hand, then target a number of face-up cards they control and/or choose cards in their hand, equal to the number of
	materials detached this way; look at your opponent's Deck, and if you do, banish all cards with the same name as those targeted/chosen cards from their Deck and GY, face-down, and if you do,
	your opponent chooses 1 of these effects for you to apply.
	● Shuffle those targeted/chosen cards into the Deck
	● This card gains 200 ATK for each one of those targeted/chosen cards.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_REMOVE|CATEGORY_TODECK|CATEGORY_ATKCHANGE|CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(nil,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
		ge1:SetOperation(s.createtoken)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.createtoken(e)
	s.CheckCodeToken=Duel.CreateToken(0,0)
	e:Reset()
end

function s.matfilter(c)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(ARCHE_ANIFRIENDS)
end

--E1
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
	if c:IsRelateToChain() then
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	end
end
function s.tgfilter(c)
	return c:IsCode(CARD_MEMORIES_OF_THE_SANDSTAR) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExists(false,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil)
	local b2=c:IsRelateToChain() and c:IsAbleToGrave()
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,id,1,b1,b2)
	if opt==0 then
		local g=Duel.Select(HINTMSG_TOGRAVE,false,tp,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif opt==1 then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

--E2
function s.deckcon(deck,tp,unknownHand,convulsion,fg)
	local ct=#deck
	if ct>1 then
		return deck:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEDOWN)
	elseif ct==1 then
		local c=deck:GetFirst()
		return c:IsAbleToRemove(tp,POS_FACEDOWN) and (not convulsion or unknownHand or fg:IsExists(Card.IsCode,1,nil,c:GetCode()))
	else
		return false
	end
end
function s.gycon(gy,tp,unknownHand,fg)
	return #gy>0 and (unknownHand or gy:IsExists(s.rmfilter,1,nil,tp,fg))
end
function s.rmfilter(c,tp,fg)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and s.fgfilter(c,fg)
end
function s.fgfilter(c,fg)
	return fg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.notExtraDeckMonster(c)
	if not c:IsOriginalType(TYPE_TOKEN|TYPE_EXTRA) then
		if not c:IsHasEffect(EFFECT_CHANGE_CODE) then return true end
	else
		local codes={c:GetCode()}
		if #codes==1 and not c:IsHasEffect(EFFECT_CHANGE_CODE) and not c:IsHasEffect(EFFECT_ADD_CODE) then return false end
	end
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		s.CheckCodeToken:SetEntityCode(code,true)
		if s.CheckCodeToken:GetOriginalType()&(TYPE_TOKEN|TYPE_EXTRA)==0 then
			return true
		end
	end
	return false
end
function s.fecheck2(rg)
	return	function(c,e,tp)
				return s.fgfilter(c,rg)
			end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	local hand,deck,gy=Duel.GetHand(1-tp),Duel.GetDeck(1-tp),Duel.GetGY(1-tp)
	local fg=Duel.Group(aux.FaceupFilter(Card.IsCanBeEffectTarget,e),tp,0,LOCATION_ONFIELD,nil)+hand:Filter(Card.IsPublic,nil)
	local g=fg+hand
	local rg=deck+gy
	local unknownHand=hand:IsExists(aux.NOT(Card.IsPublic),1,nil)
	local convulsion=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_DECK)
	if chk==0 then
		return e:IsCostChecked() and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) and #g>=ct and #deck>0
			and (s.deckcon(deck,tp,unknownHand,convulsion,fg) or s.gycon(gy,tp,unknownHand,fg))
	end
	local n=c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
	if #hand>0 then
		Duel.ConfirmCards(tp,hand)
	end
	Duel.HintMessage(tp,HINTMSG_TARGET)
	e:SetLabel(0)
	local fechk=(#deck>0 and (not convulsion or #deck>1)) and s.notExtraDeckMonster or s.fecheck2(rg)
	local tg=xgl.SelectUnselectGroup(0,g,e,tp,n,n,false,1,tp,HINTMSG_TARGET,nil,nil,nil,fechk)
	e:SetLabel(0)
	local tg1=tg:Filter(Card.IsOnField,nil)
	local tg2=tg-tg1
	if #tg1>0 then
		Duel.SetTargetCard(tg1)
	end
	if #tg2>0 then
		Duel.HintSelection(tg2)
		local ch=Duel.GetCurrentChain()
		for tc in aux.Next(tg2) do
			tc:CreateEffectRelation(e)
			tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,ch)
		end
	end
	
	local infoloc1,infoloc2=0,0
	if tg:IsExists(s.rmfilter,1,nil,tp,gy) then
		infoloc1=LOCATION_GRAVE
	else
		infoloc2=LOCATION_GRAVE
	end
	if #deck>0 and convulsion and tg:IsExists(Card.IsCode,1,nil,Duel.GetDecktopGroup(1-tp,1):GetFirst():GetCode()) then
		infoloc1=infoloc1|LOCATION_DECK
	else
		infoloc2=infoloc2|LOCATION_DECK
	end
	if infoloc1>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,infoloc1)
	end
	if infoloc2>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,infoloc2)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_ATKCHANGE,c,1,tp,0,#tg*200)
end
function s.handfilter(c,e,ch)
	return c:IsRelateToEffect(e) and c:HasFlagEffectLabel(id,ch)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local deck=Duel.GetDeck(1-tp)
	if #deck==0 then return end
	Duel.ConfirmCards(tp,deck)
	local tg1=Duel.GetTargetCards()
	local tg2=Duel.Group(s.handfilter,tp,0,LOCATION_HAND,nil,e,Duel.GetCurrentChain())
	tg1:Merge(tg2)
	if #tg1>0 then
		local rg=Duel.Group(aux.Necro(s.rmfilter),tp,0,LOCATION_DECK|LOCATION_GRAVE,nil,tp,tg1)
		if #rg>0 and Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 then
			local c=e:GetHandler()
			local b1=tg1:IsExists(Card.IsAbleToDeck,1,nil)
			local b2=c:IsRelateToChain() and c:IsFaceup()
			if not b1 and not b2 then return end
			local opt=aux.Option(1-tp,id,2,b1,b2)
			if opt==0 then
				Duel.SendtoDeck(tg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			elseif opt==1 then
				c:UpdateATK(#tg1*200,true,c)
			end
		end
	end
end