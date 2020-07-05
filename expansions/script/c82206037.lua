local m=82206037
local cm=_G["c"..m]
cm.name="植占师17-生命"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)
	--to hand  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_RECOVER)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,82216037)  
	e2:SetCondition(cm.thcon)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
function cm.spfilter(c,e,tp)  
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x129d) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return ep==tp  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToHand() end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SendtoHand(c,nil,REASON_EFFECT)  
	end  
end