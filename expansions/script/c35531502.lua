--灰流丽·可爱
function c35531502.initial_effect(c)
	aux.AddCodeList(c,14558127)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,35531501+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c35531502.hspcon)
	c:RegisterEffect(e1) 
	--to deck and sp  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,15531502)  
	e2:SetTarget(c35531502.tgsptg)
	e2:SetOperation(c35531502.tgspop)
	c:RegisterEffect(e2) 
end
function c35531502.cfilter(c)
	return c:IsFaceup() and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and not c:IsCode(35531502)
end
function c35531502.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c35531502.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end 
function c35531502.espfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and c:IsType(TYPE_SYNCHRO)   
end 
function c35531502.tgsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsExistingTarget(c35531502.tdfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c35531502.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c35531502.tdfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c35531502.tgspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c35531502.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
		local sc=Duel.SelectMatchingCard(tp,c35531502.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure() 
	end 
end 






