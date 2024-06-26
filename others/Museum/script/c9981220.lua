--艾姆斯·瓦尔基里-冲刺猎豹
function c9981220.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981220,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9981220)
	e1:SetCondition(c9981220.spcon)
	e1:SetTarget(c9981220.sptg)
	e1:SetOperation(c9981220.spop)
	c:RegisterEffect(e1)
	 --Special Summon (deck)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981220,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,99812200)
	e2:SetCondition(c9981220.spcon2)
	e2:SetTarget(c9981220.sptg2)
	e2:SetOperation(c9981220.spop2)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981220.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981220.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981220,0))
end
function c9981220.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0 and c:IsSetCard(0x3bc9,0x5bc9) and not c:IsCode(9981220)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c9981220.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981220.cfilter,1,nil,tp)
end
function c9981220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9981220.damfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:GetAttack()>0 and c9981220.cfilter(c,tp)
end
function c9981220.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c9981220.damfilter,nil,tp)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9981220,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg=g:Select(tp,1,1,nil)
		Duel.Damage(1-tp,math.ceil(sg:GetFirst():GetAttack()/2),REASON_EFFECT)
	end
end
function c9981220.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9981220.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3bc9,0x5bc9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9981220.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981220.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981220.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981220.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end