--萨尔贡·术士干员-蜜蜡
function c79029443.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)		
	 --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029443.efilter)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029443)
	e2:SetCost(c79029443.smcost)
	e2:SetTarget(c79029443.smtg)
	e2:SetOperation(c79029443.smop)  
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19029443)
	e3:SetCondition(c79029443.discon)
	e3:SetCost(c79029443.discost)
	e3:SetTarget(c79029443.distg)
	e3:SetOperation(c79029443.disop)
	c:RegisterEffect(e3)
end
function c79029443.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c79029443.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c79029443.smfil(c)
	return c:IsSummonableCard() and c:IsSetCard(0xa900)
end
function c79029443.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029443.smfil,tp,LOCATION_HAND,0,1,nil) end
end
function c79029443.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029443.smfil,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029443,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetTargetRange(POS_FACEUP_ATTACK,1)
	e3:SetCondition(c79029443.ttcon2)
	e3:SetOperation(c79029443.ttop2)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	tc:RegisterEffect(e3)
	Debug.Message("此即为神灵之祝福。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029443,1))	 
end
function c79029443.ttcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg,1-tp)
end
function c79029443.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	Debug.Message("那么，我们出发吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029443,2))	 
	e:Reset()
end
function c79029443.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029443.rlfil(c,e,tp)
	return c:IsReleasable() and c:GetOwner()==tp
end
function c79029443.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029443.rlfil,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029443.rlfil,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c79029443.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029443.disop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("希望他们，也能够得到祝福......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029443,3))	
	Duel.NegateActivation(ev)
end









