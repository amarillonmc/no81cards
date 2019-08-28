--幻梦迷境王将 普芙蕾
function c65010056.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65010056.xyzcon)
	e0:SetOperation(c65010056.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c65010056.sumsuc)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c65010056.cost)
	e2:SetTarget(c65010056.destg)
	e2:SetOperation(c65010056.desop)
	c:RegisterEffect(e2)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSummonType,SUMMON_TYPE_XYZ))
	c:RegisterEffect(e4)
end
function c65010056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65010056.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65010056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010056.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c65010056.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c65010056.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65010056.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.Destroy(g,REASON_EFFECT)>=2 and Duel.SelectYesNo(tp,aux.Stringid(65010056,0)) then
		local mg=Duel.SelectMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if mg:GetCount()>0 then
			Duel.HintSelection(mg)
			Duel.SendtoGrave(mg,REASON_EFFECT)
		end
	end
end

function c65010056.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c65010056.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c65010056.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c65010056.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and e:GetHandler()~=re:GetHandler()
end
function c65010056.disable(e,c)
	return c~=e:GetHandler() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function c65010056.mfilter(c,xyzc)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsCanBeXyzMaterial(xyzc) and c:GetLevel()>0 
end
function c65010056.xyzfilter1(c,g)
	return c:IsLevel(8) and g:IsExists(c65010056.xyzfilter2,1,c,c:GetAttribute()) and c:IsRace(RACE_CYBERSE)
end
function c65010056.xyzfilter2(c,at)
	return c:IsLevel(8) and c:GetAttribute()~=at and c:IsRace(RACE_CYBERSE)
end
function c65010056.xyzfilter3(c,g)
	local att=0
	local tc=g:GetFirst()
	while tc do
		if c:GetAttribute()==tc:GetAttribute() then att=1 end
		tc=g:GetNext()
	end
	return att==0 and c:IsLevel(8) and c:IsRace(RACE_CYBERSE)
end
function c65010056.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc,maxc=2,2
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local mg=nil
	if og then
		mg=og:Filter(c65010056.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c65010056.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return mg:IsExists(c65010056.xyzfilter1,1,nil,mg)
end
function c65010056.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c65010056.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c65010056.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc,maxc=2,2
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c65010056.xyzfilter1,1,1,nil,mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c65010056.xyzfilter3,1,1,nil,g)
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end