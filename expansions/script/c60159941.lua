--光与暗的潜行者
function c60159941.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(c60159941.sprcon)
	e0:SetOperation(c60159941.sprop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60159941.linklimit)
	c:RegisterEffect(e1)
	--base atk/def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_SET_BASE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c60159941.atkval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e3)
end
function c60159941.cfilter(c,tp,lc)
	return c:IsCanBeLinkMaterial(lc) and c:IsFaceup() and c:GetSummonLocation()&(LOCATION_DECK+LOCATION_EXTRA)~=0
		and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c60159941.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c60159941.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:GetClassCount(Card.GetAttribute)==2
	end
	sg:RemoveCard(c)
	return res
end
function c60159941.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c60159941.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(c60159941.fselect,1,nil,tp,mg,sg)
end
function c60159941.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c60159941.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local g=mg:FilterSelect(tp,c60159941.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local sg2=Group.CreateGroup()
	local tc=sg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg2:Merge(sg1)
		tc=sg:GetNext()
	end
	Duel.SendtoGrave(sg2,REASON_RULE)
	c:SetMaterial(sg)
	Duel.Overlay(c,sg)
end
function c60159941.linklimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c60159941.atkval(e,c)
    return Duel.GetMatchingGroupCount(nil,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)*100
end