--电脑网断了
--21.06.18
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetValue(cm.zones)
	c:RegisterEffect(e1)
	--force mzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(cm.frcval)
	c:RegisterEffect(e2)
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
function cm.willbelinkdir(c,lc,x0,y0,tp,tgp)
	if tp~=tgp then x0,y0=4-x0,4-y0 end
	local x,y=cm.xylabel(c,tgp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.islinkdir(lc,x,y,tp)
	if lc:IsControler(1-tp) then x,y=4-x,4-y end
	local x0,y0=cm.xylabel(lc,lc:GetControler())
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	--local list={11,110,9,10,1000,0,-1,100,1}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsAbleToRemove()
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local zone=0
	for i=0,4 do
		for lc in aux.Next(lg) do
			if cm.islinkdir(lc,i,0,tp) then zone=zone|(1<<i) end
		end
	end
	return zone
end
function cm.dfilter(lc,x,tp)
	return cm.islinkdir(lc,x,0,tp) and Duel.CheckLocation(tp,LOCATION_SZONE,x)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then
		if c:IsLocation(LOCATION_SZONE) then
			local x,y=cm.xylabel(c,tp)
			return lg:IsExists(cm.islinkdir,1,nil,x,y,tp)
		else
			for x=0,4 do
				if lg:IsExists(cm.dfilter,1,nil,x,tp) then return true end
			end
			return false
		end
	end
	local x,y=cm.xylabel(c,tp)
	local g=lg:Filter(cm.islinkdir,nil,x,y,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local x,y=cm.xylabel(c,tp)
	local g=lg:Filter(cm.islinkdir,nil,x,y,tp)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup():Filter(cm.rffilter,nil)
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetLabelObject(og)
		e1:SetOperation(cm.retop)
		c:RegisterEffect(e1,true)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	for tc in aux.Next(tg) do Duel.ReturnToField(tc) end
	e:Reset()
end
function cm.frcval(e,c,fp,rp,r)
	if not c:IsType(TYPE_LINK) then return 0xff00ff end
	local zone=0
	for x=0,4 do
		if not Duel.IsExistingMatchingCard(cm.willbelinkdir,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c,x,1,fp,fp) then zone=zone|(1<<x) end
		if not Duel.IsExistingMatchingCard(cm.willbelinkdir,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c,x,3,fp,1-fp) then zone=zone|(1<<(16+x)) end
	end
	if not Duel.IsExistingMatchingCard(cm.willbelinkdir,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c,1,2,fp,fp) then zone=zone|0x400020 end
	if not Duel.IsExistingMatchingCard(cm.willbelinkdir,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c,3,2,fp,fp) then zone=zone|0x200040 end
	return zone
end