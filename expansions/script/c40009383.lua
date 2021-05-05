--真武神降临
function c40009383.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009383+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c40009383.target)
	e1:SetOperation(c40009383.activate)
	c:RegisterEffect(e1)
end
function c40009383.spfilter1(c)
	return c:IsSetCard(0x88) and c:IsCanOverlay()
end
function c40009383.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsCanOverlay()
end
function c40009383.spfilter(c,e,tp)
	return c:IsSetCard(0x88) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c40009383.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40009383.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c40009383.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c40009383.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,c40009383.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,c40009383.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009383.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009383.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(sc,mg)
	end
end

