--幻叙守护者 对魔忍
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
	c:EnableCounterPermit(0x838)
	c:SetCounterLimit(0x838,9)
	--Attack Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	--Defensive Pierce (Reverse Pierce)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--Token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.tkcon1)
	e3:SetCost(s.tkcost)
	e3:SetTarget(s.tktg)
	e3:SetOperation(s.tkop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(s.tkcon2)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e4)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(id)
	e1:SetRange(LOCATION_MZONE) 
	c:RegisterEffect(e1)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTarget(s.rtg)
	e2:SetValue(s.rval)
	c:RegisterEffect(e2,true)
	--no
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetCondition(s.recon)
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
	e5:SetCondition(s.re2con)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_USE_AS_COST)  
	c:RegisterEffect(e6)

	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(s.damval2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(s.damcon2)
	c:RegisterEffect(e4)

	if not s.phoenixcheck then
		s.phoenixcheck=true
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
			if g:IsExists(s.selfilter1,1,nil,ap,g) and bit.band(ty,TYPE_LINK+TYPE_PENDULUM)~=0 then
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
			if g:IsExists(s.selfilter2,1,nil,ap,g) then
				return 0,31
			end
			return _PGetMZoneCount(ap,group,bp,rea,zone)
		end
	end
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	return c==Duel.GetAttackTarget() and a and a:IsControler(1-tp)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	if not ac:IsHasEffect(EFFECT_PIERCE) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		ac:RegisterEffect(e2,true)
	end
end
function s.tkcon1(e,tp,eg,ep,ev,re,r,rp)
	return not aux.IsCanBeQuickEffect(e:GetHandler(),tp,65133217)
end
function s.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsCanBeQuickEffect(e:GetHandler(),tp,65133217)
end
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x838)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x838,1,REASON_COST) end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local ct=0
	for tc in aux.Next(g) do
		ct=ct+tc:GetCounter(0x838)
		tc:RemoveCounter(tp,0x838,ct,0)
		if KOISHI_CHECK and tc:GetOriginalCode()==id then
			tc:SetEntityCode(id)
		end
	end 
	e:SetLabel(ct)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPE_TOKEN+TYPE_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=e:GetLabel()
	local token=Duel.CreateToken(tp,id+2)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		local val=ct*1000
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		token:RegisterEffect(e2)
	end
end
function s.mofilter(c,tp)
	return Duel.GetLinkedGroup(tp,LOCATION_MZONE,0):IsContains(c)
end
function s.ZoneCount(n)
	local i=0
	local count=0
	n=s.byte2bin(n)
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
function s.byte2bin(n)
  local t={}
  for i=7,0,-1 do
	t[#t+1]=math.floor(n/2^i)
	n=n%2^i
  end
  return table.concat(t)
end
function s.addcounter(c)
	c:AddCounter(0x838,1)
	if KOISHI_CHECK and c:GetCounter(0x838)>5 then
		--c:SetEntityCode(id+1)
		--c:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT)
		if c:GetFlagEffect(id)==0 then
			c:SetCardData(CARDDATA_CODE,id+1)
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		else
			local i=Duel.GetRandomNumber(1,8)
			Duel.Hint(24,0,aux.Stringid(id,i))
		end
	end
end
function s.selfilter1(c,tp,sg)
	local x1,y1=_PGetLocationCountFromEx(tp,tp,sg,TYPE_LINK)
	local x2,y2=_PGetLocationCountFromEx(tp,tp,c,TYPE_LINK)
	local z=Duel.GetLinkedZone(tp)
	return c:IsHasEffect(id) and c:IsCanAddCounter(0x838,1) and ((sg:GetCount()~=1 and x1==1 and x2==1 and y1==y2) or ((sg:GetCount()==1 and s.ZoneCount(Duel.GetLinkedZone(tp))-s.ZoneCount(aux.GetMultiLinkedZone(tp))~=0 and s.mofilter(c) and Duel.GetMatchingGroupCount(s.mofilter,tp,LOCATION_MZONE,0,nil,tp)==s.ZoneCount(Duel.GetLinkedZone(tp))-s.ZoneCount(aux.GetMultiLinkedZone(tp))) or (sg:GetCount()==1 and c:GetSequence()>4 and (s.ZoneCount(Duel.GetLinkedZone(tp))-s.ZoneCount(aux.GetMultiLinkedZone(tp))==0 or (s.ZoneCount(Duel.GetLinkedZone(tp))-s.ZoneCount(aux.GetMultiLinkedZone(tp))==1 and s.mofilter(c))))))
end
function s.selfilter2(c,tp,sg)
	local x1,y1=_PGetMZoneCount(tp,sg,tp)
	local x2,y2=_PGetMZoneCount(tp,c,tp)
	return c:IsHasEffect(id) and c:IsCanAddCounter(0x838,1)
		and x1==1 and x2==1
		and y1==y2
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return bit.band(r,REASON_RULE)==0 and c:GetReasonPlayer()==1-tp end
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanAddCounter(0x838,1) then
		s.addcounter(c)
		return true
	else
		c:SetCardData(CARDDATA_CODE,id)
		return false
	end
end
function s.rval(e,c)
	return false
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetMZoneCount(tp,c,tp)==0 and c:IsHasEffect(id) and c:IsCanAddCounter(0x838,1)
end
function s.re2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(id) and c:IsCanAddCounter(0x838,1)
end
function s.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:IsCanAddCounter(0x838,1)then
		s.addcounter(c)
		return 0
	end
	return val
end
function s.damcon2(e)
	return e:GetHandler():IsCanAddCounter(0x838,1)
end