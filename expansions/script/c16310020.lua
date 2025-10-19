--Legend-Arms 路德兽
function c16310020.initial_effect(c)
	c16310020.EnableUnionAttribute(c,c16310020.unfilter)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16310020)
	e2:SetTarget(c16310020.sptg)
	e2:SetOperation(c16310020.spop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c16310020.splimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
end
function c16310020.spfilter(c,e,tp)
	return c:IsSetCard(0x3dc6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16310020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16310020.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c16310020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16310020.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.Equip(tp,c,tc,false) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c16310020.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c16310020.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c16310020.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x3dc6)
end
function c16310020.unfilter(c)
	return c:IsSetCard(0x3dc6)
end
function c16310020.EnableUnionAttribute(c,filter)
	local equip_limit=Auxiliary.UnionEquipLimit(filter)
	--destroy sub
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e1:SetValue(Auxiliary.UnionReplaceFilter)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNION_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(equip_limit)
	c:RegisterEffect(e2)
	--equip
	local equip_filter=Auxiliary.UnionEquipFilter(filter)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1068)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCondition(c16310020.mpcon)
	e3:SetTarget(Auxiliary.UnionEquipTarget(equip_filter))
	e3:SetOperation(Auxiliary.UnionEquipOperation(equip_filter))
	c:RegisterEffect(e3)
	--unequip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1152)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCondition(c16310020.mpcon)
	e4:SetTarget(Auxiliary.UnionUnequipTarget)
	e4:SetOperation(Auxiliary.UnionUnequipOperation)
	c:RegisterEffect(e4)
end
function c16310020.mpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end