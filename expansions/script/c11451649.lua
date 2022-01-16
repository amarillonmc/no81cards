--电脑网路标
--22.01.07
local m=11451649
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetValue(cm.zones)
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
	if y>0 and x==0 then return 100 end
	if y<0 and x==0 then return 110 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+10 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 10 end
	return 1000
end
function cm.fieldline(x1,y1,x2,y2,tp,...)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.isdir(lc,x,y,tp)
	local x0,y0=cm.xylabel(lc,tp)
	local list={11,110,9,10,1000,0,-1,100,1}
	for i=0,8 do
		if cm.fieldline(x0,y0,x,y,tp,list[i+1]) then return true,i end
	end
	return false,nil
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local zone=0
	for i=0,4 do
		for lc in aux.Next(lg) do
			if cm.isdir(lc,i,0,tp) then zone=zone|(1<<i) end
		end
	end
	return zone
end
function cm.dfilter(lc,x,tp)
	return cm.isdir(lc,x,0,tp) and Duel.CheckLocation(tp,LOCATION_SZONE,x)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then
		if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11451656,0,0x4004011,0,nil,nil,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK)) then return false end
		if c:IsLocation(LOCATION_SZONE) then
			local x,y=cm.xylabel(c,tp)
			return lg:IsExists(cm.isdir,1,nil,x,y,tp)
		else
			for x=0,4 do
				if lg:IsExists(cm.dfilter,1,nil,x,tp) then return true end
			end
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_SZONE) or not c:IsFaceup() or not Duel.IsPlayerCanSpecialSummonMonster(tp,11451656,0,0x4004011,0,nil,nil,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) then return end
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local x,y=cm.xylabel(c,tp)
	local lm=0
	local lk=0
	for lc in aux.Next(lg) do
		local bool,i=cm.isdir(lc,x,y,tp)
		if bool and lm&(1<<(8-i))==0 then
			lm=lm|(1<<(8-i))
			lk=lk+1
		end
	end
	if lm==0 then return end
	local token=Duel.CreateToken(tp,11451655+lk)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(lm)
	token:RegisterEffect(e1)
	for i=0,8 do
		if lm&(1<<(8-i))>0 then
			token:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,8-i))
		end
	end
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end