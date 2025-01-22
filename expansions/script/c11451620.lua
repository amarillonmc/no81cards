--心连星
--21.08.14
--2021 Happy Chinese Valuntine's Day!
local cm,m=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.xylabel(c,tp)
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
function cm.gradient(y,x)
	if y>0 and x==0 then return math.pi/2 end
	if y<0 and x==0 then return math.pi*3/2 end
	if y>=0 and x>0 then return math.atan(y/x) end
	if x<0 then return math.pi+math.atan(y/x) end
	if y<0 and x>0 then return 2*math.pi+math.atan(y/x) end
	return 1000
end
function cm.fieldline(x1,y1,x2,y2,...)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.willbemutuallinked(c,lc,x0,y0,tp,tgp)
	if tp~=tgp then x0,y0=4-x0,4-y0 end
	local x,y=cm.xylabel(c,tgp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	local ct=c:IsControler(tgp)
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) and math.abs(x0-x)<=1 and math.abs(y0-y)<=1 and ((c:IsLinkMarker(1<<(8-i)) and ct) or (c:IsLinkMarker(1<<i) and not ct)) then return true end
	end
	return false
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0 and not Duel.IsExistingMatchingCard(Card.IsExtraLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,365)
end
function cm.seqfilter(c)
	return c:GetSequence()>4
end
function cm.lkfilter(c,g)
	return #Group.__band(c:GetMutualLinkedGroup(),g)>0
end
function cm.spfilter(c,e,tp)
	local exg=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #exg~=2 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCountFromEx(tp)==0 then return false end
	local g1=Group.FromCards(exg:GetFirst())
	local new=g1
	while #new>0 do
		new=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,g1,g1)
		g1:Merge(new)
	end
	local g2=Group.FromCards(exg:GetNext())
	new=g2
	while #new>0 do
		new=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,g2,g2)
		g2:Merge(new)
	end
	local zone=0
	for x=0,4 do
		if g1:IsExists(cm.willbemutuallinked,1,nil,c,x,1,tp,tp) and g2:IsExists(cm.willbemutuallinked,1,nil,c,x,1,tp,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,1<<x) then zone=zone|(1<<x) end
	end
	if zone==0 then return false,0 end
	return true,zone
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		local _,zone=cm.spfilter(g:GetFirst(),e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end