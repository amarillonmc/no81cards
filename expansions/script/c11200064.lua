--幸运的白兔 因幡帝
function c11200064.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,11200064)
	e1:SetCondition(c11200064.con1)
	e1:SetTarget(c11200064.tg1)
	e1:SetOperation(c11200064.op1)
	c:RegisterEffect(e1)
--
end
--
function c11200064.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
--
function c11200064.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=true
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c11200064.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local off=1
		local ops={}
		local opval={}
		local b1=true
		local b2=Duel.IsPlayerCanDraw(tp,1)
		if b1 then
			ops[off]=aux.Stringid(11200064,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200064,2)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.BreakEffect()
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_1:SetCode(EVENT_TOSS_DICE_NEGATE)
			e1_1:SetRange(LOCATION_MZONE)
			e1_1:SetCondition(c11200064.con1_1)
			e1_1:SetOperation(c11200064.op1_1)
			c:RegisterEffect(e1_1)
		end
		if sel==2 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--
function c11200064.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(11200064)==0
end
function c11200064.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c11200064[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(11200064,1)) then
		Duel.Hint(HINT_CARD,0,11200064)
		e:GetHandler():RegisterFlagEffect(11200064,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11200064,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		dc[ac]=7
		Duel.SetDiceResult(table.unpack(dc))
		c11200064[0]=cid
	end
end
--
