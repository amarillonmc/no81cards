local m=15005410
local cm=_G["c"..m]
cm.name="泣声龙 雷蒙盖顿"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15005410)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,15005397,cm.matfilter,1,99,false,false)
	local e0=aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	e0:SetValue(SUMMON_VALUE_SELF)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--mat check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.matcheck)
	c:RegisterEffect(e2)
	--act
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--cannot be targeted
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,7))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(cm.atttg)
	e6:SetOperation(cm.attop)
	c:RegisterEffect(e6)
end
function cm.matfilter(c)
	return c:IsFusionType(TYPE_TOKEN)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.matcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	e:SetLabel(att)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetMaterialCount()*1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	local att=e:GetLabelObject():GetLabel()
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,7,aux.Stringid(m,0))
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(m,1))
	end
	if bit.band(att,ATTRIBUTE_EARTH)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,2,aux.Stringid(m,2))
	end
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,3,aux.Stringid(m,3))
	end
	if bit.band(att,ATTRIBUTE_FIRE)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,4,aux.Stringid(m,4))
	end
	if bit.band(att,ATTRIBUTE_WIND)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,5,aux.Stringid(m,5))
	end
	if bit.band(att,ATTRIBUTE_DIVINE)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,6,aux.Stringid(m,6))
	end
end
function table.length(t)
	local i=0
	for k,v in pairs(t) do
		i=i+1
	end
	return i
end
function cm.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local attlist={}
		if c:GetFlagEffect(0)~=0 then
			for _,i in ipairs{c:GetFlagEffectLabel(0)} do
				if i then
					if i==7 and not c:IsAttribute(ATTRIBUTE_LIGHT) then table.insert(attlist,aux.Stringid(m,8)) end
					if i==1 and not c:IsAttribute(ATTRIBUTE_DARK) then table.insert(attlist,aux.Stringid(m,9)) end
					if i==2 and not c:IsAttribute(ATTRIBUTE_EARTH) then table.insert(attlist,aux.Stringid(m,10)) end
					if i==3 and not c:IsAttribute(ATTRIBUTE_WATER) then table.insert(attlist,aux.Stringid(m,11)) end
					if i==4 and not c:IsAttribute(ATTRIBUTE_FIRE) then table.insert(attlist,aux.Stringid(m,12)) end
					if i==5 and not c:IsAttribute(ATTRIBUTE_WIND) then table.insert(attlist,aux.Stringid(m,13)) end
					if i==6 and not c:IsAttribute(ATTRIBUTE_DIVINE) then table.insert(attlist,aux.Stringid(m,14)) end
				end
			end
		end
		return table.length(attlist)~=0
	end
	local att=0
	local attlist={}
	if c:GetFlagEffect(0)~=0 then
		for _,i in ipairs{c:GetFlagEffectLabel(0)} do
			if i then
				if i==7 and not c:IsAttribute(ATTRIBUTE_LIGHT) then
					table.insert(attlist,aux.Stringid(m,8))
					att=att+ATTRIBUTE_LIGHT
				end
				if i==1 and not c:IsAttribute(ATTRIBUTE_DARK) then
					table.insert(attlist,aux.Stringid(m,9))
					att=att+ATTRIBUTE_DARK
				end
				if i==2 and not c:IsAttribute(ATTRIBUTE_EARTH) then
					table.insert(attlist,aux.Stringid(m,10))
					att=att+ATTRIBUTE_EARTH
				end
				if i==3 and not c:IsAttribute(ATTRIBUTE_WATER) then
					table.insert(attlist,aux.Stringid(m,11))
					att=att+ATTRIBUTE_WATER
				end
				if i==4 and not c:IsAttribute(ATTRIBUTE_FIRE) then
					table.insert(attlist,aux.Stringid(m,12))
					att=att+ATTRIBUTE_FIRE
				end
				if i==5 and not c:IsAttribute(ATTRIBUTE_WIND) then
					table.insert(attlist,aux.Stringid(m,13))
					att=att+ATTRIBUTE_WIND
				end
				if i==6 and not c:IsAttribute(ATTRIBUTE_DIVINE) then
					table.insert(attlist,aux.Stringid(m,14))
					att=att+ATTRIBUTE_DIVINE
				end
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local aat=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(aat)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsAttribute,nil,aat)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsAttribute,nil,e:GetLabel())
		if #g>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
		end
	end
end