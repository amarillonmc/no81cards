--绘幻叙幻
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsSetCard(0x838) and c:IsFaceup()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local g=Group.CreateGroup()
	local last_tc=nil
	
	--Excavate loop
	for i=0,4 do
		--Get card at current top index (Total - 1 - i)
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-1-i)
		if not tc then break end
		
		Duel.ConfirmCards(tp,tc)
		g:AddCard(tc)
		last_tc=tc
		
		--If it is a Talespace card
		if tc:IsSetCard(0x838) then
			--If not reached limit (i<4), ask to continue
			if i<4 then
				if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					--User chose not to continue, stop here
					break
				end
				--User chose Yes, loop continues
			else
				--Reached limit 5, must stop
				break
			end
		else
			--If not Talespace card
			--If reached limit 5, stop. Otherwise force continue (loop automatically)
			if i==4 then break end
		end
	end
	
	--Processing results
	if last_tc and last_tc:IsSetCard(0x838) then
		Duel.DisableShuffleCheck()
		--1. Add last card to hand
		if Duel.SendtoHand(last_tc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,last_tc)
			g:RemoveCard(last_tc)
			
			--2. Other excavated Talespace cards sent to GY
			local sg_gy=g:Filter(Card.IsSetCard,nil,0x838)
			if #sg_gy>0 then
				Duel.SendtoGrave(sg_gy,REASON_EFFECT)
				g:Sub(sg_gy)
			end
			
			--3. Remaining cards AND this card return to Deck
			if c:IsRelateToEffect(e) then
				g:AddCard(c)
			end
			if #g>0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	else
		--Last card was not Talespace (or no cards found), just shuffle excavated cards back
		--The Field Spell stays on field in this case per instruction "No processing" (specifically regarding the moving/bouncing logic)
		Duel.ShuffleDeck(tp)
	end
end
