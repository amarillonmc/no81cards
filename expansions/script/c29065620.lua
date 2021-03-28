--方舟之骑士·罗贝丝塔
function c29065620.initial_effect(c)
	c:EnableCounterPermit(0x11ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065620)
	e1:SetCost(c29065620.spcost)
	e1:SetTarget(c29065620.sptg)
	e1:SetOperation(c29065620.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c29065620.indcon)
	e2:SetOperation(c29065620.indop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,29065621)
	e4:SetCondition(c29065620.thcon)
	e4:SetTarget(c29065620.thtg)
	e4:SetOperation(c29065620.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
end
function c29065620.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.IsPlayerAffectedByEffect(tp,29065592) end
	if Duel.IsPlayerAffectedByEffect(tp,29065592) and (not Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.SelectYesNo(tp,aux.Stringid(29065592,0))) then
	Duel.RegisterFlagEffect(tp,29065592,RESET_PHASE+PHASE_END,0,1)
	else
	Duel.RemoveCounter(tp,1,0,0x11ae,1,REASON_COST)
	end
end
function c29065620.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29065620.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.IsExistingMatchingCard(c29065620.filter,tp,LOCATION_MZONE,0,1,nil) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
	end
end
function c29065620.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and e:GetLabel()==1 then
		Duel.BreakEffect()
		local n=1
		if Duel.IsPlayerAffectedByEffect(tp,29065580) then n=n+1 end
		e:GetHandler():AddCounter(0x11ae,n)
	end
end
function c29065620.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c29065620.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x11ae,1)
end
function c29065620.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c29065620.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c29065620.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c29065620.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x11ae,n)
end
function c29065620.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK or r==REASON_XYZ 
end
function c29065620.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsSetCard(0x87af) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065620,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
