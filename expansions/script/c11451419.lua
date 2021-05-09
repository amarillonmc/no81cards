--nezha,invader of dragon palace
local m=11451419
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetCondition(cm.rule)
	c:RegisterEffect(e2)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	--must attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e5)
	--cannotchange
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e6)
	--return
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(cm.target2)
	e7:SetOperation(cm.operation2)
	c:RegisterEffect(e7)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER)
end
function cm.rule(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and (Duel.IsExistingMatchingCard(cm.sprfilter,0,LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(cm.sprfilter,1,LOCATION_MZONE,0,1,nil))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(cm.sprfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x6978)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then Duel.GetControl(e:GetHandler(),1-tp) end
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetAttackTarget()~=nil and bc:IsSetCard(0x6978) end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end