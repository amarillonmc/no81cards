local m=53799227
local cm=_G["c"..m]
cm.name="M机C械Y"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(c:GetControler(),c,tp)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=g:RandomSelect(tp,1)
	local a=1
	if sg:GetFirst():GetControler()==tp then a=0 end
	e:SetTargetRange(POS_FACEUP_ATTACK,a)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local b1=c:IsRelateToEffect(e) and c:IsAbleToHand()
	local b2=rc:IsRelateToEffect(re) and rc:IsAbleToHand()
	local s
	if b1 and b2 then s=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3)) elseif b1 then s=Duel.SelectOption(tp,aux.Stringid(m,2)) else s=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
	if s==0 then Duel.SendtoHand(c,nil,REASON_EFFECT) else Duel.SendtoHand(rc,nil,REASON_EFFECT) end
end
