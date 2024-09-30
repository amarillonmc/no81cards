--拉特金骑士·玄刚
function c22348431.initial_effect(c)
	aux.EnableUnionAttribute(c,aux.TRUE)
	--equip
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(22348431,0))
	--e1:SetCategory(CATEGORY_EQUIP)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetTarget(c22348431.eqtg)
	--e1:SetOperation(c22348431.eqop)
	--c:RegisterEffect(e1)
	--unequip
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(22348431,1))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetTarget(c22348431.sptg)
	--e2:SetOperation(c22348431.spop)
	--c:RegisterEffect(e2)
	--equip-hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348431,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,22348431)
	e3:SetCost(c22348431.cost)
	e3:SetTarget(c22348431.heqtg)
	e3:SetOperation(c22348431.heqop)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetCondition(c22348431.eqcon)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(c22348431.eqcon)
	e5:SetValue(-600)
	c:RegisterEffect(e5)
end
c22348431.has_text_type=TYPE_UNION
function Auxiliary.UnionEquipLimit(filter)
	return  function(e,c)
				return filter(c) or e:GetHandler():GetEquipTarget()==c
			end
end
function Auxiliary.UnionEquipFilter(filter)
	return  function(c,tp)
				local ct1,ct2=c:GetUnionCount()
				return c:IsFaceup() and ct2==0 and filter(c)
			end
end
function Auxiliary.UnionEquipTarget(equip_filter)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local c=e:GetHandler()
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and equip_filter(chkc,tp) end
				if chk==0 then return c:GetFlagEffect(FLAG_ID_UNION)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
					and Duel.IsExistingTarget(equip_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g=Duel.SelectTarget(tp,equip_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,tp)
				Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
				c:RegisterFlagEffect(FLAG_ID_UNION,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
			end
end
function c22348431.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and ct2==0
end
function c22348431.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22348431.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22348431)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348431.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22348431.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(22348431,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22348431.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c22348431.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c22348431.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22348431)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(22348431,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22348431.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c22348431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22348431.eqfilter(c,tp)
	return Duel.IsExistingMatchingCard(c22348431.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c,tp) and c:IsFaceup()
end
function c22348431.cfilter(c,ec,tp)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec) and not c:IsCode(22348431)
end
function c22348431.heqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22348431.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348431.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22348431.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c22348431.heqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c22348431.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,tp):GetFirst()
	if ec and Duel.Equip(tp,ec,tc) then
		aux.SetUnionState(ec)
	end
end
function c22348431.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22348431.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and not ec:IsSetCard(0x970b)
end
