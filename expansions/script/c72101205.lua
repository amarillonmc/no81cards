--深空 风神 温迪
function c72101205.initial_effect(c)
	c:SetUniqueOnField(1,1,72101205)

	--summon rlue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101205,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c72101205.tzcon)
	e1:SetOperation(c72101205.tzop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c72101205.setcon)
	c:RegisterEffect(e2)

	--wind
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101205,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c72101205.wtar)
	e3:SetOperation(c72101205.wop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)

	--change effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(72101205,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c72101205.cecondition)
	e5:SetCost(c72101205.cecost)
	e5:SetTarget(c72101205.cetarget)
	e5:SetOperation(c72101205.ceoperation)
	c:RegisterEffect(e5)

	--Untargetable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c72101205.immtg)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--Indes
	local e7=e2:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(aux.indoval)
	c:RegisterEffect(e7)

	--to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(72101205,3))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetCondition(c72101205.tgcon)
	e8:SetTarget(c72101205.tgtg)
	e8:SetOperation(c72101205.tgop)
	c:RegisterEffect(e8)

	--changdi zhaohuan bubei wuxiao
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c72101205.cdval)
	c:RegisterEffect(e9)
	--changdi zhaohuan buneng fadong
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	e10:SetCondition(c72101205.cdcon)
	e10:SetOperation(c72101205.cdop)
	c:RegisterEffect(e10)

end

--Summon rule
function c72101205.tzcon(e,c,minc)
	if c==nil then return true 
	end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c72101205.tzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c72101205.setcon(e,c,minc)
	if not c then return true 
	end
	return false
end

--wind
function c72101205.wtfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c72101205.wtar(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c72101205.wtfilter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c72101205.wfilter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c72101205.wofilter(c)
	return c:IsCode(72101205)
end
function c72101205.wop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c72101205.wtfilter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then

		local tc=Duel.SelectMatchingCard(tp,c72101205.wofilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		local sgc=sg:GetCount()
		tc:EnableCounterPermit(0x7210)
		tc:AddCounter(0x7210,sgc,true)
	end
end

--change effect
function c72101205.thfilter(c)
	return c:IsAbleToDeck()
end
function c72101205.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c72101205.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c72101205.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(nil,1-tp,0,LOCATION_MZONE,1,nil)
	and Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_EFFECT)
end
function c72101205.cecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_COST)
end
function c72101205.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101205.thfilter,rp,LOCATION_MZONE,0,1,nil) end
end
function c72101205.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c72101205.repop)
end

--Untargetable
function c72101205.immtg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DIVINE)
end

--to grave
function c72101205.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c72101205.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c72101205.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

--changdi zhaohuan bubei wuxiao
function c72101205.cdval(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
--changdi zhaohuan chenggong bufadong
function c72101205.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
function c72101205.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler():IsSetCard(0xcea)
			end
end
function c72101205.cdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c72101205.genchainlm(e:GetHandler()))
end
