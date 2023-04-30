--逐火十三英桀 阿波尼亚
function c32131310.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SSET) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,32131310) 
	e1:SetCondition(c32131310.hspcon) 
	e1:SetTarget(c32131310.hsptg) 
	e1:SetOperation(c32131310.hspop) 
	c:RegisterEffect(e1)   
	local e2=e1:Clone() 
	e2:SetCode(EVENT_MSET) 
	c:RegisterEffect(e2)	
	--sort
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32131310,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,23131310) 
	e2:SetTarget(c32131310.sttg)
	e2:SetOperation(c32131310.stop)
	c:RegisterEffect(e2) 
	c32131310.sp_effect=e2 
end
c32131310.SetCard_HR_flame13=true  
function c32131310.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return true 
end
function c32131310.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32131310.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c32131310.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 end
end
function c32131310.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,5)
end








