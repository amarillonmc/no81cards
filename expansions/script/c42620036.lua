--海晶少女的斗礁
local m=42620036
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.matg)
	e1:SetValue(cm.maval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(cm.valcheck)
	c:RegisterEffect(e4)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.eqcon)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
end

function cm.matg(e,c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK+TYPE_MONSTER) and c:IsLinkBelow(3)
end

function cm.valfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x12b)
end

function cm.maval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(cm.valfilter,tp,LOCATION_SZONE,0,nil)
end

function cm.ccfilter(c)
	return c:IsFaceup() and c:GetSequence()>4 and c:IsType(TYPE_LINK)
	and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterial():IsExists(Card.IsCode,1,nil,79130389)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ccfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:GetSequence()>4 and c:IsSetCard(0x12b) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end

function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end

function cm.eqfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK) and not c:IsForbidden()
end

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	eg:GetFirst():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),3)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_GRAVE,0,nil)
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or ft<=0 or g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if sg and sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			Duel.Equip(tp,sc,tc,false,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetLabelObject(tc)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end

function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end