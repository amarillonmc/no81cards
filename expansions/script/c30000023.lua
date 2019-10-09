--终焉邪魂 魔化龙仆
function c30000023.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,30000023)
	e1:SetCondition(c30000023.spcon1)
	e1:SetTarget(c30000023.sptg)
	e1:SetOperation(c30000023.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c30000023.spcon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,30000024)
	e3:SetTarget(c30000023.tg)
	e3:SetOperation(c30000023.op)
	c:RegisterEffect(e3)
end

function c30000023.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) 
end

function c30000023.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and g:FilterCount(c30000023.cfilter,nil)==#g 
	and not Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000023.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and g:FilterCount(c30000023.cfilter,nil)==#g 
	and Duel.IsPlayerAffectedByEffect(tp,30000010)
end 

function c30000023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c30000023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

function c30000023.spfilter(c,e,tp)
	return c:IsSetCard(0x920) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c30000023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ba=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	local m=0
	if ba then m=1 end
	e:SetLabel(m)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c30000023.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c30000023.op2fil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)  or c:IsLocation(LOCATION_REMOVED)and c:IsAttribute(ATTRIBUTE_DARK)
end

function c30000023.op(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if m==1 and Duel.IsExistingMatchingCard(c30000023.op2fil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(30000023,1)) then
		local g=Duel.SelectMatchingCard(tp,c30000023.op2fil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		local g2=Duel.SelectMatchingCard(tp,c30000023.spfilter,tp,LOCATION_HAND,LOCATION_HAND,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end