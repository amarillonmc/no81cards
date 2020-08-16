--罗德岛·术士干员-蜜蜡
function c79029247.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c79029247.sprcon)
	e1:SetOperation(c79029247.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-10)
	c:RegisterEffect(e1) 
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SYNCHRO+TYPE_EFFECT)
	c:RegisterEffect(e1)   
	--cannot atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(c79029247.cncon)
	c:RegisterEffect(e2)  
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c79029247.cncon)
	e2:SetValue(c79029247.efilter)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029247,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029247.retg)
	e3:SetOperation(c79029247.reop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029247,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79029247)
	e4:SetLabel(5)
	e4:SetCost(c79029247.cost)
	e4:SetTarget(c79029247.autg)
	e4:SetOperation(c79029247.auop)
	c:RegisterEffect(e4)
	--zone
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79029247,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,79029247)
	e5:SetCost(c79029247.cost1)
	e5:SetTarget(c79029247.zotg)
	e5:SetOperation(c79029247.zoop)
	c:RegisterEffect(e5)
end
function c79029247.cncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029247)==0
end
function c79029247.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029247.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) 
end
function c79029247.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029247.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lv=c:GetLevel()
	return c:IsFaceup() and g:CheckWithSumEqual(Card.GetLevel,10+lv,1,99) and not c:IsType(TYPE_TUNER)
end
function c79029247.sprcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029247.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
end
function c79029247.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029247.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029247.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,10+lv,1,99)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	e:GetHandler():SetMaterial(g1)
	Debug.Message("所站立之地，即为神灵眷土。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029247,4))
end
end
function c79029247.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetHandler():GetAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetAttack()/2) 
end
function c79029247.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Debug.Message("此即为神灵之祝福。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029247,5))
end
function c79029247.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,x,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,x,REASON_COST)
end
function c79029247.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,10,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,10,REASON_COST)
end
function c79029247.autg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end
function c79029247.auop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetHandler():GetAttack()*2)
	c:RegisterEffect(e1)
	--ATTACK ALL
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(79029247,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029247,3))
	Debug.Message("吞没他们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029247,6))
end
function c79029247.zotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)~=0 end 
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis) 
end
function c79029247.disfil(c,seq)
	return c:GetSequence()<5 and math.abs(seq-c:GetSequence())==1
end
function c79029247.zoop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dis=e:GetLabel()
	Debug.Message("在金色沙原中睡吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029247,7))
	--ATTACK ALL
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(79029247,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029247,3))
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c79029247.disop)
	e1:SetLabel(dis)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local seq=math.log(bit.rshift(dis,16),2)
	local g=Duel.GetMatchingGroup(c79029247.disfil,tp,0,LOCATION_MZONE,nil,seq)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
	local x=tc:GetSequence()
	if x==seq+1 then
	Duel.MoveSequence(tc,x+1)
	else
	Duel.MoveSequence(tc,x-1)
	end
	if tc:GetSequence()==x then
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RULE)
	end
	tc=g:GetNext()
	end
end
function c79029247.disop(e,tp)
	return e:GetLabel()
end





