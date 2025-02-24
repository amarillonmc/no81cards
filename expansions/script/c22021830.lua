--人理之基 阿比盖尔
function c22021830.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--CANNOT_SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c22021830.descon1)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--CANNOT_SPECIAL_SUMMON
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c22021830.descon2)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c22021830.descon3)
	e4:SetValue(c22021830.aclimit)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22021830,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetTarget(c22021830.mttg)
	e5:SetOperation(c22021830.mtop)
	c:RegisterEffect(e5)
	--material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22021830,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCost(c22021830.cost)
	e6:SetTarget(c22021830.target)
	e6:SetOperation(c22021830.operation)
	c:RegisterEffect(e6)
end
function c22021830.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c22021830.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_PENDULUM)
end
function c22021830.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_QUICKPLAY)
end
function c22021830.imfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c22021830.descon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c22021830.imfilter,1,nil) 
end
function c22021830.mtfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c22021830.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c22021830.mtfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c22021830.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c22021830.mtfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c22021830.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c22021830.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return tc:FilterCount(Card.IsAbleToChangeControler,nil)==3 end
end
function c22021830.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not tc then return end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<=3 then
		dr=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	end
	Duel.Overlay(e:GetHandler(),Duel.GetDecktopGroup(1-tp,3))
end