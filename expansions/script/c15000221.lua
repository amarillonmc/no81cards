local m=15000221
local cm=_G["c"..m]
cm.name="『同谐』的合奏-希佩"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	c:EnableReviveLimit()
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.effcon)
	c:RegisterEffect(e1)
	--Harmony
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(15000221)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)
	--
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_ADJUST)
	e22:SetOperation(cm.nameop)
	c:RegisterEffect(e22)
	--change activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.nametg(e,c)
	return c:IsFaceup() and c~=e:GetHandler()
end
function cm.namefilter(c,e)
	return c:IsFaceup() and not c:IsCode(15000221) and not c:IsImmuneToEffect(e)
end
function cm.name2filter(c)
	return c:IsFaceup() and c:IsHasEffect(15000221) and not c:IsDisabled()
end
function cm.nameop(e)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE):Filter(cm.namefilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(cm.namecon)
		e1:SetValue(15000221)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function cm.namecon(e)
	return Duel.IsExistingMatchingCard(cm.name2filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(15000221) and c:IsType(TYPE_XYZ)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and code==15000221  and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,rc) and rc:IsCanOverlay()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c):GetFirst()
	if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.HintSelection(Group.FromCards(tc))
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end