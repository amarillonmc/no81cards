--D.A.L升阶魔法-灵结晶吸收
function c33401201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33401201,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33401201)
	e1:SetTarget(c33401201.target)
	e1:SetOperation(c33401201.activate)
	c:RegisterEffect(e1)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33411201)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33401201.sptg)
	e2:SetOperation(c33401201.spop)
	c:RegisterEffect(e2)
end
function c33401201.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup()  and c:IsType(TYPE_XYZ)   
		and  (Duel.IsExistingMatchingCard(c33401201.filter22,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2) or
		Duel.IsExistingMatchingCard(c33401201.filter22,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+4))  
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c33401201.filter22(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x341) and mc:IsCanBeXyzMaterial(c)
	 and c:GetOriginalAttribute()==mc:GetOriginalAttribute() and c:GetOriginalRace()==mc:GetOriginalRace()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
 and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c33401201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33401201.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33401201.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33401201.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33401201.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if  not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(c33401201.filter22,tp,LOCATION_EXTRA,0,nil,e,tp,tc,tc:GetRank()+2)
	local g2=Duel.GetMatchingGroup(c33401201.filter22,tp,LOCATION_EXTRA,0,nil,e,tp,tc,tc:GetRank()+4)
	g2:Merge(g1)
	local g3=g2:Select(tp,1,1,nil)
	local sc=g3:GetFirst()
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

function c33401201.spfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33401201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33401201.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c33401201.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33401201.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
