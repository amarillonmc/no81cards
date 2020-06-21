--雷姆必拓·重装干员-暴行
function c79029153.initial_effect(c)
	c:EnableReviveLimit()  
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c79029153.sprcon)
	e1:SetOperation(c79029153.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-8)
	c:RegisterEffect(e1) 
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SYNCHRO+TYPE_EFFECT)
	c:RegisterEffect(e1) 
	--dark SynchroSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_RECOVER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c79029153.op)
	e4:SetCondition(c79029153.con)
	c:RegisterEffect(e4) 
	--defense attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DEFENSE_ATTACK)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c79029153.sprfilter(c)
	return c:IsFaceup()
end
function c79029153.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return not c:IsType(TYPE_TUNER) and g:IsExists(c79029153.sprfilter2,3,c,tp,c,sc) and g:Filter(c79029153.sprfilter2,nil):GetSum(Card.GetLevel)-lv==8
end
function c79029153.sprfilter2(c,tp,g,sc)
	return c:IsType(TYPE_TUNER) 
end
function c79029153.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029153.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029153.sprfilter1,1,nil,tp,g,c)
end
function c79029153.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029153.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c79029153.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c79029153.sprfilter2,3,3,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	Debug.Message("暴行，就位！")
end
end
function c79029153.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function c79029153.op(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end

