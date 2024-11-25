--瞬杀星 约克海宁
local m=91300024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCost(cm.cost)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.actcon)
	e1:SetOperation(cm.actop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--special summon self
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.hspcon)
	e2:SetTarget(cm.hsptg)
	e2:SetOperation(cm.hspop)
	e2:SetValue(cm.hspval)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--tag
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	--activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.descon)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desactivate)
	c:RegisterEffect(e5)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if e:GetLabel()==1 then
		tc=eg:GetFirst()
	else
		tc=e:GetHandler()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.stfilter(c,tc)
	local seq=c:GetSequence()
	return c:GetColumnGroup():IsContains(tc)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,c:GetColumnZone(LOCATION_MZONE,tp))>0 and Duel.IsExistingMatchingCard(cm.stfilter,tp,0,LOCATION_MZONE,1,nil,c) and Duel.CheckLocation(1-tp,LOCATION_SZONE,4-c:GetSequence())
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.stfilter,tp,0,LOCATION_MZONE,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,0,1,nil)
	if #sg>0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g:GetFirst() and Duel.MoveToField(g:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,1<<g:GetFirst():GetSequence()) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		g:GetFirst():RegisterEffect(e1,true)
	end
	g:DeleteGroup()
end
function cm.hspval(e,c)
	local tp=c:GetControler()
	return 0,c:GetColumnZone(LOCATION_MZONE,tp)
end
function cm.atkval(e,c)
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,m)*1000
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.RegisterFlagEffect(tp,m,0,0,0) 
	 Duel.RegisterFlagEffect(1-tp,m,0,0,0) 
end
function cm.thfilter(c)
	return c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.spfilter(c)
	return c:IsCode(m) and c:IsSpecialSummonable(0)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.desactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE,tp)>0 and c:IsCode(m) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		rc:RegisterEffect(e1)
	end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,0xff,0,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_SZONE,0,1,1,nil)
		if #g==0 then return end
		local tc=g:GetFirst()
		Duel.SpecialSummonRule(tp,tc,0)
	end
end