--言灵使者·洋荷
function c72411730.initial_effect(c)
	--ns
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411730,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c72411730.ttcon)
	e1:SetOperation(c72411730.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)  
	--sp 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c72411730.spcon)
	e2:SetOperation(c72411730.spop)
	c:RegisterEffect(e2) 
end
function c72411730.ttcon(e,c,minc)
	if c == nil then return true end
	return minc <= 3 and Duel.CheckTribute(c,3)
end
function c72411730.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g = Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c72411730.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType() == SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF
end
function c72411730.spop(e,tp)
	local c = e:GetHandler()
	Duel.Hint(HINT_CARD,0,72411730)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70095154,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c72411730.sprcon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c72411730.eftg)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,0)
	e5:SetValue(c72411730.actlimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c72411730.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE) > 0
end
function c72411730.eftg(e,c)
	local tp = e:GetOwnerPlayer()
	return c:IsSummonableCard()
end
function c72411730.actlimit(e,re)
	return re:GetHandler():IsControler(e:GetOwnerPlayer()) and re:GetCode() & (EVENT_SUMMON_SUCCESS + EVENT_SPSUMMON_SUCCESS) ~= 0
end