--幻殇·苍玉龙
function c11180033.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11180033.mfilter,nil,2,99)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11180033)
	e1:SetCondition(c11180033.mtcon)
	e1:SetTarget(c11180033.mttg)
	e1:SetOperation(c11180033.mtop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c11180033.efilter)
	e2:SetCondition(c11180033.effcon)
	c:RegisterEffect(e2)
	--atk and def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11180033.effcon)
	e3:SetValue(6000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(c11180033.val)
	c:RegisterEffect(e5)
end
function c11180033.val(e)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	return g:GetClassCount(Card.GetAttribute)-1
end
function c11180033.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c11180033.mfilter(c,xyzc)
	return c:IsSetCard(0x3450) and c:IsFaceup()
end
function c11180033.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11180033.matfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x3450) and c:IsCanOverlay() and c:IsLevel(3)
end
function c11180033.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c11180033.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11180033.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c11180033.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,4,nil)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,gg:GetCount(),0,0)
	end
end
function c11180033.mtfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsCanOverlay()
end
function c11180033.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c11180033.mtfilter,nil,e)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c11180033.attfilter(c)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_MONSTER)
end
function c11180033.effcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	local att=0
	for tc in aux.Next(g) do
		if c11180033.attfilter(tc) then
			att=att|tc:GetAttribute()
		end
	end
	local gattr=ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE|ATTRIBUTE_WIND|ATTRIBUTE_LIGHT|ATTRIBUTE_DARK
	return att&gattr==gattr
end
function c11180033.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x3450,0x6450)
end