--大怪兽大对峙
function c10150057.initial_effect(c)
	c:EnableCounterPermit(0x37)
	c:SetCounterLimit(0x37,4)   
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c10150057.counter)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(10150057,0))
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c10150057.spcost)
	e3:SetTarget(c10150057.sptg)
	e3:SetOperation(c10150057.spop)
	c:RegisterEffect(e3)
end
function c10150057.spfilter(c,e,tp)
	local re=c:GetReasonEffect()
	if not re then return false end
	local rc=re:GetHandler()
	local rc=re:GetHandler()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsReason(REASON_RELEASE) and rc:IsSetCard(0xd3) and re:GetCode()==EFFECT_SPSUMMON_PROC 
end
function c10150057.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x37,2,REASON_COST)
end
function c10150057.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c10150057.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10150057.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10150057.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10150057.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10150057.cfilter(c,tp)
	return c:IsSetCard(0xd3) and c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsControler(1-tp)
end
function c10150057.counter(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c10150057.cfilter,nil,tp)>0 then
		e:GetHandler():AddCounter(0x37,1,true)
	end
end
