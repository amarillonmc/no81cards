--罗德岛·特种干员-温蒂
function c79029210.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c79029210.ttcon)
	e1:SetOperation(c79029210.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c79029210.setcon)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3) 
	--to deck 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10406322,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c79029210.postg)
	e4:SetOperation(c79029210.posop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_TO_DECK)
	e5:SetCondition(c79029210.dacon)
	e5:SetOperation(c79029210.daop)
	c:RegisterEffect(e5)
	--token
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20368763,1))
	e6:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetOperation(c79029210.toop)
	c:RegisterEffect(e6)
end
function c79029210.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c79029210.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	Debug.Message("一切都跟战前预想的一样，开始作战！")
end
function c79029210.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c79029210.posfilter(c)
	return c:IsAbleToDeck()
end
function c79029210.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c79029210.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029210.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c79029210.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c79029210.chlimit)
end
function c79029210.chlimit(e,ep,tp)
	return tp==ep
end
function c79029210.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	Debug.Message("锁定敌人！攻击！")
end
function c79029210.dacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c79029210.daop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.ConfirmCards(tp,eg)
	local tc=g:GetFirst()   
	while tc do
	if tc:IsLocation(LOCATION_EXTRA) then
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	local seq=x-tc:GetSequence()
	Duel.Damage(1-tp,seq*300,REASON_EFFECT)
	tc=g:GetNext()
	else
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local seq=x-tc:GetSequence()
	Duel.Damage(1-tp,seq*300,REASON_EFFECT)
	tc=g:GetNext()
	Debug.Message("工程学的作用不可小觑！")
end
end
end
end
function c79029210.toop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,79029211,nil,nil,1500,0,1,RACE_CYBERSE,ATTRIBUTE_WATER) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(20368763,1)) then
	local x=Duel.CreateToken(tp,79029211)
	Duel.SpecialSummon(x,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("小叶，我们加油！")
end
end




