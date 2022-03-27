--种族栏很长的单调士
function c9310029.initial_effect(c)
	aux.EnableUnionAttribute(c,1)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9310029.splimit)
	c:RegisterEffect(e0)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c9310029.tnval)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9310029,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9310029)
	e2:SetTarget(c9310029.rmtg)
	e2:SetOperation(c9310029.rmop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9310029,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9310029.eqtg)
	e3:SetOperation(c9310029.eqop)
	c:RegisterEffect(e3)
	--unequip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9310029,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c9310029.sptg)
	e4:SetOperation(c9310029.spop)
	c:RegisterEffect(e4)
	--equip-P
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9310029,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,9311029)
	e5:SetCondition(c9310029.sccon)
	e5:SetTarget(c9310029.eqtg1)
	e5:SetOperation(c9310029.eqop1)
	c:RegisterEffect(e5)
end
function c9310029.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c9310029.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310029.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9310029.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c9310029.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and ct2==0 and c:IsType(TYPE_TUNER)
end
function c9310029.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9310029.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(9310029)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9310029.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9310029.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(9310029,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c9310029.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c9310029.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c9310029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9310029)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and e:GetHandler():GetEquipTarget()~=nil end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(9310029,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c9310029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c9310029.check(e)
	return (Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			or (not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>1)
end
function c9310029.sccon(e)
	return (e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) 
		   or e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1))
		   and c9310029.check(e)
end
function c9310029.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and aux.AtkEqualsDef(c) 
end
function c9310029.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9310029.eqfilter(chkc) end
	if chk==0 then return c9310029.check(e)
		and Duel.IsExistingTarget(c9310029.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9310029.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9310029.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_PZONE) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e)
		or not c9310029.check(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0x1100)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)-8
	if Duel.MoveSequence(c,seq)~=0 and Duel.Equip(tp,c,tc)~=0 then
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(c9310029.eqlimit1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c9310029.eqlimit1(e,c)
	return c==e:GetLabelObject()
end