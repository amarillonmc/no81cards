local m=15004200
local cm=_G["c"..m]
cm.name="虚实写笔-龙"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,cm.syncheck)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(cm.accon)
	e2:SetTarget(cm.actarget)
	e2:SetCost(cm.accost)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15004200)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.syncheck(g)
	local sg=g:Clone()
	local x=1
	for c in aux.Next(sg) do
		if not c:IsType(TYPE_NORMAL) then x=0 end
		if x==0 then break end
	end
	return x==1
end
function cm.accon(e)
	cm[0]=false
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.actarget(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and bit.band(te:GetActivateLocation(),LOCATION_MZONE)~=0 and (te:GetHandler():IsAbleToExtraAsCost() or te:GetHandler():IsAbleToHandAsCost()) and not te:GetHandler():IsCode(15004200)
end
function cm.accost(e,te,tp)
	e:SetLabelObject(te:GetHandler())
	return te:GetHandler():IsAbleToExtraAsCost() or te:GetHandler():IsAbleToHandAsCost()
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	local tc=e:GetLabelObject()
	if tc:IsAbleToHandAsCost() then
		Duel.SendtoHand(tc,nil,REASON_COST)
	else
		if tc:IsAbleToExtraAsCost() then
			Duel.SendtoDeck(tc,nil,0,REASON_COST)
		end
	end
	cm[0]=true
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end