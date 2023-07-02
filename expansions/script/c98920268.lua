--机甲守卫者
function c98920268.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920268,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920268)
	e1:SetCost(c98920268.spcost)
	e1:SetTarget(c98920268.sptg)
	e1:SetOperation(c98920268.spop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920268,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98930268)
	e2:SetTarget(c98920268.tstg)
	e2:SetOperation(c98920268.tsop)
	c:RegisterEffect(e2)
end
function c98920268.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c98920268.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920268.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c98920268.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c98920268.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920268.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920268.thfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsPosition(POS_ATTACK) and ft>0
		and Duel.IsExistingMatchingCard(c98920268.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetCode(),c:GetLevel())
end
function c98920268.spfilter2(c,e,tp,code,lv)
	return c:IsSetCard(0x36) and not c:IsCode(code) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920268.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920268.thfilter(chkc,e,tp,ft) end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c98920268.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c98920268.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98920268.tsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.SelectMatchingCard(tp,c98920268.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode(),tc:GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and sg:GetCount()>0 then
	   if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then
		  Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) 
	   end	   
	end
end