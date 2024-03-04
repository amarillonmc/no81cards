--神械的媾和
function c9910685.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910685)
	e1:SetCondition(c9910685.condition)
	e1:SetTarget(c9910685.target)
	e1:SetOperation(c9910685.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,9910685)
	e2:SetCondition(c9910685.spcon)
	e2:SetCost(c9910685.spcost)
	e2:SetTarget(c9910685.sptg)
	e2:SetOperation(c9910685.spop)
	c:RegisterEffect(e2)
	--activity check
	Duel.AddCustomActivityCounter(9910685,ACTIVITY_CHAIN,c9910685.chainfilter)
end
function c9910685.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local b1=rc:IsType(TYPE_FUSION) and re:IsActiveType(TYPE_MONSTER)
	local b2=rc:IsCode(9910871) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	return not b1 and not b2
end
function c9910685.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9910685,tp,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(9910685,1-tp,ACTIVITY_CHAIN)>0
end
function c9910685.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910685.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xfe,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTarget(c9910685.rmtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end
function c9910685.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c9910685.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c9910685.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9910685.spfilter(c,e,tp)
	local res=c:IsLocation(LOCATION_HAND)
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,res,false)
end
function c9910685.gselect(g)
	return aux.dncheck(g) and g:GetSum(Card.GetLevel)==12
end
function c9910685.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c9910685.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return ft>0 and g:CheckSubGroup(c9910685.gselect,1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c9910685.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910685.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910685.gselect,false,1,ft)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
