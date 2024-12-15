--异种 八姐妹
function c98500180.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500180,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98500180)
	e1:SetCondition(c98500180.condition)
	e1:SetCost(c98500180.cost)
	e1:SetTarget(c98500180.target)
	e1:SetOperation(c98500180.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500180,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500181)
	e2:SetTarget(c98500180.hsptg)
	e2:SetOperation(c98500180.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500180,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500182)
	e3:SetTarget(c98500180.destg)
	e3:SetOperation(c98500180.desop)
	c:RegisterEffect(e3)
	--tribute limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIBUTE_LIMIT)
	e4:SetValue(c98500180.tlimit)
	c:RegisterEffect(e4)
	--summon with 3 tribute
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98500180,2))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetCondition(c98500180.ttcon)
	e5:SetOperation(c98500180.ttop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e6)
end
function c98500180.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c98500180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(98500180,9),aux.Stringid(98500180,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c98500180.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c98500180.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c98500180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) and ((Duel.IsExistingMatchingCard(c98500180.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (Duel.IsExistingMatchingCard(c98500180.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c98500180.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.ConfirmCards(tp,g2)~=0 then
		Duel.ShuffleHand(1-tp)
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
		if g:GetCount()>0 then
			local ts={}
			local index=1
			if Duel.IsExistingMatchingCard(c98500180.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				ts[index]=aux.Stringid(98500180,3)
				index=index+1
			end
			if Duel.IsExistingMatchingCard(c98500180.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			   ts[index]=aux.Stringid(98500180,4)
			   index=index+1
			end
			local c=e:GetHandler()
			local opt=Duel.SelectOption(tp,table.unpack(ts))
			if ts[opt+1]==aux.Stringid(98500180,3) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,c98500180.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
				local tc=g:GetFirst()
				Duel.SSet(tp,tc)
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				if tc:IsType(TYPE_TRAP) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			elseif ts[opt+1]==aux.Stringid(98500180,4) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,c98500180.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
				local tc=g:GetFirst()
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function c98500180.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500180.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500180.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (e:GetHandler():IsSummonable(true,nil) or e:GetHandler():IsMSetable(true,nil)) and (Duel.IsExistingTarget(c98500180.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,16104622) and Duel.IsExistingTarget(c98500180.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,16104622) then
		local g=Duel.SelectTarget(tp,c98500180.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c98500180.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c98500180.filter4(c)
	return c:IsFacedown()
end
function c98500180.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
	local ts={}
	local index=1
	if e:GetHandler():IsSummonable(true,nil) then
		ts[index]=aux.Stringid(98500180,7)
		index=index+1
	end
	if e:GetHandler():IsMSetable(true,nil) then
	   ts[index]=aux.Stringid(98500180,8)
	   index=index+1
	end
	local c=e:GetHandler()
	local opt=Duel.SelectOption(tp,table.unpack(ts))
	if ts[opt+1]==aux.Stringid(98500180,7) then
		Duel.Summon(tp,c,true,nil)
	elseif ts[opt+1]==aux.Stringid(98500180,8) then
		Duel.MSet(tp,c,true,nil)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(c98500180.tg)
			e1:SetValue(c98500180.efilter)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c98500180.tg(e,c)
	return c:IsFacedown()
end
function c98500180.efilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
function c98500180.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c98500180.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	if Duel.SendtoHand(g1,tp,REASON_EFFECT)~=2 then
		local ts={}
		local index=1
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then
			ts[index]=aux.Stringid(98500180,5)
			index=index+1
		end
		if e:GetHandler():IsCanTurnSet() then
		   ts[index]=aux.Stringid(98500180,6)
		   index=index+1
		end
		local c=e:GetHandler()
		local opt=Duel.SelectOption(1-tp,table.unpack(ts))
		if ts[opt+1]==aux.Stringid(98500180,5) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoDeck(g3,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		elseif ts[opt+1]==aux.Stringid(98500180,6) then
			Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c98500180.tlimit(e,c)
	return not c:IsPosition(POS_FACEDOWN)
end
function c98500180.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=2 and Duel.CheckTribute(c,2)
end
function c98500180.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c98500180.setcon(e,c,minc)
	if not c then return true end
	return false
end
