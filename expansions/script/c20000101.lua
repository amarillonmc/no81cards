--不灭的裁决
local cm,m,o=GetID()
fu_judg=fu_judg or {}
function fu_judg.E(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(m,0))
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetRange(LOCATION_GRAVE)
	e:SetCountLimit(1,c:GetOriginalCode())
	e:SetCondition(fu_judg.E_con)
	e:SetCost(aux.bfgcost)
	e:SetTarget(fu_judg.E_tg)
	e:SetOperation(fu_judg.E_op)
	c:RegisterEffect(e)
	return e0,e
end
function fu_judg.F(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(fu_judg.F_tg1)
	e1:SetValue(POS_FACEUP_ATTACK)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(fu_judg.F_tg2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	return e0,e1,e2
end
function fu_judg.E_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE)
end
function fu_judg.E_tgf(c,tp)
	return c:IsSetCard(0x3fd1) and (c:GetType()==0x20002 or c:IsType(TYPE_FIELD)) and c:GetActivateEffect():IsActivatable(tp)
end
function fu_judg.E_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc end
	if chk==0 then return Duel.IsExistingTarget(fu_judg.E_tgf,tp,LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,fu_judg.E_tgf,tp,LOCATION_GRAVE,0,1,1,nil,tp)
end
function fu_judg.E_op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and aux.NecroValleyFilter()(tc) and tc:GetActivateEffect():IsActivatable(tp) then
		Duel.MoveToField(tc,tp,tp,tc:IsType(TYPE_FIELD) and LOCATION_FZONE or LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local cost=te:GetCost()
		if cost then cost(te,tc:GetControler(),eg,ep,ev,re,r,rp,1) end
	end
end
function fu_judg.F_tg1(e,c)
	return c:GetType()==0x20002 or c:IsType(TYPE_FIELD)
end
function fu_judg.F_tg2(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
if not cm then return end
function cm.initial_effect(c)
	local e1={fu_judg.E(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg2)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
end
--e2
function cm.tg2(e,c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.val2(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end