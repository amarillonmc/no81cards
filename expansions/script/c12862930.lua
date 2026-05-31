-- 晴空光行·柔光花礼
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7623640,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsMainPhase() and Duel.GetCurrentChain()==0
end
function s.filter1(c,e,tp,eg,ep,ev,re,r,rp)
	local check=false
	if c:GetOriginalCode()==id-10 then check=true end
	local te=c:CheckActivateEffect(check,false,false)
	if c:IsSetCard(0x5a76) and c:GetType()==TYPE_SPELL and te and te:CheckCountLimit(tp)  then
		if c:IsSetCard(0x95) then
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else
			return true
		end
	end
	return false
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp) 
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.aclimit(e,re,tp)
    local rc=re:GetHandler()
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not (rc:GetOriginalType()==TYPE_SPELL or rc:IsSetCard(0x5A76) or rc:IsCode(11451827))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
  	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
	  	local ge=Effect.CreateEffect(tc)
		ge:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge:SetCode(EVENT_CHAIN_SOLVED)
		ge:SetRange(LOCATION_HAND)
		ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge:SetOperation(s.solveop)
		tc:RegisterEffect(ge)
	end
end
function s.solveop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if tc:GetType()==TYPE_SPELL and tc:IsHasEffect(EFFECT_REMAIN_FIELD)==nil then
		tc:CancelToGrave(false)
	end		
	tc:CreateEffectRelation(te)
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then
		if tc:IsSetCard(0x95) then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:GetCount()>0 then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end

	if op then
		if tc:IsSetCard(0x95) then
			op(e,tp,eg,ep,ev,re,r,rp)
		else
			op(te,tp,eg,ep,ev,re,r,rp)
		end
	end
	tc:ReleaseEffectRelation(te)
	te:UseCountLimit(tp,1)
	if g and g:GetCount()>0 then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	return te and aux.GetValueType(te:GetHandler())=="Card" and te:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.thcheck(c,typ)
	return not c:IsType(typ) and c:IsSetCard(0x5A76) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local typ=re:GetActiveType()&0X7
	e:SetLabel(typ)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thcheck,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,typ) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	local typ=e:GetLabel()
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thcheck),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,typ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thcheck),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,typ)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end