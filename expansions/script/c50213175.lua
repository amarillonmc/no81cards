--Kamipro 阿斯克勒庇俄斯
function c50213175.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c50213175.xcheck,4,2,c50213175.ovfilter,aux.Stringid(50213175,0),2,c50213175.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_ALL-ATTRIBUTE_DIVINE-ATTRIBUTE_EARTH)
	e1:SetCondition(c50213175.attcon)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c50213175.rdcon)
	e2:SetOperation(c50213175.rdop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,50213175)
	e3:SetCost(c50213175.spcost)
	e3:SetTarget(c50213175.sptg)
	e3:SetOperation(c50213175.spop)
	c:RegisterEffect(e3)
end
function c50213175.xcheck(c)
	return c:IsSetCard(0xcbf)
end
function c50213175.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:GetCounter(0xcbf)>=5
end
function c50213175.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50213175)==0 end
	Duel.RegisterFlagEffect(tp,50213175,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c50213175.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50213175.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c50213175.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c50213175.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50213175.spfilter(c,e,tp)
	return c:IsSetCard(0xcbf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50213175.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50213175.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c50213175.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50213175.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50213175.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end