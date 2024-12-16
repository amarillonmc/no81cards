local m=15005784
local cm=_G["c"..m]
cm.name="反诘视界-『局外人』"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.FilterBoolFunction(Card.IsFusionSetCard,0x3f43),2,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW+CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.atkfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_SZONE)) or c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.atkfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local ct=eg:FilterCount(cm.atkfilter,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function cm.rlfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(cm.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then
		ops[off]=aux.Stringid(m,1)
		opval[off]=1
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,1) then
		ops[off]=aux.Stringid(m,2)
		opval[off]=2
		off=off+1
	end
	if (not c:IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsChainDisablable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then
		ops[off]=aux.Stringid(m,3)
		opval[off]=3
		off=off+1
	end
	if chk==0 then return off>2 end
	local sel=Duel.SelectOption(tp,table.unpack(ops))+1
	local op=opval[sel]
	table.remove(ops,sel)
	table.remove(opval,sel)
	sel=Duel.SelectOption(tp,table.unpack(ops))+1
	op=op+(opval[sel]<<4)
	e:SetLabel(op)
	local op1=op&0xf
	local op2=op>>4
	if op1==1 or op2==1 then
		local g1=Duel.GetMatchingGroup(cm.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,1,0,0)
	end
	if op1==2 or op2==2 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if op1==3 or op2==3 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
		if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		end
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local op1=op&0xf
	local op2=op>>4
	local res=0
	if op1==1 or op2==1 then
		local g=Duel.GetMatchingGroup(cm.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g1=g:Select(tp,1,1,nil)
			Duel.Release(g1,REASON_EFFECT)
		end
		res=1
	end
	if op1==2 or op2==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if res==1 then Duel.BreakEffect() end
		Duel.Draw(p,d,REASON_EFFECT)
		res=1
	end
	if op1==3 or op2==3 then
		if res==1 then Duel.BreakEffect() end
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
		res=1
	end
end
function cm.cfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_SZONE)) or c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function cm.tdfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PSYCHO) and c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,aux.ExceptThisCard(e))
	if tg then
		Duel.HintSelection(tg)
		if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end