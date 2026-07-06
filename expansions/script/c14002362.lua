--沉溺混沌之邪光 哈斯塔
local m=14002362
local cm=_G["c"..m]
cm.named_with_Hastur=1
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(2,m)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(2,m)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.tkcost)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.get_available_field(tp,code)
	if not UraraG_fieldcheck then return nil end
	local c=nil
	if code==14002341 and UraraG_fieldcheck.release then
		c=UraraG_fieldcheck.release[tp]
	elseif code==14002342 and UraraG_fieldcheck.counter then
		c=UraraG_fieldcheck.counter[tp]
	end
	if c and type(c)=="userdata" and c:IsHasEffect(code)~=nil and c:GetFlagEffect(code)==0 then
		return c
	end
	return nil
end
function cm.chk_cost(tp)
	local ct=Duel.GetFlagEffect(tp,m)
	if ct>=3 then return false end
	if ct>=1 then
		if cm.get_available_field(tp, 14002342) ~= nil then
			return true
		end
		return Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	end
	return true
end
function cm.pay_cost(tp)
	local ct=Duel.GetFlagEffect(tp,m)
	if ct>=1 then
		local fc = cm.get_available_field(tp, 14002342)
		local has_counter = Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
		if fc and (not has_counter or Duel.SelectYesNo(tp,aux.Stringid(14002341,0))) then
			fc:RegisterFlagEffect(14002342,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		else
			Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_COST)
		end
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.rmfilter(c)
	return c:IsFaceupEx() and c:IsLevelBelow(3) and c:IsAbleToRemove()
end
function cm.urara_filter(c)
	return c:IsFaceup() and cm.Urara(c)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(100)
	else
		e:SetLabel(0)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
			local ch=Duel.GetCurrentChain()
			if ch>1 then
				local tep=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)
				if tep==1-tp and Duel.IsChainDisablable(ch-1) 
					and Duel.IsExistingMatchingCard(cm.urara_filter,tp,LOCATION_ONFIELD,0,1,nil) then
					Duel.BreakEffect()
					Duel.NegateEffect(ch-1)
				end
			end
		end
	end
	if e:GetLabel()==100 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsAttribute(ATTRIBUTE_WIND)
end
function cm.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=cm.get_available_field(tp,14002342)
	local has_counter=Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	if chk==0 then return fc~=nil or has_counter end
	if fc and (not has_counter or Duel.SelectYesNo(tp,aux.Stringid(14002341,0))) then
		fc:RegisterFlagEffect(14002342,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	end
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,14002382,0,TYPES_TOKEN_MONSTER,2500,2500,5,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,14002382,0,TYPES_TOKEN_MONSTER,2500,2500,5,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,14002382)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end