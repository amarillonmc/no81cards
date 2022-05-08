local m=15004004
local cm=_G["c"..m]
cm.name="不死神王不死鸟"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--xcheck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(15004004)
	e1:SetRange(LOCATION_MZONE) 
	c:RegisterEffect(e1)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTarget(cm.rtg)
	e2:SetValue(cm.rval)
	c:RegisterEffect(e2,true)
	--no
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetCondition(cm.recon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)  
	c:RegisterEffect(e4)
	--no
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e5:SetCondition(cm.re2con)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_USE_AS_COST)  
	c:RegisterEffect(e6)

	if not cm.phoenixcheck then
		cm.phoenixcheck=true
		_PGetLocationCountFromEx=Duel.GetLocationCountFromEx
		function Duel.GetLocationCountFromEx(ap,bp,group,sc,zone)
			local g=group
			local ty=0
			if aux.GetValueType(zone)=="nil" then zone=0xff end
			if aux.GetValueType(group)=="Card" then g=Group.FromCards(group) end
			if aux.GetValueType(group)=="nil" then g=Group.CreateGroup() end
			if aux.GetValueType(sc)=="Card" then
				if sc:IsType(TYPE_LINK) then ty=ty+TYPE_LINK end
				if sc:IsType(TYPE_PENDULUM) then ty=ty+TYPE_PENDULUM end
			end
			if aux.GetValueType(sc)=="int" then ty=sc end
			local x,y=_PGetLocationCountFromEx(ap,bp,group,sc,zone)
			if g:IsExists(cm.selfilter1,1,nil,ap,g) and bit.band(ty,TYPE_LINK+TYPE_PENDULUM)~=0 then
				return 0,127
			end
			return _PGetLocationCountFromEx(ap,bp,group,sc,zone)
		end
		_PGetMZoneCount=Duel.GetMZoneCount
		function Duel.GetMZoneCount(ap,group,bp,rea,zone)
			local g=group
			if aux.GetValueType(zone)=="nil" then zone=0xff end
			if aux.GetValueType(rea)=="nil" then rea=LOCATION_REASON_TOFIELD end
			if aux.GetValueType(group)=="Card" then g=Group.FromCards(group) end
			if aux.GetValueType(group)=="nil" then g=Group.CreateGroup() end
			local x,y=_PGetLocationCountFromEx(ap,bp,group,sc,zone)
			if g:IsExists(cm.selfilter2,1,nil,ap,g) then
				return 0,31
			end
			return _PGetMZoneCount(ap,group,bp,rea,zone)
		end
	end
end
function cm.mofilter(c,tp)
	return Duel.GetLinkedGroup(tp,LOCATION_MZONE,0):IsContains(c)
end
function cm.ZoneCount(n)
	local i=0
	local count=0
	n=cm.byte2bin(n)
	local t=type(n)
	if t=="string" then
		n=tonumber(n)
	end
	while n>=1 do
		i=n%10
		n=n/10
		if i>=1 then count=count+1 end
	end
	return count
end
function cm.byte2bin(n)
  local t={}
  for i=7,0,-1 do
	t[#t+1]=math.floor(n/2^i)
	n=n%2^i
  end
  return table.concat(t)
end
--如 果 g中 怪 兽 全 部 离 场 ， 通 常 预 计 可 用 的 位 置 只 有 1个 , 但 现 在 被 这 只 怪 兽 占 据 
--分 类 讨 论 link区 数 量 与 在 link区 内 的 怪 兽 数 量 相 同
function cm.selfilter1(c,tp,sg)
	local x1,y1=_PGetLocationCountFromEx(tp,tp,sg,TYPE_LINK)
	local x2,y2=_PGetLocationCountFromEx(tp,tp,c,TYPE_LINK)
	local z=Duel.GetLinkedZone(tp)
	return c:IsHasEffect(15004004) and c:GetOverlayCount()~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and ((sg:GetCount()~=1 and x1==1 and x2==1 and y1==y2) or ((sg:GetCount()==1 and cm.ZoneCount(Duel.GetLinkedZone(tp))-cm.ZoneCount(aux.GetMultiLinkedZone(tp))~=0 and cm.mofilter(c) and Duel.GetMatchingGroupCount(cm.mofilter,tp,LOCATION_MZONE,0,nil,tp)==cm.ZoneCount(Duel.GetLinkedZone(tp))-cm.ZoneCount(aux.GetMultiLinkedZone(tp))) or (sg:GetCount()==1 and c:GetSequence()>4 and (cm.ZoneCount(Duel.GetLinkedZone(tp))-cm.ZoneCount(aux.GetMultiLinkedZone(tp))==0 or (cm.ZoneCount(Duel.GetLinkedZone(tp))-cm.ZoneCount(aux.GetMultiLinkedZone(tp))==1 and cm.mofilter(c))))))
end
function cm.selfilter2(c,tp,sg)
	local x1,y1=_PGetMZoneCount(tp,sg,tp)
	local x2,y2=_PGetMZoneCount(tp,c,tp)
	return c:IsHasEffect(15004004) and c:GetOverlayCount()~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and x1==1 and x2==1
		and y1==y2
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return bit.band(r,REASON_RULE)==0 and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetOverlayCount()~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetOverlayCount()~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetMZoneCount(tp,c,tp)==0 and c:IsHasEffect(15004004) and c:GetOverlayCount()~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function cm.re2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(15004004) and c:GetOverlayCount()~=0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end