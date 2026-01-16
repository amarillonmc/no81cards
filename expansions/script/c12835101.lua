--侍之魂 仁人
function c12835101.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c12835101.con)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12835101.splimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(12835101)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c12835101.con)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_PUBLIC)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c12835101.con)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e5:SetTargetRange(2,0)
	c:RegisterEffect(e5)	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_MSET)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	e6:SetCondition(c12835101.con)
	e6:SetTarget(aux.TRUE)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e9:SetTarget(c12835101.sumlimit)
	c:RegisterEffect(e9)	
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e10:SetCountLimit(1,12835101)
	e10:SetTarget(c12835101.tg10)
	e10:SetOperation(c12835101.op10)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e11:SetCountLimit(1,12835101+100)
	e11:SetCondition(c12835101.con11)
	e11:SetTarget(c12835101.tg11)
	e11:SetOperation(c12835101.op11)
	c:RegisterEffect(e11)
	if not c12835101_single then
		c12835101_single=true
		c12835101_single_monster = {{},{}}
		local ce0=Effect.CreateEffect(c)
		ce0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce0:SetCode(EVENT_ADJUST)
		ce0:SetCondition(c12835101.con0)
		ce0:SetOperation(c12835101.op0)
		Duel.RegisterEffect(ce0,0)
	end
end
function c12835101.con0(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),12835101+100)==0
end
function c12835101.op0(e,tp,eg,ep,ev,re,r,rp)
	for tp = 0,1 do
		if Duel.GetCurrentPhase()==PHASE_END then
		Duel.RegisterFlagEffect(tp,12835101+100,RESET_PHASE+PHASE_DRAW,0,1)
		end
		if Duel.IsPlayerAffectedByEffect(tp,12835101) then 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil)
			::a::
			for tc in aux.Next(g) do
			local code=tc:GetCode()
			local cg=g:Filter(Card.IsCode,nil,code)
				if #cg>=2 then 
				Duel.Hint(3,tp,HINTMSG_TOGRAVE)
				local ccg=cg:Select(tp,#cg-1,#cg-1,nil)
				Duel.SendtoGrave(ccg,REASON_RULE)
				g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil)
				goto a
				end	 
			end
			g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil)
			if #g>0 then
			local o = {}
				for tc in aux.Next(g) do
				o[#o+1] = tc:GetCode()
				end
			c12835101_single_monster[tp+1] = o
			end 
		end
	end
end
function c12835101.con(e)
	return e:GetHandler():GetControler()==e:GetHandler():GetOwner()
end
function c12835101.splimit(e,c)
	local tp=e:GetHandlerPlayer()
	if #c12835101_single_monster[tp+1]<=0 then return end 
	return c:IsCode(table.unpack(c12835101_single_monster[tp+1]))
end
function c12835101.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function c12835101.q(c,ec,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c12835101.tg10(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12835101.q,tp,2,0,1,nil,c,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 end
	Duel.Hint(3,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c12835101.q,tp,2,0,1,1,nil,c,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SetTargetCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c12835101.op10(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) and Duel.Equip(tp,tc,c,true,true) then
	Duel.EquipComplete()
	end
end
function c12835101.con11(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c12835101.w(c)
	return c:IsType(6) and c:IsSetCard(0x3a70) and c:IsAbleToHand()
end
function c12835101.tg11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12835101.w,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,2)
end
function c12835101.op11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12835101.w,tp,1,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(2) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,2,0,1,nil) then
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local fg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,2,0,1,1,nil)
	Duel.SendtoDeck(fg,nil,2,REASON_EFFECT)
	end
end