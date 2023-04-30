--逐火十三英桀 梅比乌斯
function c32131312.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,32131312) 
	e1:SetCondition(c32131312.hspcon) 
	e1:SetTarget(c32131312.hsptg) 
	e1:SetOperation(c32131312.hspop) 
	c:RegisterEffect(e1) 
	--sort
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,23131312) 
	e2:SetTarget(c32131312.sttg)
	e2:SetOperation(c32131312.stop)
	c:RegisterEffect(e2) 
	c32131312.sp_effect=e2 
end
c32131312.SetCard_HR_flame13=true  
function c32131312.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) 
end
function c32131312.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32131312.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c32131312.tgfil(c) 
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL) and c:IsFaceup()  
end 
function c32131312.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131312.tgfil,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c32131312.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c32131312.tgfil,tp,0,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.SendtoGrave(dg,REASON_EFFECT)
	end 
end
