--延时龙卷
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174030
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:SetOperation(cm.op)
	if not cm.count then
		cm.count={[0]=0,[1]=0}
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(e2,0)
	end
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm.count={[0]=0,[1]=0}
end
function cm.op(e,tp,eg)
	cm.count[tp]=cm.count[tp]+1
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SSET)
	e1:SetCondition(cm.descon1)
	e1:SetOperation(cm.desop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SSET)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(g)
	e2:SetLabel(fid)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cm.descon2)
	e3:SetOperation(cm.desop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(g)
	e3:SetLabel(fid)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(cm.descon3)
	e4:SetOperation(cm.desop3)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.epop)
	Duel.RegisterEffect(e5,tp)
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
	return (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)) and cm.count[tp]>0
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	cm.desop(eg,tp,0)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Merge(eg)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(tc,m,0,rsreset.est_pend,1,e:GetLabel())
	end
end
function cm.cfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	return g:FilterCount(cm.cfilter,nil,e:GetLabel())>0 and cm.count[tp]>0
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.cfilter,nil,e:GetLabel())
	if #g>0 then
		cm.desop(g,tp,0)
	end
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_SZONE)~=0
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and cm.count[tp]>0
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	cm.desop(Group.FromCards(re:GetHandler()),tp,2)
end
function cm.epcon(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) 
end
function cm.epop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		cm.desop(g,tp,1)
	end
end
function cm.desop(rg,tp,hint)
	local g=rg:Clone()
	rg:Clear()
	if Duel.SelectYesNo(tp,aux.Stringid(m,hint)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		cm.count[tp]=cm.count[tp]-1
	end
end
