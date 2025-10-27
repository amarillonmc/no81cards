local m=15005645
local cm=_G["c"..m]
cm.name="枯绿界-避时的遗迹"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf42))
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.atkvalfilter(c)
	return c:GetMutualLinkedGroupCount()>0
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkvalfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*100
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3f42) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.disfilter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToGrave() and c:IsExtraLinkState()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFlagEffect(tp,m)<=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local tc=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.NegateEffect(ev)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end