--吮脑怪
local m=14010265
local cm=_G["c"..m]
function cm.initial_effect(c)
	--constraint summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
cm[0]=0
cm[1]=0
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.adjustcon)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	cm[cm.testp(tp)]=0
end
function cm.testp(tp)
	return 1-tp
end
function cm.exf(c,sg)
	return c:IsSynchroSummonable(nil,sg,#sg-2,#sg) or c:IsXyzSummonable(sg,#sg-2,#sg) or c:IsLinkSummonable(sg,nil,#sg-2,#sg)
end
function cm.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and cm[cm.testp(tp)]==0 and Duel.GetFieldGroupCount(cm.testp(tp),LOCATION_MZONE,0)>3 and Duel.GetCurrentPhase()==PHASE_END
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local p=cm.testp(tp)
	--if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	cm[p]=1
	local mzg=Duel.GetFieldGroup(p,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local exg=Duel.SelectMatchingCard(p,cm.exf,p,LOCATION_EXTRA,0,1,1,nil,mzg)
	local tc=exg:GetFirst()
	if tc then 
		--[[local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetOperation(cm.justop)
		e1:SetLabel(p)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e2,p)]]
		local off=1
		local ops={}
		local opval={}
		if tc:IsSynchroSummonable(nil,mzg,#mzg-2,#mzg) then
			ops[off]=1164
			opval[off-1]=1
			off=off+1
		end
		if tc:IsXyzSummonable(mzg,#mzg-2,#mzg) then
			ops[off]=1165
			opval[off-1]=2
			off=off+1
		end
		if tc:IsLinkSummonable(mzg,nil,#mzg-2,#mzg) then
			ops[off]=1166
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(p,table.unpack(ops))
		if opval[op]==1 then
			Duel.SynchroSummon(p,tc,nil,mzg,#mzg-2,#mzg)
		elseif opval[op]==2 then 
			Duel.XyzSummon(p,tc,mzg,#mzg-2,#mzg)
		elseif opval[op]==3 then
			Duel.LinkSummon(p,tc,mzg,nil,#mzg-2,#mzg)
		end
	else
		cm[p]=0
		Duel.SendtoGrave(mzg,REASON_RULE)
	end
	--Duel.Readjust()
end
function cm.justop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.this,1,nil,e:GetLabelObject()) then
		cm[e:GetLabel()]=0
		e:Reset()
	end
end
function cm.this(c,ec)
	return c==ec
end