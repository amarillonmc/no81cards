--虚网接入协议
local m=33300307
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e2:SetTarget(cm.tg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function cm.tg(e,c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x562)
end
function cm.spcheck(e,tp,c)
	return c:IsSetCard(0x562) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spcheck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local  sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spcheck),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
			 local e2=Effect.CreateEffect(e:GetHandler())
			 e2:SetType(EFFECT_TYPE_FIELD)
			 e2:SetRange(LOCATION_MZONE)
			 e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			 e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			 e2:SetLabel(tp)
			 e2:SetTargetRange(1,0)
			 e2:SetTarget(cm.sslimit)
			 e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_LINK) and not e:GetHandler():IsControler(e:GetLabel())
end