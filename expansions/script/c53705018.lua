--超 极 幻 海 袭  丰 之 黄 金
function c53705018.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c53705018.spcon)
	e0:SetTarget(c53705018.target)
	e0:SetOperation(c53705018.activate)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--atkdef
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c53705018.effcon)
	e1:SetValue(c53705018.value)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53705018,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c53705018.effcon)
	e2:SetLabel(2)
	e2:SetTarget(c53705018.tgtg)
	e2:SetOperation(c53705018.tgop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53705018,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(3)
	e3:SetCondition(c53705018.effcon)
	e3:SetCost(c53705018.pubcost)
	e3:SetTarget(c53705018.pubtg)
	e3:SetOperation(c53705018.pubop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c53705018.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
end
function c53705018.xyzfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and ((c:IsSetCard(0x3534) and c:IsType(TYPE_SYNCHRO) and c:GetFlagEffect(53705018)~=0) or not c:IsLocation(LOCATION_GRAVE))
end
function c53705018.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	local minc=2
	local maxc=zone:GetCount() 
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	return Duel.CheckXyzMaterial(c,c53705018.xyzfilter,9,minc,maxc,zone)
end
function c53705018.target(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	local minc=2
	local maxc=zone:GetCount() 
	if min then
		 if min>minc then minc=min end
		 if max<maxc then maxc=max end
	end
	local g=Duel.SelectXyzMaterial(tp,c,c53705018.xyzfilter,9,minc,maxc,zone)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c53705018.activate(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function c53705018.effcon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	local ng=og:Filter(Card.IsSetCard,nil,0x3534)
	return ng:GetCount()>=e:GetLabel()
end
function c53705018.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPublic,0,LOCATION_HAND,LOCATION_HAND,nil)*300
end
function c53705018.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if chk==0 then return #g>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c53705018.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if #g>0 and #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sdg=dg:Select(tp,1,g:GetCount(),nil)
		Duel.HintSelection(sdg)
		Duel.SendtoGrave(sdg,REASON_EFFECT)
	end
end
function c53705018.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c53705018.pubfilter(c)
	return not c:IsPublic()
end
function c53705018.pubtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(c53705018.pubfilter,tp,LOCATION_HAND,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c53705018.pubop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53705018.pubfilter,tp,LOCATION_HAND,LOCATION_HAND,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PUBLIC)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(53705018,0))
		tc=g:GetNext()
	end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
	if ct>0 then Duel.Damage(1-tp,ct*400,REASON_EFFECT) end
end
function c53705018.indcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
