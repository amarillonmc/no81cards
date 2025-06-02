--秘计螺旋 漆黑
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+11451961)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(0xff)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	if not DEFECT_ORAL_CHECK then
		DEFECT_ORAL_CHECK=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.resetop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CUSTOM+11451961)
		ge2:SetOperation(cm.evop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:GetFlagEffect(11451961)>0 end,0,0xff,0xff,nil)+Duel.GetOverlayGroup(0,1,1):Filter(function(c) return c:GetFlagEffect(11451961)>0 end,nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:GetFlagEffect(11451962)>0 end,0,0xff,0xff,nil)+Duel.GetOverlayGroup(0,1,1):Filter(function(c) return c:GetFlagEffect(11451962)>0 end,nil)
	for tc in aux.Next(g1) do tc:ResetFlagEffect(11451961) end
	for tc in aux.Next(g2) do tc:ResetFlagEffect(11451962) end
end
function cm.evop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetCurrentChain()==0 then Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+11451961,re,0,0,0,0) return end
	local ge2=Effect.CreateEffect(e:GetHandler())
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetOperation(function(e) Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+11451961,re,0,0,0,0) e:Reset() end)
	Duel.RegisterEffect(ge2,0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:RegisterFlagEffect(11451962,RESET_EVENT+RESET_TODECK+RESET_TOHAND+RESET_TURN_SET+RESET_OVERLAY+RESET_CHAIN,EFFECT_FLAG_OATH,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	--[[e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.recon)
	e1:SetOperation(cm.reop)--]]
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.actarget2)
	e1:SetOperation(cm.costop2)
	Duel.RegisterEffect(e1,tp)
	local eid=e1:GetFieldID()
	e1:SetLabel(eid)
	cm[e1]={}
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	DEFECT_ORAL_COUNT=DEFECT_ORAL_COUNT or 3
	if #eset==DEFECT_ORAL_COUNT then
		local de=eset[1]
		local ce=de:GetLabelObject()
		if ce and aux.GetValueType(ce)=="Effect" then
			local tc=ce:GetHandler()
			local eset2={tc:IsHasEffect(EFFECT_FLAG_EFFECT+11451961)}
			local res=false
			for _,te in pairs(eset2) do
				if te:GetLabel()==de:GetLabel() then res=true break end
			end
			if res then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+11451961,e,0,0,0,0)
				Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(tc:GetOriginalCode(),3))
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(tc:GetOriginalCode(),3))
			end
			ce:Reset()
		end
		de:Reset()
		eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
		for _,te in pairs(eset) do
			local te2=te:Clone()
			te2:SetDescription(te:GetDescription()-16)
			Duel.RegisterEffect(te2,tp)
			local ce=te:GetLabelObject()
			if ce and aux.GetValueType(ce)=="Effect" then
				local tc=ce:GetHandler()
				local ce2=ce:Clone()
				ce2:SetDescription(ce:GetDescription()-16)
				tc:RegisterEffect(ce2,true)
				te2:SetLabelObject(ce2)
				ce:Reset()
			end
			te:Reset()
		end
	end
	local ce=nil
	eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	if c:GetFlagEffect(11451962)>0 or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)) then
		ce=c:RegisterFlagEffect(11451961,RESET_EVENT+RESET_TODECK+RESET_TOHAND+RESET_TURN_SET+RESET_OVERLAY,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(11451961+#eset,1))
	end
	local de=Effect.CreateEffect(c)
	de:SetDescription(aux.Stringid(11451961+#eset,8))
	de:SetLabel(eid)
	de:SetType(EFFECT_TYPE_FIELD)
	de:SetCode(EFFECT_FLAG_EFFECT+11451961)
	de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	de:SetTargetRange(1,0)
	Duel.RegisterEffect(de,tp)
	if ce and aux.GetValueType(ce)=="Effect" then de:SetLabelObject(ce) end
end
function cm.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and not cm[e][te]
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	local res=false
	for _,te in pairs(eset) do
		if te:GetLabel()==e:GetLabel() then res=true break end
	end
	if not res then e:Reset() return false end
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	cm[e][te]=true
	local tg=te:GetTarget() or aux.TRUE
	local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
				e:SetTarget(tg)
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				for i=1,1+#{Duel.IsPlayerAffectedByEffect(0,11451973)} do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
					local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1972,1)
					if #g>0 then
						local prop1,prop2=e:GetProperty()
						te:SetProperty(prop1|EFFECT_FLAG_IGNORE_IMMUNE,prop2)
						g:GetFirst():AddCounter(0x1972,1)
						te:SetProperty(prop1,prop2)
					end
				end
			end
	te:SetTarget(tg2)
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	local res=false
	for _,te in pairs(eset) do
		if te:GetLabel()==e:GetLabel() then res=true break end
	end
	if not res then e:Reset() return end
	for i=1,1+#{Duel.IsPlayerAffectedByEffect(0,11451973)} do
		Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(rp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1972,1)
		if #g>0 then
			g:GetFirst():AddCounter(0x1972,1)
		end
	end
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:IsLocation(LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0) end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 then
		local ct=Duel.GetCounter(tp,1,1,0x1972)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,ct//2,ct//2,nil)
			if #rg>0 then
				Duel.HintSelection(rg)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end