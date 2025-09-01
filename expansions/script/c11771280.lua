--起始的命数 科诺托
function c11771280.initial_effect(c)
	--link summon
	c:SetSPSummonOnce(11771280)
	aux.AddLinkProcedure(c,c11771280.filter0,1,1)
	c:EnableReviveLimit()
	-- 战吼骰子
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771280,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11771280)
	e1:SetCondition(c11771280.con1)
	e1:SetTarget(c11771280.tg1)
	e1:SetOperation(c11771280.op1)
	c:RegisterEffect(e1)
	-- 墓地骰子调整
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771280,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11771281)
	e2:SetCondition(c11771280.con2)
	e2:SetOperation(c11771280.op2)
	c:RegisterEffect(e2)
end
-- link summon
function c11771280.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsEffectProperty(aux.MonsterEffectPropertyFilter(EFFECT_FLAG_DICE))
end
-- 1
function c11771280.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11771280.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771280.dicefilter(c)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
function c11771280.op1(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveSequence(tc,1)
		end
	elseif d==2 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveSequence(tc,1)
		end
	elseif d==3 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif d==4 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)==0 then return end
		Duel.DisableShuffleCheck()
		local g1=Duel.GetDecktopGroup(tp,1)
		local g2=Duel.GetDecktopGroup(1-tp,1)
		g1:Merge(g2)
		Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	elseif d==5 then
		local tp2=tp
		for p=0,1 do
			local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			if #g1>0 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RTOHAND)
				local sg=g1:Select(p,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		end
	elseif d==6 then
		local g=Duel.GetMatchingGroup(c11771280.dicefilter,tp,LOCATION_DECK,0,nil)
		if #g>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,2,2,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleDeck(tp)
			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end
-- 2
function c11771280.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c11771280.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if Duel.SelectYesNo(tp,aux.Stringid(11771280,1)) then
		Duel.Hint(HINT_CARD,0,11771280)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11771280,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		local op=Duel.SelectOption(tp,aux.Stringid(11771280,3),aux.Stringid(11771280,4))
		if op==0 then
			if dc[ac]<6 then
				dc[ac]=dc[ac]+1
			end
		else
			if dc[ac]>1 then
				dc[ac]=dc[ac]-1
			end
		end
		Duel.SetDiceResult(table.unpack(dc))
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end