local m=25000150
local cm=_G["c"..m]
cm.name="银眼的伊扎克"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.spfilter(c,ft,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),c:GetControler())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),c:GetControler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local damn=e:GetHandler():GetAttack()
	Duel.SetTargetParam(e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,damn)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,damn)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Damage(tp,d,REASON_EFFECT)
	Duel.Damage(1-tp,d,REASON_EFFECT)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,3)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(Duel.GetFieldGroup(tp,LOCATION_HAND,0),REASON_EFFECT+REASON_DISCARD)
end