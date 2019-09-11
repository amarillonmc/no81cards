--兔·兔
function c11200022.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11200022.FusFilter,2,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11200022)
	e1:SetCondition(c11200022.con1)
	e1:SetTarget(c11200022.tg1)
	e1:SetOperation(c11200022.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11200022.con2)
	e2:SetOperation(c11200022.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200022.FusFilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function c11200022.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
		and c:GetMaterialCount()>0
end
--
function c11200022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200022.ofilter1(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
function c11200022.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc>0 and dc<4 then
		local num=dc*300
		if c:IsFacedown() then return end
		if not c:IsRelateToEffect(e) then return end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_UPDATE_ATTACK)
		e1_1:SetValue(num)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1_1)
		local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local sc=sg:GetFirst()
		while sc do
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_UPDATE_ATTACK)
			e1_2:SetValue(-num)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1_2)
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetType(EFFECT_TYPE_SINGLE)
			e1_3:SetCode(EFFECT_UPDATE_DEFENSE)
			e1_3:SetValue(-num)
			e1_3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1_3)
			sc=sg:GetNext()
		end
		Duel.Damage(1-tp,num,REASON_EFFECT)
	end
	if dc==4 then Duel.Damage(tp,1100,REASON_EFFECT) end
	if dc>4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if sg:GetCount()<1 then return end
		if Duel.Destroy(sg,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c11200022.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()<1 then return end
			Duel.BreakEffect()
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
--
function c11200022.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
		and c:GetFlagEffect(11200022)==0
end
function c11200022.op2(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c11200022[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(11200022,1)) then
		Duel.Hint(HINT_CARD,0,11200022)
		e:GetHandler():RegisterFlagEffect(11200022,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11200022,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		dc[ac]=7
		Duel.SetDiceResult(table.unpack(dc))
		c11200022[0]=cid
	end
end
