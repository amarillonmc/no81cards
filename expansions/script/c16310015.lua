--Legend-Arms 兹巴兽
function c16310015.initial_effect(c)
	c16310015.EnableUnionAttribute(c,c16310015.unfilter)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16310015)
	e2:SetTarget(c16310015.eqtg)
	e2:SetOperation(c16310015.eqop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e33)
end
function c16310015.eqfilter(c,tc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3dc6)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsFaceupEx()
end
function c16310015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c16310015.eqfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,c,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c16310015.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16310015.eqfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,c,tp)
		local sc=g:GetFirst()
		if sc and Duel.Equip(tp,sc,c) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(c16310015.eqlimit)
			sc:RegisterEffect(e1)
		end
	end
end
function c16310015.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c16310015.unfilter(c)
	return c:IsSetCard(0x3dc6)
end
function c16310015.EnableUnionAttribute(c,filter)
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
	e3:SetCondition(c16310015.mpcon)
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
	e4:SetCondition(c16310015.mpcon)
	e4:SetTarget(Auxiliary.UnionUnequipTarget)
	e4:SetOperation(Auxiliary.UnionUnequipOperation)
	c:RegisterEffect(e4)
end
function c16310015.mpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end