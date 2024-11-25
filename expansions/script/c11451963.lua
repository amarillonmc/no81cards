--秘计螺旋 聚变
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
	local g1=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:GetFlagEffect(11451961)>0 end,0,0xff,0xff,nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:GetFlagEffect(11451962)>0 end,0,0xff,0xff,nil)
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
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
	local eid=e1:GetFieldID()
	e1:SetTarget(function(e,c)
					if e:GetLabel()==0 or Duel.GetFlagEffect(0,m+0xffffff+eid)>0 then return false end
					local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
					local res=false
					for _,te in pairs(eset) do
						if te:GetLabel()==e:GetLabel() then res=true break end
					end
					if not res then e:SetLabel(0) return false end
					return not c:IsCode(m)
				end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					Duel.RegisterFlagEffect(0,m+0xffffff+eid,RESET_PHASE+PHASE_END,0,1)
				end)
	e1:SetLabel(eid)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	Duel.RegisterEffect(e3,tp)
	local ce=nil
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	DEFECT_ORAL_COUNT=DEFECT_ORAL_COUNT or 3
	if #eset==DEFECT_ORAL_COUNT then
		local de=eset[1]
		local ce=de:GetLabelObject()
		if ce then
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
			if ce then
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
	eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	if c:GetFlagEffect(11451962)>0 or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)) then
		ce=c:RegisterFlagEffect(11451961,RESET_EVENT+RESET_TODECK+RESET_TOHAND+RESET_TURN_SET+RESET_OVERLAY,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(11451961+#eset,1))
	end
	local de=Effect.CreateEffect(c)
	de:SetDescription(aux.Stringid(11451961+#eset,7))
	de:SetLabel(eid)
	de:SetType(EFFECT_TYPE_FIELD)
	de:SetCode(0x20000000+11451961)
	de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	de:SetTargetRange(1,0)
	Duel.RegisterEffect(de,tp)
	if ce then de:SetLabelObject(ce) end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:IsLocation(LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0) end
end
function cm.cclfilter(c,tc)
	local seq1=aux.GetColumn(c)
	local seq2=aux.GetColumn(tc)
	return seq1 and seq2 and math.abs(seq1-seq2)==1 and c:IsAbleToHand()
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 and c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetCountLimit(1)
		e1:SetLabel(cid)
		e1:SetCondition(cm.con)
		Duel.RegisterEffect(e1,tp)
		local eid=e1:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,9))
		e1:SetTarget(function(e,c)
						local seq1=aux.GetColumn(c)
						local seq2=aux.GetColumn(e:GetHandler())
						return seq1 and seq2 and seq1-seq2==1
					end)
		e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						if chk==0 then return true end
						e:SetLabel(0)
					end)
		e1:SetLabel(eid)
		local e2=e1:Clone()
		e2:SetTarget(function(e,c)
						local seq1=aux.GetColumn(c)
						local seq2=aux.GetColumn(e:GetHandler())
						return seq1 and seq2 and seq1-seq2==-1
					end)
		Duel.RegisterEffect(e2,tp)
		--[[Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.cclfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler())
		if not g or #g==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)--]]
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():GetFlagEffect(m)>0 and e:GetHandler():GetFlagEffectLabel(m)==e:GetLabel() and e:GetHandler():IsFacedown()) then e:SetLabel(0) return false end
	return true
end