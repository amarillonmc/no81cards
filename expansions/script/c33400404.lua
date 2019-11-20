--鸢一折纸 渴望
function c33400404.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400404,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33400404)
	e1:SetCost(c33400404.spcost)
	e1:SetTarget(c33400404.sptg)
	e1:SetOperation(c33400404.spop)
	c:RegisterEffect(e1)
	  --spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33400404,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,33400404+10000)
	e5:SetTarget(c33400404.sumtg)
	e5:SetOperation(c33400404.sumop)
	c:RegisterEffect(e5)
end
function c33400404.refilter(c)
	return (c:IsSetCard(0x5342) or c:IsSetCard(0x5343) or c:IsSetCard(0x6343)) and c:IsReleasable()
end
function c33400404.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_ONFIELD
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c33400404.refilter,tp,loc,0,1,e:GetHandler(),e,tp)  end
	local g=Duel.SelectMatchingCard(tp,c33400404.refilter,tp,loc,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33400404.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33400404.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c33400404.spfilter(c,e,tp)
	return c:IsSetCard(0x5342) or c:IsSetCard(0xc342) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400404.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400404.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33400404.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33400404.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33400404.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end