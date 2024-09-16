--123123
function c16400216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16400216)
	e1:SetTarget(c16400216.target)
	e1:SetOperation(c16400216.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16400216,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16400216)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16400216.mattg)
	e2:SetOperation(c16400216.matop)
	c:RegisterEffect(e2)
end
function c16400216.filter(c,e,tp)
	return c:IsSetCard(0xce3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16400216.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16400216.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16400216.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16400216.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c16400216.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xce4)
end
function c16400216.matfilter(c)
	return c:IsSetCard(0xce3) and c:IsCanOverlay()
end
function c16400216.ccfilter(c)
	return bit.band(c:GetType(),0x7)
end
function c16400216.fselect(g)
	return g:GetClassCount(c16400216.ccfilter)==g:GetCount()
end
function c16400216.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c16400216.matfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16400216.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16400216.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and g:CheckSubGroup(c16400216.fselect,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16400216.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16400216.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16400216.matfilter),tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:SelectSubGroup(tp,c16400216.fselect,false,3,3)
		if sg and sg:GetCount()==3 then
			Duel.Overlay(tc,sg)
		end
	end	
end
