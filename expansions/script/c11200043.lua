--腹黑兔 因幡帝
function c11200043.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,11200043)
	e1:SetCondition(c11200043.con1)
	e1:SetTarget(c11200043.tg1)
	e1:SetOperation(c11200043.op1)
	c:RegisterEffect(e1)
--
end
--
c11200043.xig_ihs_0x133=1
--
function c11200043.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
--
function c11200043.tfilter1(c,tp)
	return c.xig_ihs_0x133 and c:IsSSetable()
		and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
end
function c11200043.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c11200043.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c11200043.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local off=1
		local ops={}
		local opval={}
		local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c11200043.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
		local b2=Duel.IsPlayerCanDraw(tp,1)
		if b1 then
			ops[off]=aux.Stringid(11200043,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200043,2)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c11200043.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
			Duel.BreakEffect()
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
			local tc=g:GetFirst()
			if tc:IsPreviousLocation(LOCATION_HAND) then
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1_1=Effect.CreateEffect(c)
					e1_1:SetType(EFFECT_TYPE_SINGLE)
					e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1_1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1_1,true)
				end
				if tc:IsType(TYPE_TRAP) then
					local e1_2=Effect.CreateEffect(c)
					e1_2:SetType(EFFECT_TYPE_SINGLE)
					e1_2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1_2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1_2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1_2,true)
				end
				if tc:IsType(TYPE_SPELL) and not tc:IsType(TYPE_QUICKPLAY) then
					local e1_3=tc:GetActivateEffect()
					e1_3:SetProperty(0,EFFECT_FLAG2_COF)
					e1_3:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
					e1_3:SetCondition(c11200043.con1_3)
					tc:RegisterFlagEffect(11200043,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
					local e1_4=Effect.CreateEffect(c)
					e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1_4:SetCode(EVENT_ADJUST)
					e1_4:SetOperation(c11200043.op1_4)
					e1_4:SetLabelObject(tc)
					Duel.RegisterEffect(e1_4,tp)
				end
			end
		end
		if sel==2 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--
function c11200043.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1
end
function c11200043.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(11200043)>0 then return end
	local e1_3_1=tc:GetActivateEffect()
	e1_3_1:SetProperty(nil)
	e1_3_1:SetHintTiming(0)
	e1_3_1:SetCondition(aux.TRUE)
	e:Reset()
end
--
