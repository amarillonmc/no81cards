local m=15004549
local cm=_G["c"..m]
cm.name="净羽渊的潜光·安帕的使者"
function cm.initial_effect(c)
	aux.AddCodeList(c,15004550)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(cm.rccon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--never banished
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,15004549)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.rgtg)
	e2:SetOperation(cm.rgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.con1)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(cm.con2)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCondition(cm.con3)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetDescription(aux.Stringid(m,4))
	e6:SetCode(EVENT_SPSUMMON)
	e6:SetCondition(cm.con4)
	e6:SetTarget(cm.rgtg4)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetDescription(aux.Stringid(m,15))
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetDescription(aux.Stringid(m,4))
	c:RegisterEffect(e8)
	if cm.counter==nil then
		cm.counter=true
		cm[0]=0
		cm[1]=0
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge3:SetCode(EVENT_RELEASE)
		ge3:SetOperation(cm.addcount)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_RELEASE) then
			local p=tc:GetReasonPlayer()
			cm[p]=cm[p]+1
		end
		tc=eg:GetNext()
	end
end
function cm.rccon(e)
	local x=cm[e:GetHandler():GetControler()]
	return x>=3
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function cm.rgcfilter(c,e,code)
	return c:IsCanBeEffectTarget(e) and c:IsCode(code)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.rgcfilter,tp,LOCATION_REMOVED,0,1,nil,e,15004553)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.rgcfilter,tp,LOCATION_REMOVED,0,1,nil,e,15004556)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.rgcfilter,tp,LOCATION_REMOVED,0,1,nil,e,15004558)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.rgcfilter,tp,LOCATION_REMOVED,0,1,nil,e,15004560)
end
function cm.rgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	local _GetCurrentChain=Duel.GetCurrentChain
	Duel.GetCurrentChain=function() return _GetCurrentChain()-1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	local x=0
	local y=0
	if tc:IsSetCard(0x5f41) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:IsLevelBelow(6) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>=1 then
		y=1
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif tc:IsSetCard(0x5f41) and tc:IsFaceup() and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsAbleToGrave() and tc:CheckActivateEffect(false,true,false)~=nil then
		x=1
		y=2
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
	if x==1 then
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		Duel.ClearTargetCard()
		tc:CreateEffectRelation(e)
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		Duel.ClearOperationInfo(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
	Duel.GetCurrentChain=_GetCurrentChain
	e:SetLabel(y)
end
function cm.rgtg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	local _GetCurrentChain=Duel.GetCurrentChain
	Duel.GetCurrentChain=function() return _GetCurrentChain()-1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.rgcfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,15004560)
	local tc=g:GetFirst()
	local x=0
	local y=0
	if tc:IsSetCard(0x5f41) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:IsLevelBelow(6) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>=1 then
		y=1
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif tc:IsSetCard(0x5f41) and tc:IsFaceup() and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsAbleToGrave() and tc:CheckActivateEffect(false,true,false)~=nil then
		x=1
		y=2
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
	if x==1 then
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		Duel.ClearTargetCard()
		tc:CreateEffectRelation(e)
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		Duel.ClearOperationInfo(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
	Duel.GetCurrentChain=_GetCurrentChain
	e:SetLabel(y)
end
function cm.rgop(e,tp,eg,ep,ev,re,r,rp)
	local y=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if y==0 and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
	if y==1 and tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>=1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if y==2 then
		local te=e:GetLabelObject()
		if not te then return end
		if not te:GetHandler():IsRelateToEffect(e) then return end
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		Duel.BreakEffect()
		Duel.SendtoGrave(te:GetHandler(),REASON_EFFECT+REASON_RETURN)
	end
end