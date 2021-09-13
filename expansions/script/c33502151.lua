--精神寰宇 幻感迷视
local m=33502151
local cm=_G["c"..m]
su_y=su_y or {}
function su_y.hdtograve(c,code,count) ---handtograve 33502151~33502157
	local tc=c
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	if count~=nil then
		e1:SetCountLimit(count,code)
	end
	e1:SetCost(su_y.hcost)
	e1:SetTarget(su_y.hdsptg0)
	e1:SetOperation(su_y.hdspop0)
	tc:RegisterEffect(e1)
	return e0,e1
end
function su_y.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0  and c:IsDiscardable(REASON_COST) end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetLabelObject(e)
	e1:SetTarget(su_y.splimitcost)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function su_y.splimitcost(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x3a81)
end
function su_y.hdsptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function su_y.hdspop0(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if Duel.GetMatchingGroup(su_y.thfilter1,tp,LOCATION_DECK,0,nil)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	   local g=Duel.SelectMatchingCard(tp,su_y.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	   if Duel.SSet(tp,g)~=0 then
		   Duel.ConfirmCards(1-tp,g)
		   local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)
		   local tc=tg:GetFirst()
		   while tc do 
		   tc:CancelToGrave()
		   Duel.ChangePosition(tc,POS_FACEDOWN)
		   tc=tg:GetNext()
		   end
		   local ng=Duel.GetMatchingGroup(su_y.stfil,tp,LOCATION_SZONE,0,1,nil)
		   Duel.ShuffleSetCard(ng)
	   end
	end
end
function su_y.stfil(c)
	return c:IsFacedown() and not c:IsLocation(LOCATION_FZONE)
end
function su_y.thfilter1(c)
	return (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)) and c:IsSetCard(0x3a81) and c:IsSSetable()
end
function su_y.sel(c,code,count) --- 33502151~33502157
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	if count~=nil then
		e1:SetCountLimit(count)
	end
	e1:SetCost(su_y.secost)
	e1:SetTarget(su_y.sesptg0)
	e1:SetOperation(su_y.sespop0)
	tc:RegisterEffect(e1)
	return e1
end
function su_y.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function su_y.sesptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(su_y.stfil,tp,LOCATION_SZONE,0,1,nil)>0 end
end
function su_y.sespop0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(su_y.stfil,tp,LOCATION_SZONE,0,nil)<=0 then return end 
	local g=Duel.SelectMatchingCard(tp,su_y.stfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e2)
end
function su_y.seltu(c,code) --- 33502151~33502157
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(su_y.actcon)
	tc:RegisterEffect(e1)
	return e1
end
--Act In Set Turn
function su_y.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(su_y.cfilter12,tp,LOCATION_ONFIELD,0,1,nil)
end
function su_y.cfilter12(c)
	return not(c:IsFaceup() and  c:IsType(TYPE_SPELL+TYPE_TRAP) )
end
function su_y.chai(c,code,count,op) --- 33502151~33502157
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	if count~=nil then
		e1:SetCountLimit(count,code)
	end
	e1:SetCondition(su_y.chtcon)
	e1:SetLabel(code)
	e1:SetOperation(op)
	tc:RegisterEffect(e1)
	return e1
end
function su_y.chtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	return  re:GetHandler():GetOwner()==tp and c:GetFlagEffect(code)==0 and re~=e and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 
end
-----------------------------
if not cm then return end
function cm.initial_effect(c)
	local e0,e1=su_y.hdtograve(c,m,1)
	local e2=su_y.sel(c,m,1)
	local e3=su_y.seltu(c)
	local e4=su_y.chai(c,m,1,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetLabelObject(e)
	e1:SetTarget(su_y.splimitcost)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.cop)
end
function cm.cop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(cm.stfile,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)<=0 then return end
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(su_y.thfilter1,tp,LOCATION_DECK,0,nil)<=0  then return end
	local g=Duel.SelectMatchingCard(tp,su_y.stfile,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
	Duel.SendtoHand(g,tp,REASON_EFFECT) 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	   local sg=Duel.SelectMatchingCard(tp,su_y.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	   if Duel.SSet(tp,sg)~=0 then
		   Duel.ConfirmCards(1-tp,sg)
		   local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)
		   local tc=tg:GetFirst()
		   while tc do 
		   tc:CancelToGrave()
		   Duel.ChangePosition(tc,POS_FACEDOWN)
		   tc=tg:GetNext()
		   end
		   local ng=Duel.GetMatchingGroup(su_y.stfil,tp,LOCATION_SZONE,0,1,nil)
		   Duel.ShuffleSetCard(ng)
		   local nc=ng:GetFirst()
		   while nc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		nc:RegisterEffect(e2)
		   nc=ng:GetNext()
		   end
			Duel.BreakEffect()
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	   end
	end
end
function su_y.stfile(c)
	return c:IsSetCard(0x3a81) and  c:IsAbleToHand()
end