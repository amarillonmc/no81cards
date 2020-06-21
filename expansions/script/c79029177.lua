--罗德岛·狙击干员-慑砂
function c79029177.initial_effect(c)
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
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c79029177.sprcon)
	e1:SetOperation(c79029177.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(-9)
	c:RegisterEffect(e1) 
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(TYPE_SYNCHRO+TYPE_EFFECT)
	c:RegisterEffect(e1) 
	--infenite cannon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,79029177+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c79029177.iccost)
	e2:SetOperation(c79029177.icop)
	c:RegisterEffect(e2)
	--change damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c79029177.con)
	e3:SetTargetRange(1,0)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--send to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCountLimit(1)
	e5:SetCost(c79029177.tgcost)
	e5:SetTarget(c79029177.tgtg)
	e5:SetOperation(c79029177.tgop)
	c:RegisterEffect(e5) 
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e7) 
end
function c79029177.sprfilter(c)
	return c:IsFaceup()
end
function c79029177.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return not c:IsType(TYPE_TUNER) and g:IsExists(c79029177.sprfilter2,3,c,tp,c,sc) and g:Filter(c79029177.sprfilter2,nil):GetSum(Card.GetLevel)-lv==9
end
function c79029177.sprfilter2(c,tp,g,sc)
	return c:IsType(TYPE_TUNER) 
end
function c79029177.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029177.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029177.sprfilter1,1,nil,tp,g,c)
end
function c79029177.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029177.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c79029177.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c79029177.sprfilter2,3,3,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then 
	Debug.Message("毁灭，终将来临！")
end
end
function c79029177.iccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return lp>1 end
	Duel.PayLPCost(tp,lp-1)
end
function c79029177.icop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.CreateToken(tp,66957584)
	local b=Duel.CreateToken(tp,66957584)
	local c=Duel.CreateToken(tp,66957584)
	local g=Group.CreateGroup()
	g:AddCard(a)
	g:AddCard(b)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c79029177.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c79029177.fil(c)
	return c:IsCode(66957584) and c:IsAbleToRemoveAsCost()
end
function c79029177.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029177.fil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029177.fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029177.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c79029177.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RULE)
end
