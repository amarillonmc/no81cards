--罗德岛·狙击干员-奥斯塔
function c79029340.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),2,2,true) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCost(c79029340.atcost)
	e1:SetOperation(c79029340.atop)
	c:RegisterEffect(e1)	
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029340,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c79029340.cttg)
	e1:SetOperation(c79029340.ctop)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029340,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c79029340.cocon)
	e2:SetOperation(c79029340.coop)
	c:RegisterEffect(e2)
end
function c79029340.atfil(c)
	return c:IsAbleToExtraAsCost() and c:IsType(TYPE_LINK)
end
function c79029340.atcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029340.atfil,tp,LOCATION_GRAVE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c79029340.atfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
	e:SetLabel(tc:GetLink())
end
function c79029340.atop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("全都要解决掉吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029340,2))
	local x=e:GetLabel()
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(x*1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(x)
	c:RegisterEffect(e2)
end
function c79029340.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1099,1) end
	Debug.Message("你好。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029340,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1041,1)
	Duel.SetTargetCard(g)
end
function c79029340.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:AddCounter(0x1099,1) 
end
function c79029340.cofil(c)
	return c:GetCounter(0x1099)~=0 and c:GetAttack()~=0
end
function c79029340.cocon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c79029340.cofil,tp,0,LOCATION_MZONE,1,nil)
end
function c79029340.coop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("该结束了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029340,6))
	local cg=Duel.GetMatchingGroup(c79029340.cofil,tp,0,LOCATION_MZONE,nil)
	local atk=cg:GetSum(Card.GetAttack)
	if Duel.CheckLPCost(1-tp,atk) then
	Duel.PayLPCost(1-tp,atk)
	Debug.Message("啧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029340,4))
	else
	Debug.Message("再见。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029340,5))
	Duel.SendtoGrave(cg,REASON_EFFECT+REASON_RULE)
	end
end













