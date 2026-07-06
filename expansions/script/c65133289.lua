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
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
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
		
		Duel.ConfirmCards(1-tp,tc)
		g:AddCard(tc)
		last_tc=tc

		-- 既然是“直到自己喜欢的卡”，不论是否是字段卡，只要还没达到5张上限，就必须询问玩家是否继续
		if i<4 then
			if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				break
			end
		else
			-- 达到5张上限，必须停止
			break
		end
	end
	
	--Processing results
	if last_tc and last_tc:IsSetCard(0x838) then
		Duel.DisableShuffleCheck()
		g:RemoveCard(last_tc)
		--1. Add last card to hand
		if Duel.SendtoHand(last_tc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,last_tc)
		end
	end
	--2. Other excavated Talespace cards sent to GY
	local sg_gy=g:Filter(Card.IsSetCard,nil,0x838)
	if #sg_gy>0 then
		Duel.SendtoGrave(sg_gy,REASON_EFFECT+REASON_REVEAL)
		g:Sub(sg_gy)
	end
	-- 3. 剩下的卡以及这张卡回到卡组
	-- 剩下的卡本身就在卡组里不需要移动，只需把场地洗回。如果场地不在场上，直接洗切卡组即可。
	if #g>0 and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif #g>0 then
		Duel.ShuffleDeck(tp)
	end
end
