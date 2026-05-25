-- 炎磁斩光
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 给这张卡添加「神威·不落日」的卡名记述，方便其他系列卡识别
	aux.AddCodeList(c,60001312)
	
	-- 普通发动的效果
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	-- 卡组发动的效果，完全对齐奔星突烁的例子写法
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(cm.nilcost)
	e2:SetOperation(cm.nilactivate)
	c:RegisterEffect(e2)
end

-- 特殊召唤的过滤：神威·不落日
function cm.spfilter(c,e,tp)
	return c:GetCode()==60001312 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 普通发动的cost：注册flag，让卡组发动的效果可以识别这个连锁
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_CHAIN,0,1)
end

-- 卡组发动的cost：判断连锁上的flag，然后把卡从卡组移动到魔陷区
function cm.nilcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0 end
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_CHAIN,0,1)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	e:GetHandler():CreateEffectRelation(e)
end

-- 目标检查
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:CancelToGrave()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	
	-- 特殊召唤神威·不落日
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			-- 这个回合，神威·不落日不会被战斗·效果破坏
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(function(e,c) return aux.IsCodeListed(c,60001312) end)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			Duel.RegisterEffect(e2,tp)
		end
	end
end

-- 卡组发动的时候，发动时的效果不适用，所以operation是空的
function cm.nilactivate(e,tp,eg,ep,ev,re,r,rp)
end
