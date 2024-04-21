--真神 神之使徒
local m=91020015
local cm=c91020015
function c91020015.initial_effect(c)
--SpecialSummon  
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
		e1:SetCountLimit(1,m)
		e1:SetCondition(cm.con1)
		e1:SetTarget(cm.tg1)
		e1:SetOperation(cm.op1)
		c:RegisterEffect(e1)
--SearchCard
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,m*4)
		e2:SetTarget(cm.tg2)
		e2:SetOperation(cm.op2)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m*2)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.mvtg)
	e4:SetOperation(cm.mvop)
	c:RegisterEffect(e4)
end
--e1
function cm.filter1(c)
	return c:IsRace(RACE_DIVINE) and c:IsFaceup()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
  
end
--e2
function cm.filter(c)
	return c:IsSetCard(0x9d1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK,0,1,1,nil):GetFirst()
   if  not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end

--e3

function cm.thfilter3(c)
	return c:IsSetCard(0x9d1)  and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_ONFIELD,0,1,nil) end
 local g=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
 Duel.Release(g,REASON_COST)
end
function cm.filter2(c)
	return c:IsSetCard(0x9d1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() 
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if  not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end