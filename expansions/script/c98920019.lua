--正义盟军 决战头脑
function c98920019.initial_effect(c)
		--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920019,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c98920019.sptg)
	e2:SetOperation(c98920019.spop)
	c:RegisterEffect(e2)
	e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	
--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c98920019.exacon)
	e4:SetOperation(c98920019.exaop)
	c:RegisterEffect(e4)
end
function c98920019.spfilter(c,e,tp)
	return c:IsSetCard(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920019.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920019.spop(e,tp,eg,ep,ev,re,r,rp)	  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,0,LOCATION_ONFIELD,nil,ATTRIBUTE_LIGHT)
	local g=Duel.GetMatchingGroup(c98920019.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ft<=0 or ct<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ct))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c98920019.exacon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsLevelAbove(10)
end	
function c98920019.exaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920019,2))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c98920019.efilter)
	rc:RegisterEffect(e5,true)
end
function c98920019.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end