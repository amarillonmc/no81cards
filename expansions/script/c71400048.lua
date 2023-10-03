--正在磨牙的那个东西
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400048.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(yume.YumeCheck,c),nil,nil,c71400048.mfilter,1,99,c71400048.gfilter(c))
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c71400048.val)
	c:RegisterEffect(e1)
	--indes
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetRange(LOCATION_MZONE)
	e1a:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1a:SetValue(1)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1b)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c71400048.op2)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(71400048,0))
	e3:SetCondition(c71400048.con3)
	e3:SetTarget(c71400048.tg3)
	e3:SetOperation(c71400048.op3)
	c:RegisterEffect(e3)
	--double tuner check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c71400048.valcheck)
	c:RegisterEffect(e4)
end
function c71400048.mfilter(c,sc)
	return c:IsSetCard(0x714) and c:IsNotTuner(sc) or c:IsType(TYPE_TUNER)
end
function c71400048.gfilter(c)
	return  function(g,syncard)
				return g:IsExists(Card.IsNotTuner,1,nil,c)
			end
end
function c71400048.val(e,c)
	return Duel.GetMatchingGroupCount(c71400048.filter1,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)*500
end
function c71400048.filter1(c)
	return c:IsSetCard(0x714) and (c:IsType(TYPE_TUNER) or c:IsType(TYPE_SYNCHRO)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c71400048.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c71400048.filter2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c71400048.ftarget)
	e2:SetLabel(c:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c71400048.filter2(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c71400048.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c71400048.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,re:GetHandler():GetCode())
		and Duel.IsChainNegatable(ev)
end
function c71400048.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c71400048.op3(e,tp,eg,ep,ev,re,r,rp)
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c71400048.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end