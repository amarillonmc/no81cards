--方舟骑士-四月
c29035174.named_with_Arknight=1
function c29035174.initial_effect(c)
	--special summon (hand/grave)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29035174,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29035174)
	e1:SetCondition(c29035174.spcon)
	e1:SetTarget(c29035174.sptg)
	e1:SetOperation(c29035174.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c29035174.spcost)
	c:RegisterEffect(e2)
end
function c29035174.cfilter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) 
end
function c29035174.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29035174.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c29035174.cfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsDiscardable()
end
function c29035174.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29035174.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c29035174.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c29035174.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29035174.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		   e1:SetValue(LOCATION_DECKBOT)
		   c:RegisterEffect(e1)
	   end
end