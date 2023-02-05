--天罚机 德拉格尼克Ⅱ
local m=30005103
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--special summon condition
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	ea:SetValue(aux.FALSE)
	c:RegisterEffect(ea)
	--punish
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CUSTOM+m)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1)
	local e2=e0:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e2)
	local e3=e0:Clone()
	e3:SetCode(EVENT_CHAIN_DISABLED)
	c:RegisterEffect(e3)
	local e9=e0:Clone()
	e9:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e9)
----buff----
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(1)
	--e5:SetCondition(cm.aacon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE) 
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetValue(cm.acval)
	--e6:SetCondition(cm.aacon2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	e7:SetCondition(cm.cacon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(cm.atkval)
	c:RegisterEffect(e8)
	--duel sunmmon success code
	if not cm.gf then 
		cm.gf=true  
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		Duel.RegisterEffect(ge1,0)
		ge1:SetOperation(cm.regop)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		ge3:SetOperation(cm.regop2)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHAIN_DISABLED)
		Duel.RegisterEffect(ge4,0)
	end
end
--duel sunmmon success code
function cm.cfilter(c,rp)
	return c:GetPreviousControler()~=rp
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if rp==i and eg:IsExists(cm.cfilter,1,nil,rp) then
			Duel.RegisterFlagEffect(1-rp,m,RESET_PHASE+PHASE_END,0,1)
			if Duel.GetFlagEffect(1-rp,m)>=2 then 
				Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,1-rp,ev)
			end
		end
	end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,m,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(ep,m)>=2 then
		Duel.RaiseEvent(re:GetHandler(),EVENT_CUSTOM+m,re,r,1-ep,ep,ev)
	end
end
--punish
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==tp 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.GetSelf(e) 
	if not e then e = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT) end
	return aux.ExceptThisCard(e)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=cm.GetSelf(e)
	if not c then return end
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	c:CompleteProcedure()
	if c:IsOnField() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
	   c:CompleteProcedure()
	   Duel.BreakEffect()
		if c:IsOnField() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
----buff----
function cm.aacon(e)
	return e:GetHandler():GetFlagEffect(30000240)==0
end
function cm.acval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)-1
end
function cm.aacon2(e)
	return e:GetHandler():GetFlagEffect(30000240)>0
end
function cm.cacon(e,tp)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)==0 and cm.aacon2(e)
end
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*700
end
end