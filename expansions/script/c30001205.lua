--炸卡下级 
local m=30001205
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_HAND)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetCondition(cm.con)
	--e51:SetCost(cm.cost)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51) 
	--Effect 2 
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,1))
	e11:SetCategory(CATEGORY_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_HAND)
	e11:SetCondition(cm.sumcon)
	e11:SetCost(cm.sumcost)
	e11:SetTarget(cm.sumtg)
	e11:SetOperation(cm.sumop)
	c:RegisterEffect(e11)
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_DECK)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_EXTRA) then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),m,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
--Effect 1
function cm.con(e)   
	return Duel.GetFlagEffect(0,m)>0 or Duel.GetFlagEffect(1,m)>0
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler() 
	if chk==0 then return not ec:IsPublic() end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	ec:RegisterEffect(e1)
end
function cm.zf(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsPlayerCanSSet(tp,c) and not c:IsForbidden()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.zf,tp,LOCATION_EXTRA,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if zt<=0 then return end
	local ct=1
	local x1=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	local x2=Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)
	if (x1-x2)>1 then ct=(x1-x2) end
	if ct>zt then ct=zt end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local xg=Group.CreateGroup()
	local g=Duel.SelectMatchingCard(tp,cm.zf,tp,LOCATION_EXTRA,0,1,ct,nil,tp)
	local tc=g:GetFirst()
	while tc do
		cm.pset(e,tp,tc)
		xg:AddCard(tc)
		tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc=g:GetNext()
	end
	xg:KeepAlive()
	Duel.ConfirmCards(1-tp,xg)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_PHASE+PHASE_END)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCountLimit(1)
	e01:SetLabel(fid)
	e01:SetLabelObject(xg)
	e01:SetCondition(cm.rmcon)
	e01:SetOperation(cm.rmop)
	Duel.RegisterEffect(e01,tp)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.spl)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.pset(e,tp,tc)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc:SetHint(CHINT_CARD,tc:GetCode())
	Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
function cm.rmfilter(c,fid)
	return c:GetFlagEffectLabel(m+100)==fid
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.rmfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function cm.spl(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
--Effect 2
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler() 
	if chk==0 then return Duel.CheckLPCost(tp,750) end
	Duel.PayLPCost(tp,750)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if bit.band(loc,LOCATION_FZONE)~=0 then return end
	return rp==1-tp and bit.band(loc,LOCATION_ONFIELD)~=0
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	if chk==0 then
		local tseq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)
		local seq=tseq
		local ze=1<<(4-seq) 
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetTargetRange(LOCATION_SZONE,0)
		if seq>=5 then
			e1:SetTarget(function(e,c) return (c:GetSequence()==1 and seq==5) or (c:GetSequence()==3 and seq==6) end)
		else 
			e1:SetTarget(function(e,c) return c:GetSequence()==4-seq end)
		end
		e1:SetValue(POS_FACEUP_ATTACK)
		e1:SetReset(RESET_EVENT+0x7e0000)
		tc:RegisterEffect(e1)
		local zze=ze
		if seq==5 then zze=1<<1 end
		if seq==6 then zze=1<<3 end
		local res=tc:IsSummonable(true,nil,1,zze) 
		e1:Reset()
		return res 
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if  tc:IsRelateToEffect(e) then
		local tseq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)
		local seq=tseq
		local ze=1<<(4-seq) 
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetTargetRange(LOCATION_SZONE,0)
		if seq>=5 then
			e1:SetTarget(function(e,c) return (c:GetSequence()==1 and seq==5) or (c:GetSequence()==3 and seq==6) end)
		else 
			e1:SetTarget(function(e,c) return c:GetSequence()==4-seq end)
		end
		e1:SetValue(POS_FACEUP_ATTACK)
		e1:SetReset(RESET_EVENT+0x7e0000)
		tc:RegisterEffect(e1)
		local zze=ze
		if seq==5 then zze=1<<1 end
		if seq==6 then zze=1<<3 end
		local s1=tc:IsSummonable(true,nil,1,zze)
		if not s1 then return false end
		Duel.Summon(tp,tc,true,nil,1,zze)
		--limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.limitop)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(cm.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=e:GetLabelObject()
	local tc=eg:GetFirst()
	if lc==tc and tc:IsSummonType(SUMMON_TYPE_ADVANCE) and tc:IsLocation(LOCATION_MZONE) then 
		Duel.Readjust()
		local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Destroy(cg,REASON_EFFECT)
		end 
	end
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end