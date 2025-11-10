--CAN:D 瑞蕾蒂娅
function c88888214.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8908),4,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888214,4))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,88888214)
	e1:SetCost(c88888214.thcost)
	e1:SetOperation(c88888214.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888214,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18888214)
	e2:SetCondition(c88888214.con)
	e2:SetTarget(c88888214.tg)
	c:RegisterEffect(e2)
end
function c88888214.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local mg=e:GetHandler():GetOverlayGroup()
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>0 and Duel.IsPlayerAffectedByEffect(tp,88888217) and Duel.SelectYesNo(tp,aux.Stringid(88888217,1)) then
		local sg=mg:Select(tp,1,ct,nil)
		if #sg~=0 then
			for sc in aux.Next(sg) do
				Duel.MoveToField(sc,tp,sc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				sc:RegisterEffect(e1)
				mg:Sub(Group.FromCards(sc))
			end
		end
	end
	if #mg>0 then e:GetHandler():RemoveOverlayCard(tp,#mg,#mg,REASON_COST) end
end
function c88888214.thfilter(c)
	return c:IsSetCard(0x8908) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c88888214.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c88888214.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ct=Duel.GetMatchingGroupCount(c88888214.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 then Duel.Recover(tp,2000,REASON_EFFECT) end
end
function c88888214.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c88888214.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,88888214)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888214.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88888214.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c88888214.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c88888214.stfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c88888214.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(88888214,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(88888214,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetOperation(c88888214.acop)
	elseif opval[op]==2 then
		e:SetOperation(c88888214.setop)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function c88888214.stfilter(c,tp)
	return c:IsCode(88888217) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c88888214.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c88888214.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c88888214.filter(c)
	return c:IsSetCard(0x8908) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c88888214.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888214.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end