--改造索斯兽-肯塔罗斯
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,3)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--zone limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.zonelimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(s.descon)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(s.fuslimit)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e4:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e9)
	--attack cost
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_ATTACK_COST)
	e10:SetCost(s.atcost)
	e10:SetOperation(s.atop)
	c:RegisterEffect(e10)
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.zonelimit(e)
	return 0x7f007f & ~e:GetHandler():GetLinkedZone()
end
function s.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function s.gradient(y,x)
	if y>0 and x==0 then return math.pi/2 end
	if y<0 and x==0 then return math.pi*3/2 end
	if y>=0 and x>0 then return math.atan(y/x) end
	if x<0 then return math.pi+math.atan(y/x) end
	if y<0 and x>0 then return 2*math.pi+math.atan(y/x) end
	return 1000
end
function s.fieldline(x1,y1,x2,y2,...)
	for _,k in pairs({...}) do
		if s.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function s.seqfilter(c,tc,tp)
	local x1,y1=s.xylabel(c,tp)
	local x2,y2=s.xylabel(tc,tp)
	return math.abs(y1-y2)<=1 and math.abs(x1-x2)<=1 and s.islinkdir(tc,x1,y1,tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler(),tp)
	return #g>0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler(),tp)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,4,e:GetHandler())
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,4,4,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.islinkdir(lc,x,y,tp)
	if lc:IsControler(1-tp) then x,y=4-x,4-y end
	local x0,y0=s.xylabel(lc,lc:GetControler())
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and s.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end