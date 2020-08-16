--雷姆必拓·重装干员-暴行
function c79029153.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c79029153.sprcon)
	e1:SetOperation(c79029153.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SYNCHRO+TYPE_EFFECT)
	c:RegisterEffect(e1)  
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-8)
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
function c79029153.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) 
end
function c79029153.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029153.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	return c:IsFaceup() and g:CheckWithSumEqual(Card.GetLevel,8+lv,1,99) and not c:IsType(TYPE_TUNER)
end
function c79029153.sprcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029153.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c79029153.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029153.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029153.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,8+lv,1,99)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	e:GetHandler():SetMaterial(g1)
	Debug.Message("暴行，就位！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029153,0))
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
	Debug.Message("突击开始！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029153,1))
end

