function c82228509.initial_effect(c)  
	--summon with no tribute  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228509,0))  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetCondition(c82228509.ntcon)  
	e1:SetOperation(c82228509.ntop)  
	c:RegisterEffect(e1)
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228509,2))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCountLimit(1,82228509)  
	e2:SetCost(c82228509.cost)  
	e2:SetTarget(c82228509.target)  
	e2:SetOperation(c82228509.operation)  
	c:RegisterEffect(e2) 
end  
function c82228509.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82228509.ntop(e,tp,eg,ep,ev,re,r,rp,c)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228509,1))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetTarget(c82228509.tgtg)  
	e1:SetOperation(c82228509.tgop)  
	e1:SetReset(RESET_EVENT+0xc6e0000)  
	c:RegisterEffect(e1)  
end  
function c82228509.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end  
function c82228509.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
	end  
end  
function c82228509.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
function c82228509.spfilter(c,e,tp)  
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:GetLevel()==8 and c:IsSetCard(0x291) and not c:IsCode(82228509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82228509.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228509.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)  
end  
function c82228509.operation(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82228509.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  