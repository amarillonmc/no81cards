local m=53734014
local cm=_G["c"..m]
cm.name="青缀久候的迎接会"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+50)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.imtg)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsSetCard(0x3536) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and c:IsFaceup() and c:IsControler(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and Duel.GetTurnPlayer()~=tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3536) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(cm.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function cm.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if ct<=0 or g:GetCount()==0 then return end
	ct=math.min(ct,g:GetClassCount(Card.GetCode))
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if sg and sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,0)
	e:SetLabel(s)
	Duel.Hint(HINT_ZONE,tp,s)
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabel(z)
	e1:SetTarget(cm.tg)
	e1:SetValue(cm.val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tg(e,c)
	return 1<<c:GetSequence()==e:GetLabel()
end
function cm.val(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
