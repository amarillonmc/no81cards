--虚无世界 完美之愿
function c6160506.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160506,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCountLimit(1,6160506) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c6160506.target)  
	e1:SetOperation(c6160506.activate)  
	c:RegisterEffect(e1) 
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,6260506)
	e2:SetCondition(c6160506.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c6160506.thtg)  
	e2:SetOperation(c6160506.thop)  
	c:RegisterEffect(e2) 
end
function c6160506.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x616) and  c:IsLevelAbove(8)
		and Duel.IsExistingMatchingCard(c6160506.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c6160506.filter2(c,e,tp,mc)
	return c:IsRankBelow(3) and c:IsSetCard(0x616) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c6160506.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c6160506.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c6160506.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c6160506.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6160506.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6160506.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
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
function c6160506.cfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER)
end  
function c6160506.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c6160506.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function c6160506.tgfilter(c)  
	return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end  
function c6160506.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6160506.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function c6160506.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c6160506.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end  