-- 午夜战栗·惊魂名伶
function c10200053.initial_effect(c)
	-- 效果1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200053,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10200053)
	e1:SetCondition(c10200053.spcon1)
	e1:SetCost(c10200053.spcost)
	e1:SetTarget(c10200053.sptg)
	e1:SetOperation(c10200053.spop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1b:SetCondition(c10200053.spcon2)
	c:RegisterEffect(e1b)
	-- 效果2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200053,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,{10200053,1})
	e2:SetTarget(c10200053.mvtg)
	e2:SetOperation(c10200053.mvop)
	c:RegisterEffect(e2)
end
-- 1
function c10200053.chkfilter(c)
	return c:IsFaceup() and c:IsCode(10200046)
end
function c10200053.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
		and Duel.IsExistingMatchingCard(c10200053.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10200053.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
		and Duel.IsExistingMatchingCard(c10200053.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10200053.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
end
function c10200053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10200053.columnfilter(c,seq)
	local cseq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) and cseq>4 then
		if cseq==5 then cseq=1
		elseif cseq==6 then cseq=3 end
	end
	return cseq==seq and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()
end
function c10200053.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(10200053,2)) then return end
	local seq=c:GetSequence()
	if seq>4 then
		if seq==5 then seq=1
		elseif seq==6 then seq=3 end
	end
	local g=Duel.GetMatchingGroup(c10200053.columnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
-- 2
function c10200053.mvfilter(c,tp)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) then return false end
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c10200053.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10200053.mvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10200053.mvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10200053.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c10200053.deffilter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c10200053.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(zone,2)
	Duel.MoveSequence(tc,nseq)
	if Duel.IsExistingMatchingCard(c10200053.deffilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(10200053,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,c10200053.deffilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		end
	end
end
