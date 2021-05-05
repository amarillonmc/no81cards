--究极之洞
function c40008616.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c40008616.lcheck)
	c:EnableReviveLimit() 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008616,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40008616.target)
	e1:SetOperation(c40008616.activate)
	c:RegisterEffect(e1)   
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008616,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c40008616.cost)
	e2:SetCountLimit(1,40008616)
	e2:SetTarget(c40008616.target)
	e2:SetOperation(c40008616.operation)
	c:RegisterEffect(e2)  
end
function c40008616.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c40008616.spfilter1(c,e,tp)
	return c:IsCode(40008613) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.IsExistingMatchingCard(c40008616.spfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp)
end
function c40008616.spfilter2(c,e,tp)
	return c:IsCode(40008613) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c40008616.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c40008616.spfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c40008616.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c40008616.spfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c40008616.spfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c40008616.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,40008613) or g:IsExists(Card.IsLinkCode,1,nil,40008614)
end
function c40008616.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c40008616.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c40008616.filter2(c,e,tp,mc,code)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xf18) and not c:IsCode(code) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c40008616.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c40008616.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40008616.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40008616.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40008616.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40008616.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end