--异种 兔子
function c98500220.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500220,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98500220)
	e1:SetCondition(c98500220.condition)
	e1:SetCost(c98500220.cost)
	e1:SetOperation(c98500220.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500220,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500221)
	e2:SetTarget(c98500220.hsptg)
	e2:SetOperation(c98500220.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500220,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500222)
	e3:SetOperation(c98500220.desop)
	c:RegisterEffect(e3)
	--tribute limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIBUTE_LIMIT)
	e4:SetValue(c98500220.tlimit)
	c:RegisterEffect(e4)
	--summon with 3 tribute
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98500220,2))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetCondition(c98500220.ttcon)
	e5:SetOperation(c98500220.ttop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e6)
	--change pos
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98500220,1))
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c98500220.postg2)
	e7:SetOperation(c98500220.posop2)
	c:RegisterEffect(e7)
end
function c98500220.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c98500220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(98500220,9),aux.Stringid(98500220,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c98500220.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c98500220.filter2(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK)
end
function c98500220.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	rc:CancelToGrave()
	local ts={}
	local index=1
	if c:IsType(TYPE_MONSTER) then
		ts[index]=aux.Stringid(98500220,3)
		index=index+1
	end
	if c:IsType(TYPE_MONSTER) then
		ts[index]=aux.Stringid(98500220,4)
		index=index+1
	end
	local opt=Duel.SelectOption(tp,table.unpack(ts))
	if ts[opt+1]==aux.Stringid(98500220,3) then
			Duel.SendtoHand(rc,tp,REASON_EFFECT)
			if rc:IsLocation(LOCATION_HAND) and rc:GetOwner()==1-tp then
				Duel.ShuffleHand(1-tp)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_CHAINING)
			if re:IsActiveType(TYPE_MONSTER) then
				e1:SetCondition(c98500220.setcon)
			elseif re:IsActiveType(TYPE_SPELL) then
				e1:SetCondition(c98500220.setcon2)
			elseif re:IsActiveType(TYPE_TRAP) then
				e1:SetCondition(c98500220.setcon3)
			end
			e1:SetOperation(c98500220.setop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
	elseif ts[opt+1]==aux.Stringid(98500220,4) then
		Duel.NegateEffect(ev)
	end
end
function c98500220.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c98500220.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function c98500220.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c98500220.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function c98500220.setcon3(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_TRAP) and Duel.IsExistingMatchingCard(c98500220.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function c98500220.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(98500220,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c98500220.filter3,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c98500220.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500220.filter4(c)
	return c:IsFacedown()
end
function c98500220.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500220.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (e:GetHandler():IsSummonable(true,nil) or e:GetHandler():IsMSetable(true,nil)) and (Duel.IsExistingTarget(c98500220.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,98500080) and Duel.IsExistingTarget(c98500220.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,98500080) then
		local g=Duel.SelectTarget(tp,c98500220.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c98500220.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c98500220.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
	local ts={}
	local index=1
	if e:GetHandler():IsSummonable(true,nil) then
		ts[index]=aux.Stringid(98500220,7)
		index=index+1
	end
	if e:GetHandler():IsMSetable(true,nil) then
	   ts[index]=aux.Stringid(98500220,8)
	   index=index+1
	end
	local c=e:GetHandler()
	local opt=Duel.SelectOption(tp,table.unpack(ts))
	if ts[opt+1]==aux.Stringid(98500220,7) then
		Duel.Summon(tp,c,true,nil)
	elseif ts[opt+1]==aux.Stringid(98500220,8) then
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
			e1:SetTarget(c98500220.tg)
			e1:SetValue(c98500220.efilter)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c98500220.tg(e,c)
	return c:IsFacedown()
end
function c98500220.efilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
function c98500220.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c98500220.filter5)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	Duel.RegisterEffect(e2,tp)
end
function c98500220.filter5(e,c)
	return c:IsType(TYPE_FLIP)
end
function c98500220.tlimit(e,c)
	return not c:IsPosition(POS_FACEDOWN)
end
function c98500220.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c98500220.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c98500220.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500220.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98500220.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c98500220.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c98500220.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(c98500220.filter3,nil)
	if g:GetCount()~=1 then return end
	for tc in aux.Next(g) do
	 if   Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) and
		Duel.SelectYesNo(tp,aux.Stringid(98500220,11)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c98500220.filter3,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		  end
		end
	end
end