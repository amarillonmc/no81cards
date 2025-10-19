--Legend-Arms 兹巴伊戈兽
function c16310025.initial_effect(c)
	c16310025.EnableUnionAttribute(c,c16310025.unfilter)
	--reequip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16310025)
	e2:SetCost(c16310025.recost)
	e2:SetTarget(c16310025.retg)
	e2:SetOperation(c16310025.reop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
c16310025.has_text_type=TYPE_UNION
function c16310025.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	e:SetLabelObject(tc)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c16310025.refilter(c,tc,tp,exclude_modern_count)
	return aux.CheckUnionEquip(c,tc,exclude_modern_count) and c:CheckUnionTarget(tc) and c:IsType(TYPE_UNION)
		and c:IsLevelBelow(5) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c16310025.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local exct=aux.IsUnionState(e) and 1 or 0
		return c:GetEquipTarget()
			and Duel.IsExistingMatchingCard(c16310025.refilter,tp,LOCATION_DECK,0,1,nil,c:GetEquipTarget(),tp,exct)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,16310025,0,TYPE_EFFECT+TYPE_MONSTER,2300,0,5,RACE_WARRIOR,ATTRIBUTE_DARK)
	end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	c:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c16310025.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c16310025.refilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp,nil)
		local ec=g:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
			if e:GetHandler():IsRelateToChain() and e:GetHandler():IsLocation(LOCATION_GRAVE) then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c16310025.unfilter(c)
	return c:IsSetCard(0x3dc6)
end
function c16310025.EnableUnionAttribute(c,filter)
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
	e3:SetCondition(c16310025.mpcon)
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
	e4:SetCondition(c16310025.mpcon)
	e4:SetTarget(Auxiliary.UnionUnequipTarget)
	e4:SetOperation(Auxiliary.UnionUnequipOperation)
	c:RegisterEffect(e4)
end
function c16310025.mpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end