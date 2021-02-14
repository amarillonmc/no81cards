--雪超兽 斯诺基兰
local m=25000145
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	 aux.AddFusionProcFun2(c,cm.ffilter1,cm.ffilter2,false)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+20000)
	e3:SetCondition(cm.pencon)
	e3:SetTarget(cm.pentg)
	e3:SetOperation(cm.penop)
	c:RegisterEffect(e3)
end
function cm.ffilter1(c)
	return c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM)
end
function cm.ffilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_FIEND)
end

function cm.costfilter(c,e,tp,mg)
	if not (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_FUSION) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and  Duel.GetLocationCountFromEx(tp,tp,mg,c)>0) then return false end
	return c:GetLeftScale()>0  and  mg:CheckSubGroup(cm.fselect,2,c:GetLeftScale(),c:GetLeftScale(),tp)
end
function cm.fselect(g,sc,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetLeftScale,sc)
	else return false end
end
function cm.tefilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetLeftScale()>0 and c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_EXTRA,0,nil)   
	if chk==0 then return mg:CheckSubGroup(cm.fselect,1,c:GetLeftScale(),c:GetLeftScale(),tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_EXTRA,0,nil)   
	if not (c:IsRelateToEffect(e) and mg:CheckSubGroup(cm.fselect,1,c:GetLeftScale(),c:GetLeftScale(),tp)) then return end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=mg:SelectSubGroup(tp,cm.fselect,false,1,c:GetLeftScale(),c:GetLeftScale(),tp)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,TYPE_PENDULUM) end
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,TYPE_PENDULUM) then
		return
	end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	 local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,TYPE_PENDULUM)
	 local tc=g:GetFirst()
	local ss=0
	if tc:IsLocation(LOCATION_HAND) then 
	Duel.SendtoExtraP(tc,nil,REASON_DESTROY+REASON_EFFECT)
	ss=1
	else
	Duel.Destroy(tc,REASON_EFFECT)
	ss=1
	end
	if  ss==1 and  Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and   Duel.Destroy(eg,REASON_EFFECT)~=0 then	
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
	end
end

function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
