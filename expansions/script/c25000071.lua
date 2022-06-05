local m=25000071
local cm=_G["c"..m]
cm.name="华和流梦"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.Insubstantial_Mirages then
		cm.Insubstantial_Mirages=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.clear)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.rm)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.droperation)
	Duel.RegisterEffect(e2,tp)
end
function cm.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if cm[0]>cm[1] then Duel.Draw(0,cm[0],REASON_EFFECT) elseif cm[0]<cm[1] then Duel.Draw(1,cm[1],REASON_EFFECT) end
end
function cm.rm(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2 then return end
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:IsAbleToRemove()end,tp,LOCATION_MZONE,LOCATION_MZONE,nil,1)
	if Duel.Remove(hg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local g=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		for oc in aux.Next(g) do
			oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local p=oc:GetPreviousControler()
			cm[p]=cm[p]+1
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject():Filter(function(c)return c:GetFlagEffect(m)~=0 end,nil)
	for i=0,1 do
		local g=sg:Filter(Card.IsControler,nil,i)
		if #g>0 then
			local ft=Duel.GetLocationCount(i,LOCATION_MZONE)
			if #g>ft then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
				g=g:Select(tp,ft,ft,nil)
			end
			for tc in aux.Next(g) do Duel.ReturnToField(tc) end
		end
	end
end
