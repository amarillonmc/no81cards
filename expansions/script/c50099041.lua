--虹猫蓝兔七侠传 七剑合璧
local m=50099041
local cm=_G["c"..m]
function cm.initial_effect(c)
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
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--remove 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
	local e51=e5:Clone()
	e51:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e51)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
end
function cm.sprfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost()
end
function cm.sprfilter1(c)
	return c:IsCode(50000000)
end
function cm.sprfilter2(c)
	return c:IsCode(50000002)
end
function cm.sprfilter3(c)
	return c:IsCode(50000007)
end
function cm.sprfilter4(c)
	return c:IsCode(50000009)
end
function cm.sprfilter5(c)
	return c:IsCode(50000012)
end
function cm.sprfilter6(c)
	return c:IsCode(50000014)
end
function cm.sprfilter7(c)
	return c:IsCode(50000004,50000006)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:IsExists(cm.sprfilter1,1,nil) and g:IsExists(cm.sprfilter2,1,nil) and g:IsExists(cm.sprfilter3,1,nil) 
		and g:IsExists(cm.sprfilter4,1,nil) and g:IsExists(cm.sprfilter5,1,nil) and g:IsExists(cm.sprfilter6,1,nil) and g:IsExists(cm.sprfilter7,1,nil)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,cm.sprfilter1,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,cm.sprfilter2,1,1,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=g:FilterSelect(tp,cm.sprfilter3,1,1,nil)
	g1:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=g:FilterSelect(tp,cm.sprfilter4,1,1,nil)
	g1:Merge(g4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g5=g:FilterSelect(tp,cm.sprfilter5,1,1,nil)
	g1:Merge(g5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g6=g:FilterSelect(tp,cm.sprfilter6,1,1,nil)
	g1:Merge(g6)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g7=g:FilterSelect(tp,cm.sprfilter7,1,1,nil)
	g1:Merge(g7)
	Duel.Remove(g7,POS_FACEUP,REASON_COST)
end
--remove 
function cm.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
--indes 
function cm.indes(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.efilter(e,re)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local rc=re:GetHandler()
	if (re:IsActivated() and rc:IsRelateToEffect(re) or not re:IsHasProperty(EFFECT_FLAG_FIELD_ONLY))
		and (rc:IsFaceup() or not rc:IsLocation(LOCATION_MZONE)) then
		return rc:IsAttribute(ATTRIBUTE_DARK)
	else
		return rc:GetOriginalAttribute()&ATTRIBUTE_DARK~=0
	end
end




