local m=33310252
local cm=_G["c"..m]
cm.name="危险的亢奋状态"
cm.counter=0x554
function cm.initial_effect(c)
	c:EnableCounterPermit(cm.counter)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--Atk Up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetLabelObject(e4)
	e5:SetOperation(cm.addop)
	c:RegisterEffect(e5)
end
--Counter
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if eg then tc=eg:GetFirst() end
	if re then tc=re:GetHandler() end
	return ep~=tp and tc:IsFaceup() and tc:IsSetCard(0x554)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(cm.counter,1)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
--Atk Up
function cm.atkval(e,c)
	return e:GetHandler():GetCounter(cm.counter)*200
end
--Special Summon
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetCounter(cm.counter))
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x554) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	for i=1,ct do
		Duel.Damage(1-tp,100,REASON_EFFECT)
	end
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end