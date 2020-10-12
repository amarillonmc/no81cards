function c82228005.initial_effect(c)  
	--sp summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetTarget(c82228005.target)  
	e1:SetOperation(c82228005.operation)  
	c:RegisterEffect(e1) 
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,82228005)  
	e2:SetTarget(c82228005.reptg)  
	e2:SetValue(c82228005.repval)  
	e2:SetOperation(c82228005.repop)  
	c:RegisterEffect(e2)	   
end  

function c82228005.tgfilter(c,e,tp)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x290) and not c:IsCode(82228005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)  
end  

function c82228005.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228005.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
 
function c82228005.operation(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228005.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
 
function c82228005.repfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0x290)  
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)  
end  
 
function c82228005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c82228005.repfilter,1,nil,tp) end  
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)  
end  
 
function c82228005.repval(e,c)  
	return c82228005.repfilter(c,e:GetHandlerPlayer())  
end  
 
function c82228005.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)  
end  