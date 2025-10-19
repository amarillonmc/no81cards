--Legend-Arms 提亚路德兽
function c16310030.initial_effect(c)
	c16310030.EnableUnionAttribute(c,c16310030.unfilter)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16310030)
	e2:SetCost(c16310030.recost)
	e2:SetTarget(c16310030.retg)
	e2:SetOperation(c16310030.reop)
	c:RegisterEffect(e2)
	--damage conversion
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REVERSE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c16310030.rev)
	c:RegisterEffect(e3)
end
function c16310030.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c16310030.tgfilter(c,e,tp)
	local exct=aux.IsUnionState(e) and 1 or 0
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
		and Duel.IsExistingMatchingCard(c16310030.cfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,c,tp,exct)
end
function c16310030.cfilter(c,ec,tp,exclude_modern_count)
	return c:IsFaceupEx() and c:IsType(TYPE_UNION)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec,exclude_modern_count)
end
function c16310030.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,16310030,0,TYPE_EFFECT+TYPE_MONSTER,0,2300,5,RACE_DRAGON,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c16310030.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetTargetCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c16310030.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c16310030.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c16310030.cfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		local ec=sg:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
			if e:GetHandler():IsRelateToChain() and e:GetHandler():IsLocation(LOCATION_HAND) then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c16310030.rev(e,re,r,rp,rc)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return bit.band(r,REASON_BATTLE)~=0
		and ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget())
end
function c16310030.unfilter(c)
	return c:IsSetCard(0x3dc6)
end
function c16310030.EnableUnionAttribute(c,filter)
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
	e3:SetCondition(c16310030.mpcon)
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
	e4:SetCondition(c16310030.mpcon)
	e4:SetTarget(Auxiliary.UnionUnequipTarget)
	e4:SetOperation(Auxiliary.UnionUnequipOperation)
	c:RegisterEffect(e4)
end
function c16310030.mpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end