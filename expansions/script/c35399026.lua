--离子炮龙-火型
function c35399026.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,35399026)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c35399026.con1)
	e1:SetTarget(c35399026.tg1)
	e1:SetOperation(c35399026.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399026,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c35399026.con2)
	e2:SetTarget(c35399026.tg2)
	e2:SetOperation(c35399026.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c35399026.con3)
	e3:SetOperation(c35399026.op3)
	c:RegisterEffect(e3)
--
end
--
function c35399026.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
end
function c35399026.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35399026.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lg=sg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,lg:GetFirst(),c,mg)
	end
end
--
function c35399026.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=2
end
function c35399026.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35399026.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
--
function c35399026.con3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c35399026.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetDescription(aux.Stringid(35399026,2))
	e3_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e3_1:SetValue(c35399026.efilter3_1)
	e3_1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e3_1,true)
end
function c35399026.efilter3_1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_XYZ+TYPE_LINK)
end