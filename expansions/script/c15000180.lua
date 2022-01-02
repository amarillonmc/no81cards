local m=15000180
local cm=_G["c"..m]
cm.name="激愤的牛头人"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()~=0
end
function cm.sprfilter1(c,sc)
	return c:IsCanBeXyzMaterial(sc)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetOverlayCount(tp,LOCATION_MZONE,LOCATION_MZONE)>=1 and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local ag=Duel.GetOverlayGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=ag:FilterSelect(tp,cm.sprfilter1,1,2,nil,c)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end