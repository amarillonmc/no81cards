--梦的极致
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000084)
function cm.initial_effect(c)
	local e1=rsef.FC(c,EVENT_PHASE_START+PHASE_DRAW,nil,{1,m,2},nil,LOCATION_HAND+LOCATION_DECK,cm.tdcon,cm.tdop)   
	local e2=rsef.FC(c,EVENT_ADJUST) 
	e2:SetOperation(cm.tdop2)
end
function cm.tdop2(e,tp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSendtoDeck(tp,c) then return end
	rshint.Card(m)
	Duel.SendtoDeck(c,nil,2,REASON_RULE)
end
function cm.tdcon(e,tp)
	local c=e:GetHandler()
	return not c:IsPublic() and not c:IsFaceup() and (not c:IsLocation(LOCATION_HAND) or Duel.IsPlayerCanSendtoDeck(tp,c))
end
function cm.tdop(e,tp)
	local c=e:GetHandler()
	rshint.Card(m)
	Duel.ConfirmCards(1-tp,c)
	if c:IsLocation(LOCATION_HAND) then 
		Duel.SendtoDeck(c,nil,2,REASON_RULE)
	end
	c:ReverseInDeck()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.distg)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(cm.aclimit)
	Duel.RegisterEffect(e3,tp)
	for p=0,1 do
		local e5=rsef.FC({c,p},EVENT_PHASE+PHASE_STANDBY,nil,1)
		rsef.RegisterSolve(e5,cm.ncon,nil,nil,cm.nop)
		e5:SetLabel(p)
	end
end
function cm.distg(e,c)
	return c:IsOriginalCodeRule(25010013)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(25010013)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsOriginalCodeRule(25010013)
end
function cm.ncon(e,tp)
	return Duel.GetTurnPlayer()==e:GetLabel()
end
function cm.cfilter(c)
	return c:IsFacedown()
end
function cm.nop(e,tp)
	local c=e:GetHandler()
	rshint.Card(m)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
	if #g<=1 then return end
	Duel.ConfirmCards(1-tp,g)
	rshint.Select(1-tp,HINTMSG_OPPO)
	local hg=g:Select(1-tp,1,1,nil) 
	Duel.ConfirmCards(tp,hg)
	hg:ForEach(cm.nfun,c)
	local e1=rsef.FC({c,0},EVENT_ADJUST)
	e1:SetOperation(cm.winop)
end
function cm.nfun(tc,c)
	tc:ReverseInDeck()
	tc:RegisterFlagEffect(m,rsreset.est,0,1)
	local e1=rsef.SV_ADD({c,tc,true},"code",25010013,nil,rsreset.est)
end
function cm.cfilter2(c)
	return c:GetFlagEffect(m)>0 and c:IsFaceup()
end
function cm.winop(e,tp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ct1=g1:FilterCount(cm.cfilter2,nil)
	local ct2=g2:FilterCount(cm.cfilter2,nil)
	local b1=#g1>0 and #g1==ct1 
	local b2=#g2>0 and #g2==ct2
	if not b1 and not b2 then return end
	rshint.Card(m)
	local winp=0
	if b1 and b2 then
		winp=PLAYER_NONE 
	elseif b1 then
		winp=tp
	else
		winp=1-tp
	end
	Duel.Win(winp,0x4)
end