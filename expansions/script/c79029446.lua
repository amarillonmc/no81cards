--黑钢国际·干员组合-雷蛇＆芙兰卡
function c79029446.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c79029446.matfilter1,c79029446.matfilter1,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),5,99)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	 --
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c79029446.efilter)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029446,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029446.discon)
	e3:SetCost(c79029446.discost)
	e3:SetTarget(c79029446.distg)
	e3:SetOperation(c79029446.disop)
	c:RegisterEffect(e3)
	--SpecialSummon cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_ONFIELD)
	e4:SetCost(c79029446.ctcost)
	e4:SetOperation(c79029446.ctop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(c79029446.sptg)
	e5:SetOperation(c79029446.spop)
	c:RegisterEffect(e5)
end
function c79029446.ctcost(e,c,tp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)==0 then 
	return false
	else
	return Duel.GetExtraTopGroup(tp,1):GetFirst():IsAbleToRemoveAsCost()
	end
end
function c79029446.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetExtraTopGroup(tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	Debug.Message("时间有限。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,3))
end
function c79029446.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) and c:IsSynchroType(TYPE_SYNCHRO) and (c:GetSequence()==5 or c:GetSequence()==6)
end
function c79029446.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029446.ctfil(c)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_TRAP) and c:IsAbleToDeckAsCost()
end
function c79029446.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029446.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Debug.Message("充能！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,2))
	local g=Duel.SelectMatchingCard(tp,c79029446.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Debug.Message("烧起来吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,1))
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c79029446.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029446.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("闪电风暴。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,0))
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c79029446.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c79029446.spfil(c,e,tp)
	return c:IsSetCard(0x1904) and (c:IsLevelAbove(7) or c:IsRankAbove(7)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,nil)>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c79029446.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029446.spfil,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Debug.Message("在这种地方沮丧又有什么用？立刻撤退。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,4))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
end
function c79029446.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029446.spfil,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	if tc:IsCode(79029044,79029437) then  
	Debug.Message("没时间犹豫了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,6))
	elseif tc:IsCode(79029043,79029138,79029441) then  
	Debug.Message("救护班和伤员一起撤退！能战斗的人和我一起阻挡敌人!")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,7))
	else
	Debug.Message("这算什么，我和芙兰卡可经历过更惨烈的战斗。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029446,5))
	end
	end
end

















