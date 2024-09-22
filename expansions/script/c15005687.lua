local m=15005687
local cm=_G["c"..m]
cm.name="时际终途·迹"
function cm.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	e1:SetOperation(cm.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_MZONE)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(cm.filter,tp,0,LOCATION_MZONE,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE,math.min(ft,ct),math.min(ft,ct),nil)
	if #g==0 then return end
	local x=0
	for tc in aux.Next(g) do
		if Duel.Equip(tp,tc,c,true,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1,true)
			x=x+1
		end
	end
	Duel.EquipComplete()
	if x>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(x*500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
end
function cm.filter1(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0
end
function cm.filter2(c,ec)
	return ec:IsAttribute(c:GetOriginalAttribute()) or ec:IsRace(c:GetOriginalRace())
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	if te:GetHandler():IsSetCard(0xaf3f) then return false end
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) then
		local g=c:GetEquipGroup():Filter(cm.filter1,nil)
		if #g>0 and g:IsExists(cm.filter2,1,nil,te:GetHandler()) then return true end
	end
	return false
end