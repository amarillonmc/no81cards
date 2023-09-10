--食恶餐具鬼
function c98920644.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920644,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920644)
	e1:SetCost(c98920644.spcost)
	e1:SetTarget(c98920644.sptg)
	e1:SetOperation(c98920644.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920644,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98930644)
	e2:SetCondition(c98920644.spcon2)
	e2:SetTarget(c98920644.sptg2)
	e2:SetOperation(c98920644.spop2)
	c:RegisterEffect(e2)
end
function c98920644.spfilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0x8b)
end
function c98920644.fcheck(c,g)
	return g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule())
end
function c98920644.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and not g:IsExists(c98920644.fcheck,1,nil,g)
end
function c98920644.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920644.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920644.spfilter0,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c98920644.fselect,3,3) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920644.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98920644.spfilter0),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c98920644.fselect,false,3,3)
	if sg and sg:GetCount()==3 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c98920644.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98920644.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c98920644.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c98920644.spfilter(c,e,tp,mc)
	return c:IsCode(55727845) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920644.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c98920644.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920644.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920644.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(c)

			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_MUST_ATTACK)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(0,LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetDescription(aux.Stringid(98920644,0))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
			e3:SetValue(c98920644.atklimit)
			sc:RegisterEffect(e3,true)
			if not sc:IsType(TYPE_EFFECT) then
			   local e2=Effect.CreateEffect(c)
			   e2:SetType(EFFECT_TYPE_SINGLE)
			   e2:SetCode(EFFECT_ADD_TYPE)
			   e2:SetValue(TYPE_EFFECT)
			   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			   sc:RegisterEffect(e2,true)
			end
			sc:CompleteProcedure()
		end
	end
end
function c98920644.atklimit(e,c)
	return c==e:GetHandler()
end