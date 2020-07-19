--元素吸收器Ⅱ
function c10700052.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700052,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700052,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c10700052.condition)
	e2:SetTarget(c10700052.target)
	e2:SetOperation(c10700052.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--disable dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetCondition(c10700052.darkcon)
	e4:SetTarget(c10700052.darktg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCondition(c10700052.devinecon)
	e5:SetTarget(c10700052.devinetg)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCondition(c10700052.devinecon)
	e6:SetTarget(c10700052.devinetg)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCondition(c10700052.earthcon)
	e7:SetTarget(c10700052.earthtg)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetCondition(c10700052.firecon)
	e8:SetTarget(c10700052.firetg)
	c:RegisterEffect(e8)
	local e9=e4:Clone()
	e9:SetCondition(c10700052.lightcon)
	e9:SetTarget(c10700052.lighttg)
	c:RegisterEffect(e9)
	local e10=e4:Clone()
	e10:SetCondition(c10700052.watercon)
	e10:SetTarget(c10700052.watertg)
	c:RegisterEffect(e10)
	local e11=e4:Clone()
	e11:SetCondition(c10700052.windcon)
	e11:SetTarget(c10700052.windtg)
	c:RegisterEffect(e11)
	--destroy
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(10700052,2))
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EVENT_TO_GRAVE)
	e12:SetCondition(c10700052.descon)
	e12:SetTarget(c10700052.destg)
	e12:SetOperation(c10700052.desop)
	c:RegisterEffect(e12)
end
function c10700052.windfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c10700052.windcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.windfilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.windtg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) 
end
function c10700052.waterfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10700052.watercon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.waterfilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.watertg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) 
end
function c10700052.lightfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c10700052.lightcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.lightfilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.lighttg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c10700052.firefilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c10700052.firecon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.firefilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.firetg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) 
end
function c10700052.earthfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10700052.earthcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.earthfilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.earthtg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH) 
end
function c10700052.devinefilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c10700052.devinecon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.devinefilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.devinetg(e,c)
	return c:IsAttribute(ATTRIBUTE_DEVINE) 
end
function c10700052.darkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10700052.darkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10700052.darkfilter,c:GetControler(),LOCATION_REMOVED,0,1,c)
end
function c10700052.darktg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c10700052.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c10700052.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.GetMZoneCount(tp,c)>0
end
function c10700052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c10700052.thfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10700052.thfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10700052.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c10700052.repop)
	end
end
function c10700052.thfilter2(c)
	return c:IsAbleToRemove()
end
function c10700052.repop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c10700052.thfilter2,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	if rg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=rg:Select(1-tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c10700052.desfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_ONFIELD) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function c10700052.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10700052.desfilter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c10700052.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10700052.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
