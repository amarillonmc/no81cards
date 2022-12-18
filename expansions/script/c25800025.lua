--小贝法
local m=25800025
local cm=_G["c"..m]
function cm.initial_effect(c)
aux.EnableChangeCode(c,25800023,LOCATION_MZONE+LOCATION_GRAVE)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)
end
-------3
function cm.cfilter(c)   
	   return c:IsCode(25800023)  and c:IsAbleToGrave() 
end
function cm.cfilter2(c)
	   return c:IsSetCard(0xa211)  and c:IsLevelAbove(5) and c:IsAbleToGrave()  
end
function cm.cfilter3(c)
	   return c:IsCode(25800023)   
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_DECK,0,nil) 
		or (Duel.GetMatchingGroupCount(cm.cfilter3,tp,LOCATION_GRAVE,0,nil) 
		and Duel.GetMatchingGroupCount(cm.cfilter2,tp,LOCATION_DECK,0,nil)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and (Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_DECK,0,nil) 
		or (Duel.GetMatchingGroupCount(cm.cfilter3,tp,LOCATION_GRAVE,0,nil) 
		and Duel.GetMatchingGroupCount(cm.cfilter2,tp,LOCATION_DECK,0,nil))) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if (Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_DECK,0,nil) 
		or (Duel.GetMatchingGroupCount(cm.cfilter3,tp,LOCATION_GRAVE,0,nil) 
		and Duel.GetMatchingGroupCount(cm.cfilter2,tp,LOCATION_DECK,0,nil)))==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g 
	if Duel.GetMatchingGroupCount(cm.cfilter3,tp,LOCATION_GRAVE,0,nil)==0 then  
	g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	else
	g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
	end 
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end