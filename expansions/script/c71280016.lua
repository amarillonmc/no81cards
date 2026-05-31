--阴影杀手
function c71280016.initial_effect(c)
	aux.AddCodeList(c,2061963)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,2)
	--atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c71280016.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--special summon xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71280016,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,71280016)
	e3:SetCost(c71280016.spcost)
	e3:SetTarget(c71280016.sptg)
	e3:SetOperation(c71280016.spop)
	c:RegisterEffect(e3)
end
function c71280016.afilter(c)
	return c:IsSetCard(0x87) and c:IsType(TYPE_MONSTER)
end
function c71280016.val(e,c)
	return Duel.GetMatchingGroupCount(c71280016.afilter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
function c71280016.setfilter(c)
	return aux.IsCodeListed(c,2061963) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c71280016.spfilter(c,e,tp,mc)
	return c:IsCode(2061963)
		and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c71280016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c71280016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280016.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c71280016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local dc=Duel.SelectMatchingCard(tp,c71280016.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if dc and Duel.SSet(tp,dc)~=0 then
		if dc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
		end
		if dc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
		end
		if aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71280016.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c) 
			and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) 
			and Duel.SelectYesNo(tp,aux.Stringid(71280016,0))then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280016.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,c)
			local tc=g:GetFirst()
			if tc then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(tc,mg)
				end
				tc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(tc,Group.FromCards(c))
				Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end