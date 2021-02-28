--后巴别塔·狙击干员-蓝毒
function c79029427.initial_effect(c)
	c:EnableCounterPermit(0x11,LOCATION_PZONE)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit() 
	aux.EnablePendulumAttribute(c,false)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c79029427.splimit1)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029427.discon)
	e1:SetTarget(c79029427.distg)
	e1:SetOperation(c79029427.disop)
	c:RegisterEffect(e1) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetLabelObject(c)
	e2:SetValue(c79029427.slevel)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c79029427.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SYNCHRO_LEVEL)
	e4:SetLabelObject(c)
	e4:SetValue(c79029427.slevel1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c79029427.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_SYNCHRO_LEVEL)
	e10:SetLabelObject(c)
	e10:SetValue(c79029427.slevel2)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e11:SetRange(LOCATION_EXTRA)
	e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e11:SetTarget(c79029427.eftg)
	e11:SetLabelObject(e4)
	c:RegisterEffect(e11)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetTarget(c79029427.pentg)
	e6:SetOperation(c79029427.penop)
	c:RegisterEffect(e6)   
	--activate cost
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_ACTIVATE_COST)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetCost(c79029427.costchk)
	e7:SetOperation(c79029427.costop)
	c:RegisterEffect(e7)
	--accumulate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(0x10000000+79029427)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	c:RegisterEffect(e7)
	--counter
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1,79029427)
	e8:SetCost(c79029427.ctcost)
	e8:SetOperation(c79029427.ctop)
	c:RegisterEffect(e8)
	--win
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_PZONE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetOperation(c79029427.winop)
	c:RegisterEffect(e9)
end
c79029427.material_type=TYPE_SYNCHRO
function c79029427.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and not c:IsSetCard(0xca3)
end
function c79029427.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c79029427.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c79029427.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029427.disfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029427.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c79029427.disfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
	Debug.Message("毒吻。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029427,0))
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c79029427.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:GetOriginalCode()==79029427 then
	return 5*65536+lv
	else
	return lv
	end
end
function c79029427.slevel1(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:GetOriginalCode()==79029427 then
	return 2*65536+lv
	else
	return lv
	end
end
function c79029427.slevel2(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:GetOriginalCode()==79029427 then
	return 4*65536+lv
	else
	return lv
	end
end
function c79029427.eftg(e,c)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsSynchroType(TYPE_PENDULUM)
end
function c79029427.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029427.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("适当的休息，也是为了工作更有状态哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029427,3))
	end
end
function c79029427.ckfil(c)
	return c:IsSetCard(0xca3) and c:IsFaceup()
end
function c79029427.costchk(e,te_or_c,tp)
	local x=Duel.GetMatchingGroupCount(c79029427.ckfil,tp,LOCATION_EXTRA,0,nil)
	local ct=Duel.GetFlagEffect(tp,79029427)
	return Duel.CheckLPCost(tp,ct*500*x)
end
function c79029427.costop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetMatchingGroupCount(c79029427.ckfil,tp,LOCATION_EXTRA,0,nil)
	Debug.Message("真是可笑的战斗，就像“毒物”被自己毒死一样......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029427,4))
	Duel.PayLPCost(tp,500*x)
end
function c79029427.rlfil(c,e,tp)
	return c:IsReleasable() and c:GetOwner()~=tp 
end
function c79029427.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029427.rlfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029427.rlfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c79029427.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x11,1)
	if c:GetCounter(0x11)<3 then
	Debug.Message("这种毒素，将会慢慢侵蚀你的生命......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029427,1))
	end
end
function c79029427.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_BULEPOISON = 0x12
	local c=e:GetHandler()
	if c:GetCounter(0x11)==3 then
	Debug.Message("真是可笑的战斗，就像“毒物”被自己毒死一样......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029427,2))
		Duel.Win(tp,WIN_REASON_BULEPOISON)
	end
end






