--Legend-Arms 布利维路德龙兽
function c16310050.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c16310050.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c16310050.fsplimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c16310050.atktg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16310050)
	e2:SetTarget(c16310050.eqtg)
	e2:SetOperation(c16310050.eqop)
	c:RegisterEffect(e2)
	--lock
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c16310050.lzcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_SZONE)
	e33:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e33:SetTarget(c16310050.eftg)
	e33:SetLabelObject(e3)
	c:RegisterEffect(e33)
end
function c16310050.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3dc6) and c:IsAttack(0) and c:IsType(0x1)
		and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c16310050.fsplimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c16310050.atktg(e,c)
	return c:IsSetCard(0x3dc6)
end
function c16310050.eqfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsFaceupEx()
end
function c16310050.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c16310050.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c16310050.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c16310050.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c16310050.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c16310050.eqlimit)
		tc:RegisterEffect(e1)
		--immune
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetTarget(c16310050.atkfilter)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetValue(c16310050.efilter)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c16310050.atkfilter(e,c)
	return c:IsSetCard(0x3dc6) and c:GetEquipGroup():GetCount()>0
end
function c16310050.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c16310050.eqlimit(e,c)
	return e:GetOwner()==c
end
function c16310050.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(16310055) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c16310050.lzcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsCode(16310055)
		and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end