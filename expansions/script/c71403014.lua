--两个人在一起就是最强的！
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403014,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(c71403014.tg1)
	e1:SetOperation(c71403014.op1)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403006)
	yume.PPTCounter()
end
function c71403014.filter1(c)
	return c:IsFaceup() and yume.PPTPlacePendExceptFromFieldFilter(c)
end
function c71403014.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	local bg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and bg:GetCount()>0
		and Duel.IsExistingMatchingCard(c71403014.filter1,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bg,1,0,0)
end
function c71403014.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local bg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local rc=bg:GetFirst()
	if rc and Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		rc:RegisterFlagEffect(71403014,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetCondition(c71403014.retcon)
		e1:SetOperation(c71403014.retop)
		Duel.RegisterEffect(e1,tp)
	else
		return
	end
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	local pg=Duel.GetMatchingGroup(c71403014.filter1,tp,LOCATION_EXTRA,0,nil)
	ct=math.min(ct,pg:GetCount())
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local spg=pg:Select(tp,ct,ct,nil)
	for pc in aux.Next(pg) do
		Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local op_flag=false
	for tc in aux.Next(g) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
			if not op_flag then
				op_flag=true
				Duel.BreakEffect()
			end
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	end
	if op_flag and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x715) then
		yume.OptionalPendulum(e,c,tp)
	end
end
function c71403014.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(71403014)~=0
end
function c71403014.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end