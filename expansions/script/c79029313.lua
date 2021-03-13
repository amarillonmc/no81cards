--萨尔贡·术士干员-特米米
function c79029313.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c79029313.sprcon)
	e1:SetOperation(c79029313.sprop)
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
	--LP
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029313.lzcon)
	e1:SetTarget(c79029313.lztg)
	e1:SetOperation(c79029313.lzop)
	c:RegisterEffect(e1)   
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5) 
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029313.damval3)
	c:RegisterEffect(e1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029313.damval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029313.damcon2)
	e2:SetOperation(c79029313.damop2)
	c:RegisterEffect(e2)
end
function c79029313.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) 
end
function c79029313.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029313.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	return c:IsFaceup() and g:CheckWithSumEqual(Card.GetLevel,8+lv,1,99) and not c:IsType(TYPE_TUNER)
end
function c79029313.sprcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029313.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c79029313.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029313.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029313.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,8+lv,1,99)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)~=0 then
	e:GetHandler():SetMaterial(g1)
	Debug.Message("走了，打，嗯，打爆他们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029313,0))
end
end
function c79029313.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029313.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029313.lzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot lose (damage)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c79029313.surcon1)
	e1:SetOperation(c79029313.surop1)
	Duel.RegisterEffect(e1,tp)
	--lp check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(c79029313.surcon2)
	e2:SetOperation(c79029313.surop2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c79029313.surcon2)
	e3:SetOperation(c79029313.surop2)
	Duel.RegisterEffect(e3,tp)
	Debug.Message("振作起来！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029313,2))
end
function c79029313.surcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetLP(tp)<=0 
end
function c79029313.surcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetLP(tp)<=0
end
function c79029313.surop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029313)
	Debug.Message("再撑一会，再撑一会！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029313,1))
	Duel.SetLP(tp,1000)
	e:Reset()
end
function c79029313.surop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLP(tp)<=0 then
	Duel.Hint(HINT_CARD,0,79029313)
	Debug.Message("再撑一会，再撑一会！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029313,1))
	Duel.SetLP(tp,1000)
	e:Reset()
	end
end
function c79029313.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end 
function c79029313.damval3(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then return val*2
	else return val end
end 
function c79029313.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.damcon1(e,1-tp,eg,ep,ev,re,r,rp)
end
function c79029313.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029313)
	xd=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	Duel.Damage(1-tp,xd,REASON_BATTLE)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetLabel(cid)
	e1:SetValue(c79029313.damval2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c79029313.damval2(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)==0 then return end
	return 0
end






