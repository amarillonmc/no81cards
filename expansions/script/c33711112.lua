--VLiver Chigusa Hana SP
local m=33711112
local cm=_G["c"..m]
function c33711112.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.hspcon)
	e1:SetValue(cm.hspval)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--code
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_ADJUST)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCondition(cm.codecon)
	e2_1:SetOperation(cm.code)
	c:RegisterEffect(e2_1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--attack limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(cm.atlimit)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)

	--synchro limit
	local e4_1=Effect.CreateEffect(c)
	e4_1:SetType(EFFECT_TYPE_SINGLE)
	e4_1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e4_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4_1:SetTarget(cm.synlimit)
	c:RegisterEffect(e4_1)
	--fusion limit
	local e5_1=Effect.CreateEffect(c)
	e5_1:SetType(EFFECT_TYPE_SINGLE)
	e5_1:SetCode(EFFECT_TUNE_MAGICIAN_F)
	e5_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5_1:SetValue(cm.fuslimit)
	c:RegisterEffect(e5_1)
	--xyz limit
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_SINGLE)
	e6_1:SetCode(EFFECT_TUNE_MAGICIAN_X)
	e6_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6_1:SetValue(cm.xyzlimit)
	c:RegisterEffect(e6_1)
end
function cm.synlimit(e,c)
	return cm.IsLeft(c,e:GetHandler())
end
function cm.fuslimit(e,c)
	return not cm.IsLeft(c,e:GetHandler())
end
function cm.xyzlimit(e,c)
	return not cm.IsLeft(c,e:GetHandler())
end
function cm.eftg(e,c)
	return cm.IsLeft(c,e:GetHandler())
end
function cm.cfilter(c,tp)
	local Col=aux.GetColumn(c,tp)
	return cm.GetLeftGroupCount(tp,Col)==0 and not c:IsLocation(LOCATION_FZONE)
end
function cm.cfilter1(c)
	return not c:IsLocation(LOCATION_FZONE)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local flag=0
	local lg1=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	if lg1:GetCount()==0 then
		return true
	end
	if lg:GetCount()>0 then
		for tc in aux.Next(lg) do
			local Col=aux.GetColumn(tc,tp)
			for i=0,4 do
				if i-Col<1 then				 
					flag=flag|(1<<(i))
				end
			end
		end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,flag)>0
end
function cm.hspval(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local flag=0
	local lg1=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if lg1:GetCount()==0 then
		for i=0,4 do				 
			flag=flag|(1<<(i))
		end
		return 0,flag
	end
	if lg:GetCount()>0 then
		for tc in aux.Next(lg) do
			local Col=aux.GetColumn(tc,tp)
			for i=0,4 do
				if i-Col<1 then				 
					flag=flag|(1<<(i))
				end
			end
		end
	end
	return 0,flag
end
function cm.efilter(e,te)
	if te:GetHandler():IsLocation(LOCATION_ONFIELD) then
		return false
	end
	return cm.IsLeft(te:GetHandler(),e:GetHandler())
end
function cm.codecon(e)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.code(e)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.atkval(e,c)
	return not c:IsImmuneToEffect(e) and cm.IsLeft(c,e:GetHandler())
end
function cm.atlimit(e,c)
	return c:GetFlagEffect(m)>0 and cm.IsLeft(e:GetHandler(),c)
end
function cm.IsLeftCol(Col,Col1)
end 
function cm.IsLeft(c,mc)
	local tp=mc:GetControler()
	local Col=aux.GetColumn(mc,tp)
	return cm.IsLeftCard(c,tp,Col)
end
function cm.IsLeftCard(c,tp,Col)
	local Col_1=aux.GetColumn(c,tp)
	if c:IsType(TYPE_FIELD) then return true end
	return Col_1-Col<0
end
function cm.IsLeftGroup(g,tp,Col)
	for c in aux.Next(g) do
		if not cm.IsLeftCard(c,tp,Col) then
			return false
		end
	end
	return true
end
function cm.GetLeftGroup(tp,Col)
	local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local sg=Group.CreateGroup()
	for c in aux.Next(g) do
		if cm.IsLeftCard(c,tp,Col) then
			sg:AddCard(c)
		end
	end
	return sg
end
function cm.GetLeftGroupCount(tp,Col)
	local sg=cm.GetLeftGroup(tp,Col)
	return sg:GetCount()
end