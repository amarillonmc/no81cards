--武装战姬 联盟起始
local m=91000409
local cm=c91000409
function c91000409.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,0))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1,m)
	e11:SetTarget(cm.target)
	e11:SetOperation(cm.operation)
	c:RegisterEffect(e11)
	 local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9d2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
end
function cm.costfilter(c)
	return c:IsSetCard(0x9d2) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil)  end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD,nil) 
end
function cm.hspfilter(c,tp)
	return c:IsSetCard(0x9d2) and (c:IsSSetable() or not c:IsForbidden()) and c:IsType(TYPE_SPELL+TYPE_TRAP)  and   (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.hspfilter,tp,LOCATION_DECK,0,1,nil)   end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,chk)
if  not Duel.IsExistingMatchingCard(cm.hspfilter,tp,LOCATION_DECK,0,1,nil,tp) then return  end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	 local g=Duel.SelectMatchingCard(tp,cm.hspfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler(),tp)
 local b1=not g:GetFirst():IsForbidden()and g:GetFirst():IsType(TYPE_CONTINUOUS+TYPE_FIELD)
 local b2=g:GetFirst():IsSSetable() 
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,2)},
			{b2,aux.Stringid(m,1)})
	
	if op==1 then 
 if g:GetFirst():IsType(TYPE_FIELD) then Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
 else   
 Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
 else
 Duel.SSet(tp,g)
 end
end

