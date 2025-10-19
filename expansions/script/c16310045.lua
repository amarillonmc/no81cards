--Legend-Arms 杜兰达兽
function c16310045.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c16310045.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c16310045.fsplimit)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c16310045.actcon)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16310045)
	e2:SetTarget(c16310045.eqtg)
	e2:SetOperation(c16310045.eqop)
	c:RegisterEffect(e2)
	--lock
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16310045,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16310045.lzcon)
	e3:SetTarget(c16310045.lztg)
	e3:SetOperation(c16310045.lzop)
	c:RegisterEffect(e3)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_SZONE)
	e33:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e33:SetTarget(c16310045.eftg)
	e33:SetLabelObject(e3)
	c:RegisterEffect(e33)
end
function c16310045.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3dc6) and c:IsDefense(0) and c:IsType(0x1)
		and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c16310045.fsplimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c16310045.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dc6) and c:IsControler(tp)
end
function c16310045.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c16310045.cfilter(a,tp)) or (d and c16310045.cfilter(d,tp))
end
function c16310045.eqfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsFaceupEx()
end
function c16310045.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c16310045.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c16310045.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c16310045.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c16310045.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c16310045.eqlimit)
		tc:RegisterEffect(e1)
		--atk
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTarget(c16310045.atkfilter)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetValue(800)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--pierce
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_PIERCE)
		e3:SetTarget(c16310045.atkfilter)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c16310045.atkfilter(e,c)
	return c:IsSetCard(0x3dc6) and c:GetEquipGroup():GetCount()>0
end
function c16310045.eqlimit(e,c)
	return e:GetOwner()==c
end
function c16310045.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(16310055) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c16310045.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(16310055)
end
function c16310045.eqcfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup() and c:IsSetCard(0x3dc6)
end
function c16310045.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c16310045.eqcfilter,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return #g>0 end
end
function c16310045.lzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16310045.eqcfilter,tp,LOCATION_SZONE,0,nil)
	if #g<1 then return end
	local zone=0
	local tc=g:GetFirst()
	while tc do
		zone=zone|(tc:GetColumnZone(LOCATION_ONFIELD)&0xffff0000)
		tc=g:GetNext()
	end
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end