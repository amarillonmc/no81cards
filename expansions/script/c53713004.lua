local m=53713004
local cm=_G["c"..m]
cm.name="ALC之脑 TIS"
function cm.initial_effect(c)
	aux.AddFusionProcFunRep(c,function(c)return c:GetOriginalType()&TYPE_TRAP~=0 and c:IsFusionType(TYPE_MONSTER)end,2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2,m)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.alctg)
	e3:SetOperation(cm.alcop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.setfilter1(c,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(function(c,code)return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(code)end,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,c:GetCode())
end
function cm.tefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function cm.setfilter2(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:GetType()&0x20004==0x20004
end
function cm.alctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>4
	local b2=Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0)) else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,1-tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOEXTRA)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_ONFIELD)
	end
end
function cm.alcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		local sc=sg:GetFirst()
		if not sc then return end
		Duel.HintSelection(sg)
		sc:CancelToGrave()
		local pos=Duel.ChangePosition(sc,POS_FACEDOWN)
		if pos==0 then return end
		if sc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(sc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
		local g=Duel.GetDecktopGroup(1-tp,5)
		if #g>0 then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g==0 then return end
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_EXTRA) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,99,nil)
		if #sg==0 then return end
		Duel.HintSelection(sg)
		local rg=Group.CreateGroup()
		for tc in aux.Next(sg) do
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)~=0 and tc:IsFacedown() then rg:AddCard(tc) end
		end
		Duel.RaiseEvent(rg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		for rc in aux.Next(rg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			rc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e2:SetCode(EVENT_CHAINING)
			e2:SetOperation(cm.reset)
			e2:SetLabelObject(e1)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.setfilter3(c)
	return c:IsCode(53713010) and c:IsSSetable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,cm.setfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g1>0 then Duel.SSet(tp,g1) end
end
