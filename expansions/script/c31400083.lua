local m=31400083
local cm=_G["c"..m]
cm.name="熊极天北天极基地"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(m)
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+100000000)
	e3:SetCondition(cm.tfcon)
	e3:SetTarget(cm.tftg)
	e3:SetOperation(cm.tfop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.setcon)
	e4:SetCost(cm.setcost)
	e4:SetTarget(cm.settg)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)
end
function cm.tffilter(c,tp)
	return (c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_HAND)) and c:IsSetCard(0x163) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function cm.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.tffilter,1,nil,tp)
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.setconfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x163) and c:IsControler(tp)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.setconfilter,1,nil,tp)
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function cm.settgfilter(c)
	return c:IsSetCard(0x163) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.settgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.settgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc:IsType(TYPE_QUICKPLAY) then
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		else
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		end
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCondition(cm.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.actconfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x163)
end
function cm.actcon(e)
	return Duel.GetMatchingGroupCount(cm.actconfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0
end
function cm.excostfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsHasEffect(m,tp)
end
function cm.UrsarcticSpSummonCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Auxiliary.UrsarcticReleaseFilter,e:GetHandler())
	local g2=Duel.GetMatchingGroup(Auxiliary.UrsarcticExCostFilter,tp,LOCATION_GRAVE,0,nil,tp)
	local g3=Duel.GetMatchingGroup(cm.excostfilter,tp,LOCATION_DECK,0,nil,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te1=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	local te2=tc:IsHasEffect(m,tp)
	if te1 then
		te1:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		if te2 then
			te2:UseCountLimit(tp)
			Duel.SendtoGrave(tc,REASON_COST)
		else
			Duel.Release(tc,REASON_COST)
		end
	end
end
if not cm.hack then
	cm.hack=true
	aux.UrsarcticSpSummonCost=cm.UrsarcticSpSummonCost
end