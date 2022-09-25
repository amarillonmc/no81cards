--深空 炎神 弗雷姆
function c72101204.initial_effect(c)
	c:SetUniqueOnField(1,1,72101204)
	--summon rlue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101204,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c72101204.tzcon)
	e1:SetOperation(c72101204.tzop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c72101204.setcon)
	c:RegisterEffect(e2)

	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c72101204.splimit)
	c:RegisterEffect(e3)

	--check back and gain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72101204,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c72101204.cbtg)
	e4:SetOperation(c72101204.cbop)
	c:RegisterEffect(e4)
	
	-- H!
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(72101204,2))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE,0)
	e5:SetCost(c72101204.hcost)
	e5:SetTarget(c72101204.htg)
	e5:SetOperation(c72101204.hop)
	c:RegisterEffect(e5)

	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(72101204,3))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c72101204.negcon)
	e6:SetCost(c72101204.hcost)
	e6:SetTarget(aux.nbtg)
	e6:SetOperation(c72101204.negop)
	c:RegisterEffect(e6)

	--changdi zhaohuan bubei wuxiao
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c72101204.cdval)
	c:RegisterEffect(e9)
	--changdi zhaohuan buneng fadong
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	e10:SetCondition(c72101204.cdcon)
	e10:SetOperation(c72101204.cdop)
	c:RegisterEffect(e10)

end

--Summon rule
function c72101204.tzcon(e,c,minc)
	if c==nil then return true 
	end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c72101204.tzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c72101204.setcon(e,c,minc)
	if not c then return true 
	end
	return false
end

--cannot special summon
function c72101204.splimit(e,se,sp,st)
	return Duel.IsPlayerAffectedByEffect(sp,72101204) and st&SUMMON_VALUE_MONSTER_REBORN>0
		and e:GetHandler():IsControler(sp) and e:GetHandler():IsLocation(LOCATION_GRAVE)
end

--check back and gain attack
function c72101204.cbfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c72101204.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101204.cbfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c72101204.cbfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c72101204.cbop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72101204.cbfilter,tp,0,LOCATION_MZONE,nil)
	local gt=g:GetCount()
	local a=Duel.SelectMatchingCard(tp,c72101204.cbfilter,tp,0,LOCATION_MZONE,1,gt,nil)
	local at=a:GetCount()
	if at>0 then
		Duel.SendtoDeck(a,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(at*1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e1,tp)
end

-- H!
function c72101204.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_COST)
end
function c72101204.htg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c72101204.hop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetCounter(0,1,1,0x7210)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

--negate
function c72101204.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not re:GetHandler():IsCode(72101204) and Duel.IsChainNegatable(ev)
end
function c72101204.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--changdi zhaohuan bubei wuxiao
function c72101204.cdval(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
--changdi zhaohuan chenggong bufadong
function c72101204.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
function c72101204.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler():IsSetCard(0xcea)
			end
end
function c72101204.cdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c72101204.genchainlm(e:GetHandler()))
end