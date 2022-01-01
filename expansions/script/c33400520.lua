--四糸乃 光·潜藏于心的爱恋
local m=33400520
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()  
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)   
	--pendulum set
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.pentg)
	e0:SetOperation(cm.penop)
	c:RegisterEffect(e0)
 --special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
 --
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,m+10000)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.pcfilter(c)
	return  c:IsSetCard(0xc342) and c:IsAbleToHand() 
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  not c:IsRelateToEffect(e) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.pcfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoExtraP(c,tp,REASON_EFFECT)
	end
end

function cm.ckfilter(c)
	return c:IsSetCard(0x3344) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) 
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x341) and  (c:IsAttribute(ATTRIBUTE_WATER) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)))  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)   end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not (lc>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp))  then return end 
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if lc>2 then lc=2 end
	local g1=g:SelectSubGroup(tp,cm.check,false,1,lc)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)  
	tc=g1:GetFirst() 
	while tc do
		tc:AddCounter(0x1015,1) 
		tc=g1:GetNext()
	end  
end
function cm.cfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.cfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function cm.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(cm.cfilter1,1,nil) then res=res+0x1 end
	if g:IsExists(cm.cfilter2,1,nil) then res=res+0x2 end   
	return res~=0x1 and res~=0x2 
end

function cm.setfilter(c)
	return c:IsSetCard(0x341) and c:IsLevelBelow(8) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.setfilter,tp,LOCATION_EXTRA,0,nil)
	if ct==0 or (Duel.CheckLocation(tp,LOCATION_PZONE,0)==0 and Duel.CheckLocation(tp,LOCATION_PZONE,1)==0)  then return end
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	local tc=g:GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	tc:AddCounter(0x1015,1)
end