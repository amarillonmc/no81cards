--我我我我书记
function c75038013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()   
	--to hand
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75038013)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetTarget(c75038013.thtg)
	e1:SetOperation(c75038013.thop)
	c:RegisterEffect(e1)
	--xyz 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetCondition(c75038013.xyzcon) 
	e2:SetCost(c75038013.xyzcost)
	e2:SetTarget(c75038013.xyztg)
	e2:SetOperation(c75038013.xyzop)
	c:RegisterEffect(e2)
end
function c75038013.thfilter(c)
	return c:IsSetCard(0x54) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c75038013.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c75038013.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.dncheck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c75038013.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75038013.thfilter,tp,LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(aux.dncheck,2,2) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg) 
	end 
end
function c75038013.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():IsSetCard(0x207f)  
end 
function c75038013.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75038013.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c75038013.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c75038013.eqfilter(c,tp)
	return c:IsSetCard(0x107e) and c:IsType(TYPE_MONSTER) and c.zw_equip_monster and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
end
function c75038013.filter2(c,e,tp,mc,rk)
	return c:IsRankBelow(6) and c:IsSetCard(0x7f) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and Duel.IsExistingMatchingCard(c75038013.eqfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,tp)
end
function c75038013.dtfilter(c)
	return c:IsSetCard(0x107e,0x207e)
end
function c75038013.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75038013.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c75038013.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c75038013.dtfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75038013.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75038013.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75038013.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c75038013.eqfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if not tc then return end
		tc.zw_equip_monster(tc,tp,c)
	end
end

