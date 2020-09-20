--刻刻帝女神 三之弹·Gime
function c9980182.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9980182.spcon)
	c:RegisterEffect(e1)
	--Rank Up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980182,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9980182.target)
	e3:SetOperation(c9980182.operation)
	c:RegisterEffect(e3)
end
function c9980182.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc8)
end
function c9980182.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980182.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9980182.tgfilter(c,e,tp)
	if not (c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x6bc8)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)) then return false end
	return Duel.IsExistingMatchingCard(c9980182.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank()+2,c)
end
function c9980182.spfilter(c,e,tp,rank,mc)
	return (c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsRank(rank) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9980182.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9980182.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9980182.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9980182.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980182.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsControler(tp)
		or Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980182.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank()+2,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()>0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9980182.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980182,0))
end
function c9980182.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_DARK))
end
