--链环傀儡 氖素兵
local m=40010164
local cm=_G["c"..m]
cm.named_with_linkjoker=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_linkjoker
end
function cm.Reverse(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Reverse
end
function cm.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(cm.atkcon)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsFaceup() and cm.linkjoker(c)
end
function cm.atkcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and (cm.linkjoker(c) or cm.Reverse(c)) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) 
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0
	local lg=eg:Filter(cm.cfilter,nil,tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local lg=eg:Filter(cm.cfilter,nil,tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	if c:IsRelateToEffect(e) and zone~=0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP,zone) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end


