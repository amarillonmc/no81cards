--方舟骑士·枯柏 守林人
function c82567802.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567802,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c82567802.descon)
	e1:SetTarget(c82567802.target)
	e1:SetOperation(c82567802.operation)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82567802+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c82567802.spcon)
	e3:SetTarget(c82567802.sptg)
	e3:SetOperation(c82567802.spop)
	c:RegisterEffect(e3)
	
end
function c82567802.ovfilter(c)
	return c:IsCode(82567801) and c:GetCounter(0x5825)>=2 
end
function c82567802.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) 
end
function c82567802.desfilter(c,atk,e)
	return c:IsFaceup() and c:IsAttackBelow(atk) 
end
function c82567802.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568009.desfilter,tp,0,LOCATION_MZONE,1,nil,atk,e) end
	local g=Duel.GetMatchingGroup(c82567802.desfilter,tp,0,LOCATION_MZONE,nil,atk,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82567802.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82567802.desfilter,tp,0,LOCATION_MZONE,nil,atk,e)
	Duel.Destroy(g,REASON_EFFECT)
 
end

function c82567802.filter(c,e,tp)
	return c:IsSetCard(0x825)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_TUNER)
end
function c82567802.costfilter(c,e,tp)
	return c:IsLocation(LOCATION_SZONE) 
end
function c82567802.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c82567802.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and 
		   Duel.IsExistingMatchingCard(c82567802.costfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
end
function c82567802.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c82567802.filter(c,e,tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82567802.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and 
		   Duel.IsExistingMatchingCard(c82567802.costfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	 local tc=Duel.SelectTarget(tp,c82567802.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,LOCATION_SZONE)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c82567802.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  and tc:IsDestructable(e) then
	Duel.Destroy(tc,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567802.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tg=g:GetFirst() 
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,tp,LOCATION_GRAVE)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	
end