--缝合僵尸曲线球
function c33203017.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33203017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33203017)
	e1:SetTarget(c33203017.sptg)
	e1:SetOperation(c33203017.spop)
	c:RegisterEffect(e1)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33203017,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33213017)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33203017.mattg)
	e2:SetOperation(c33203017.matop)
	c:RegisterEffect(e2)
end
function c33203017.spfilter(c,e,tp)
	return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33203017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33203017.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33203017.cfilter(c)
	return c:IsSetCard(0x332b) and c:IsFacedown() and c:IsCanChangePosition()
end
function c33203017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33203017.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c33203017.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(33203017,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,c33203017.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK)
	end
end
function c33203017.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x332b)
end
function c33203017.mfilter(c)
	return c:IsSetCard(0x332b) and c:IsCanOverlay()
end
function c33203017.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsPosition(LOCATION_MZONE) and c33203017.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33203017.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c33203017.mfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33203017.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33203017.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33203017.mfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end

