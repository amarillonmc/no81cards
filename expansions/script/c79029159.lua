--罗德岛·近卫干员-缠丸
function c79029159.initial_effect(c)
	c:EnableReviveLimit()  
	--Check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetOperation(c79029159.regop)
	c:RegisterEffect(e1)
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
	e1:SetCondition(c79029159.sprcon)
	e1:SetOperation(c79029159.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-6)
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
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34408491,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(c79029159.atkcon)
	e3:SetOperation(c79029159.atkop)
	c:RegisterEffect(e3) 
	--send to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c79029159.sdcon)
	e4:SetOperation(c79029159.sdop)
	c:RegisterEffect(e4)  
end
function c79029159.sprfilter(c)
	return c:IsFaceup()
end
function c79029159.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return not c:IsType(TYPE_TUNER) and g:IsExists(c79029159.sprfilter2,2,c,tp,c,sc) and g:Filter(c79029159.sprfilter2,nil):GetSum(Card.GetLevel)-lv==6
end
function c79029159.sprfilter2(c,tp,g,sc)
	return c:IsType(TYPE_TUNER) 
end
function c79029159.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029159.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029159.sprfilter1,1,nil,tp,g,c)
end
function c79029159.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029159.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c79029159.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c79029159.sprfilter2,2,2,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	Debug.Message("敢站到我面前，有胆量！")
end
end
function c79029159.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	if bit.band(r,REASON_EFFECT)~=0 then return rp==1-tp end
	return e:GetHandler():IsRelateToBattle()
end
function c79029159.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c79029159.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetBattleTarget()
	if c:IsRelateToBattle() then
		c:RegisterFlagEffect(79029159,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,0)
	end
end
function c79029159.fil(c)
	return c:GetFlagEffect(79029159)~=0 and c:IsLocation(LOCATION_ONFIELD)
end
function c79029159.sdcon(e,c)
	 return Duel.IsExistingMatchingCard(c79029159.fil,tp,0,LOCATION_MZONE,1,nil)
end
function c79029159.sdop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c79029159.fil,tp,0,LOCATION_MZONE,1,nil)
	 local tc=g:GetFirst()
	 local x=tc:GetAttack()
	 Duel.SendtoGrave(tc,REASON_EFFECT)
	 Duel.Recover(tp,x,REASON_EFFECT)
end



