local m=15004110
local cm=_G["c"..m]
cm.name="四次元洞·布鲁顿"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,15004110)
	aux.AddCodeList(c,15003023)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--damage val
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(cm.reptg)
	e4:SetValue(cm.repval)
	c:RegisterEffect(e4)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e4:SetLabelObject(g)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER)
		and c:IsCanOverlay(tp) and not c:IsCode(15004110)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((not re) or re~=e) and bit.band(r,REASON_RULE)==0 and eg:IsExists(cm.repfilter,1,e:GetHandler(),tp) end
	if eg:IsExists(cm.repfilter,1,e:GetHandler(),tp) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(cm.repfilter,e:GetHandler(),tp)
		local tc=g:GetFirst()
		while tc do
			tc:CancelToGrave()
			if tc:GetOverlayCount()~=0 then
				local ag=tc:GetOverlayGroup()
				Duel.SendtoGrave(ag,REASON_RULE)
			end
			Duel.Overlay(e:GetHandler(),tc)
			tc=g:GetNext()
		end
		container:Merge(g)
		return true
	else return false end
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>=16
end
function cm.spfilter(c,e,tp)
	return c:IsCode(15003023) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end