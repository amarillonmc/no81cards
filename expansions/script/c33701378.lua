--威压的存在感
local m=33701378
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(cm.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(cm.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.actcona)
	e4:SetValue(cm.actlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e4:SetCondition(cm.actconb)
	e5:SetValue(cm.actlimit)
	c:RegisterEffect(e5)
	
end
function cm.lvcheck(g,g1)
	if g1:GetCount()==0 then
		if g:GetCount()>0 then return true
		else return false end
	end
	local lvmax=g:GetSum(Card.GetLevel)
	local rkmax=g:GetSum(Card.GetRank)
	local lkmax=g:GetSum(Card.GetLink)
	local lvmax1=g1:GetSum(Card.GetLevel)
	local rkmax1=g1:GetSum(Card.GetRank)
	local lkmax1=g1:GetSum(Card.GetLink)
	local t1=(lvmax>0 and lvmax>lvmax1) or (lvmax<=0 and lvmax1<=0)
	local t2=(rkmax>0 and rkmax>rkmax1) or (rkmax<=0 and rkmax1<=0)
	local t3=(lkmax>0 and lkmax>lkmax1) or (lkmax<=0 and lkmax1<=0)
	return t1 and t2 and t3
end
function cm.effectfilter(e,ct)
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	if not te:IsActiveType(TYPE_MONSTER) then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return cm.lvcheck(g,g1)
	
end
function cm.actcona(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return cm.lvcheck(g,g1)
end
function cm.actconb(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0)
	local g1=Duel.GetFieldGroup(1-tp,0,LOCATION_MZONE)
	return cm.lvcheck(g,g1)
end
function cm.actlimit(e,re,tp)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local rc=re:GetHandler()
	local min=0
	local rclv=0
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if g:GetCount()==0 then return true end
	if rc:GetLevel()>0 then
		local tc=g:GetFirst()
		min=tc:GetLevel()
		rclv=rc:GetLevel()
		while tc do
			local lv=tc:GetLevel()
			if lv>0 and min>tc:GetLevel() then min=tc:GetLevel() end
			tc=g:GetNext()
		end
	end
	if rc:GetRank()>0 then
		local tc=g:GetFirst()
		min=tc:GetRank()
		rclv=rc:GetRank()
		while tc do
			local lv=tc:GetRank()
			if lv>0 and min>tc:GetRank() then min=tc:GetRank() end
			tc=g:GetNext()
		end
	end
	if rc:GetLink()>0 then
		local tc=g:GetFirst()
		min=tc:GetLink()
		rclv=rc:GetLink()
		while tc do
			local lv=tc:GetLink()
			if lv>0 and min>tc:GetLink() then min=tc:GetLink() end
			tc=g:GetNext()
		end
	end
	return rclv>=min
end
