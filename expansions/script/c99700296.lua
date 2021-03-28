--龙界原始龙种后裔 圣晶龙
function c99700296.initial_effect(c)
	c:SetSPSummonOnce(99700296)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c99700296.mfilter,c99700296.xyzcheck,4,4,c99700296.ovfilter,aux.Stringid(99700296,0))
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c99700296.splimit1)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700296,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,99700296)
	e2:SetCondition(c99700296.effcon1)
	e2:SetTarget(c99700296.thtg)
	e2:SetOperation(c99700296.thop)
	c:RegisterEffect(e2)
	--spsummon()
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetCondition(c99700296.effcon1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(c99700296.effcon1)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfd00 or Card.IsSetCard,0xfd04))
	e5:SetValue(500)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	e6:SetValue(-500)
	c:RegisterEffect(e6)
	--act qp/trap in hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCondition(c99700296.handcon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(99700296)
	c:RegisterEffect(e9)
	--activate cost
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_ACTIVATE_COST)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,0)
	e10:SetCost(c99700296.costchk)
	e10:SetTarget(c99700296.costtg)
	e10:SetOperation(c99700296.costop)
	c:RegisterEffect(e10)
	--material
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(99700296,2))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,94455297)
	e11:SetTarget(c99700296.target)
	e11:SetOperation(c99700296.operation)
	c:RegisterEffect(e11)
	--battle indestructable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e12:SetValue(1)
	e12:SetCondition(c99700296.effcon)
	e12:SetLabel(1)
	c:RegisterEffect(e12)
	--cannot release
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_UNRELEASABLE_SUM)
	e13:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e13:SetValue(1)
	e13:SetCondition(c99700296.effcon)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e13:SetLabel(2)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e14)
	--immune
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_IMMUNE_EFFECT)
	e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(c99700296.effcon)
	e15:SetValue(c99700296.efilter)
	e15:SetLabel(3)
	c:RegisterEffect(e15)
	--atk
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(99700296,4))
	e16:SetCategory(CATEGORY_ATKCHANGE)
	e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e16:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCondition(c99700296.atkcon2)
	e16:SetCost(c99700296.atkcost2)
	e16:SetOperation(c99700296.atkop2)
	e16:SetLabel(4)
	c:RegisterEffect(e16)
	--disable spsummon
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCode(EFFECT_CANNOT_SUMMON)
	e17:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e17:SetTargetRange(0,1)
	e17:SetCondition(c99700296.effcon)
	e17:SetValue(c99700296.splimit)
	e17:SetLabel(9)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e18)
	local e19=e17:Clone()
	e19:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e19)
	--disable activate
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCode(EFFECT_CANNOT_ACTIVATE)
	e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e20:SetTargetRange(0,1)
	e20:SetCondition(c99700296.effcon)
	e20:SetValue(c99700296.aclimit)
	e20:SetLabel(6)
	c:RegisterEffect(e20)
	--remove material
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(99700296,3))
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetCode(EVENT_PHASE+PHASE_END)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e21:SetCondition(c99700296.rmcon)
	e21:SetOperation(c99700296.rmop1)
	e21:SetLabel(9)
	c:RegisterEffect(e21)
	--remove material
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(99700296,3))
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e22:SetCode(EVENT_PHASE+PHASE_END)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e22:SetCondition(c99700296.rmcon)
	e22:SetOperation(c99700296.rmop)
	e22:SetLabel(6)
	c:RegisterEffect(e22)
end
function c99700296.splimit1(e,se,sp,st)
	return (se:GetHandler():IsSetCard(0xfd00) or se:GetHandler():IsSetCard(0xfd01) or se:GetHandler():IsSetCard(0xfd02) or se:GetHandler():IsSetCard(0xfd03) or se:GetHandler():IsSetCard(0xfd04))
end
function c99700296.mfilter(c,xyzc)
	return c:IsLevel(12) and c:IsType(TYPE_MONSTER)
end
function c99700296.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04)) and c:IsRankAbove(8) and c:IsType(TYPE_XYZ)
end
function c99700296.effcon1(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c99700296.thfilter(c,tp)
	return (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c99700296.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99700296.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99700296.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c99700296.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c99700296.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c99700296.handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and e:GetHandler():GetOverlayCount()~=0
end
function c99700296.costtg(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		and tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(99700296)>0
		and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(99700296) and tc:IsType(TYPE_QUICKPLAY+TYPE_SPELL))
			or (tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(99700296) and tc:IsType(TYPE_COUNTER+TYPE_TRAP)))
end
function c99700296.costchk(e,te_or_c,tp)
	return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c99700296.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,99700296)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c99700296.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsCanOverlay()
end
function c99700296.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99700296.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c99700296.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c99700296.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99700296.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c99700296.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c99700296.efilter(e,te)
	return not (te:GetOwner():IsSetCard(0xfd00) or te:GetOwner():IsSetCard(0xfd04))
end
function c99700296.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and bc:GetAttack()~=bc:GetBaseAttack() and e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c99700296.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(99700296)==0 end
	c:RegisterFlagEffect(99700296,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c99700296.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetAttack()*2
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_DISABLE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c99700296.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not (re:GetHandler():IsSetCard(0xfd00) or re:GetHandler():IsSetCard(0xfd04))
end
function c99700296.splimit(e,re,tp)
	return c:IsType(TYPE_MONSTER) and not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04))
end
function c99700296.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c99700296.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>=6 then
		c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	end
end
function c99700296.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>=9 then
		c:RemoveOverlayCard(tp,4,4,REASON_EFFECT)
	end
end