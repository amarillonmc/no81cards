--绝音魔女的悲叹旋律
function c71200888.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,71200888)
	e1:SetTarget(c71200888.target)
	e1:SetOperation(c71200888.activate)
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,71200889)
	e2:SetCondition(c71200888.rtdcon) 
	e2:SetTarget(c71200888.rtdtg)
	e2:SetOperation(c71200888.rtdop)
	c:RegisterEffect(e2)
end 
function c71200888.spfil(c,e,tp,code)
	return not c:IsCode(code) and c:IsSetCard(0x895) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71200888.ctfil(c,e,tp)
	return c:IsSetCard(0x895) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c71200888.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c71200888.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71200888.ctfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c71200888.ctfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst() 
	e:SetLabel(tc:GetCode())
	Duel.SendtoGrave(tc,REASON_COST) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c71200888.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local code=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71200888.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71200888.rckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x895)   
end 
function c71200888.rtdcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c71200888.rckfil,tp,LOCATION_MZONE,0,1,nil)  
end 
function c71200888.rtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1400)
end
function c71200888.rtdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.Recover(tp,1400,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.BreakEffect() 
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
	end 
end 






