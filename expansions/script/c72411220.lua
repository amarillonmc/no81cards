--神花姬-纱月
function c72411220.initial_effect(c)
				--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411220,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCountLimit(1,72411220)
	e1:SetCost(c72411220.spcost)
	e1:SetTarget(c72411220.sptg)
	e1:SetOperation(c72411220.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c72411220.sendop)
	c:RegisterEffect(e2)
end
function c72411220.cfilter(c,ft)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0xe728) and (ft>0 or c:GetSequence()<5)
end
function c72411220.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c72411220.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c72411220.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c72411220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72411220.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end
function c72411220.sendfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp and ((not c:IsType(TYPE_LINK) and (c:GetAttack()<=e:GetHandler():GetAttack() or c:GetDefense()<=e:GetHandler():GetAttack())) or (c:IsType(TYPE_LINK) and c:GetAttack()<=e:GetHandler():GetAttack()))
end
function c72411220.sendop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	local g=c:GetColumnGroup():Filter(c72411220.sendfilter,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
