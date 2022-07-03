--卫星闪灵·雷吉艾勒奇
function c189120.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(189120,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,189120+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c189120.spcon)
	c:RegisterEffect(e1) 
	--to hand and sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,289120)
	e2:SetCondition(c189120.tspcon)
	e2:SetTarget(c189120.tsptg) 
	e2:SetOperation(c189120.tspop) 
	c:RegisterEffect(e2)
end
function c189120.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x180)
end
function c189120.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c189120.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c189120.tspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c189120.tsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end 
function c189120.spfil(c,e,tp) 
	return c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(189120)
end 
function c189120.tspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	if Duel.IsExistingMatchingCard(c189120.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(189120,1)) then 
	local sg=Duel.SelectMatchingCard(tp,c189120.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
	end 
end 















