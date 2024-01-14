--Kamipro 美狄亚
function c50214105.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c50214105.xcheck,4,2,c50214105.ovfilter,aux.Stringid(50214105,0),2,c50214105.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_ALL-ATTRIBUTE_DIVINE-ATTRIBUTE_LIGHT)
	e1:SetCondition(c50214105.attcon)
	c:RegisterEffect(e1)
	--move field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,50214105)
	e2:SetCondition(c50214105.mfcon)
	e2:SetTarget(c50214105.mftg)
	e2:SetOperation(c50214105.mfop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,50214106)
	e3:SetCost(c50214105.dmcost)
	e3:SetTarget(c50214105.dmtg)
	e3:SetOperation(c50214105.dmop)
	c:RegisterEffect(e3)
end
function c50214105.xcheck(c)
	return c:IsSetCard(0xcbf)
end
function c50214105.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:GetCounter(0xcbf)>=5
end
function c50214105.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50214105)==0 end
	Duel.RegisterFlagEffect(tp,50214105,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c50214105.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50214105.mfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c50214105.pfilter(c,tp)
	return not c:IsForbidden() and c:IsType(TYPE_FIELD) and c:IsCode(50213235) and c:CheckUniqueOnField(tp)
end
function c50214105.mftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50214105.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c50214105.mfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50214105.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c50214105.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50214105.dmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf)
end
function c50214105.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50214105.dmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(c50214105.dmfilter,tp,LOCATION_ONFIELD,0,nil)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c50214105.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(c50214105.dmfilter,tp,LOCATION_ONFIELD,0,nil)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end