--拉特金骑士·白枫
function c22348430.initial_effect(c)
	aux.EnableUnionAttribute(c,aux.TRUE)
	--equip
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(22348430,0))
	--e1:SetCategory(CATEGORY_EQUIP)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetTarget(c22348430.eqtg)
   -- e1:SetOperation(c22348430.eqop)
	--c:RegisterEffect(e1)
	--unequip
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(22348430,1))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetTarget(c22348430.sptg)
	--e2:SetOperation(c22348430.spop)
	--c:RegisterEffect(e2)
	--equip-hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348430,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(c22348430.heqtg)
	e3:SetOperation(c22348430.heqop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetCondition(c22348430.eqcon)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(c22348430.eqcon)
	e5:SetValue(-400)
	c:RegisterEffect(e5)
end
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
function c22348430.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and ct2==0
end
function c22348430.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22348430.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22348430)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348430.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22348430.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(22348430,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22348430.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c22348430.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c22348430.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22348430)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(22348430,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22348430.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c22348430.eqfilter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0x970b) and ct2==0
end
function c22348430.heqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22348430.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348430.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22348430.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c22348430.heqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if not c:CheckUniqueOnField(tp,LOCATION_SZONE) or c:IsForbidden() then return end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c22348430.eqlimit)
	c:RegisterEffect(e1)
end
function c22348430.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22348430.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and not ec:IsSetCard(0x970b)
end
