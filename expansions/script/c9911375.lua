--雪狱之罪人 岸然
function c9911375.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9911375)
	e1:SetCondition(c9911375.spcon)
	e1:SetCost(c9911375.spcost)
	e1:SetTarget(c9911375.sptg)
	e1:SetOperation(c9911375.spop)
	c:RegisterEffect(e1)
	--give control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911376)
	e2:SetTarget(c9911375.cttg)
	e2:SetOperation(c9911375.ctop)
	c:RegisterEffect(e2)
	if not c9911375.global_check then
		c9911375.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c9911375.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911375.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousControler(tp) and not (c:IsLocation(LOCATION_HAND) and c:IsControler(tp))
end
function c9911375.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9911375.cfilter,1,nil,0) then
		Duel.RegisterFlagEffect(0,9911375,RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c9911375.cfilter,1,nil,1) then
		Duel.RegisterFlagEffect(1,9911375,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911375.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911375)>0 or Duel.GetFlagEffect(1-tp,9911375)>0
end
function c9911375.rlfilter(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c9911375.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9911375.rlfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local ct=Duel.GetCurrentChain()
	local te=nil
	if ct>1 then te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) end
	local b2=te and (te:IsActiveType(TYPE_MONSTER) or te:GetActiveType()==TYPE_TRAP)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tep,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9911375,0))) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ct-1,g)
		Duel.ChangeChainOperation(ct-1,c9911375.repop)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=Duel.SelectMatchingCard(tp,c9911375.rlfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(rg,REASON_COST)
	end
end
function c9911375.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
	end
end
function c9911375.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911375.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911375.ctfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsControlerCanBeChanged()
end
function c9911375.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911375.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911375.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c9911375.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c9911375.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and Duel.GetControl(tc,1-tp)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetTarget(c9911375.ftarget)
		e1:SetLabel(tc:GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE)
		e2:SetTarget(c9911375.ftarget)
		e2:SetValue(aux.tgoval)
		e2:SetLabel(tc:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9911375.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
