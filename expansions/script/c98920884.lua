--正义盟军 救世虫
-- 自定义同调怪兽
local s,id,o=GetID()
function s.initial_effect(c)
	-- 同调召唤手续：暗属性调整 + 调整以外的怪兽1只以上
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()

	-- 效果1：同调召唤的场合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	-- 效果2：被破坏的场合检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

-- 效果1条件：同调召唤
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

-- 效果1用：种类判断
local ex_types={TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}
function s.e1filter(c,e)
	if not c:IsCanBeEffectTarget(e) then return false end
	for _,typ in ipairs(ex_types) do
		if c:IsType(typ) then return true end
	end
	return false
end

-- 检查当前组合是否满足“种类各不相同”
function s.e1check(sg,e,tp,mg)
	local ct=0
	for _,typ in ipairs(ex_types) do
		if sg:IsExists(Card.IsType,1,nil,typ) then
			ct=ct+1
		end
	end
	return ct==#sg -- 如果种类数等于卡片数，说明没有重复种类
end

-- 效果1对象选择
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.e1filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	if chk==0 then return g:GetCount()>0 end
	local sg=g:SelectSubGroup(tp,s.e1check,false,1,6)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end

-- 效果1处理
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if #tg>0 then
		local ct=Duel.Destroy(tg,REASON_EFFECT)
		if ct>0 then
			-- 2只以下
			if ct<=2 then
				Duel.BreakEffect()
				Duel.SetLP(tp,Duel.GetLP(tp)-2000)
			end
			-- 4只以上
			if ct>=4 and c:IsRelateToEffect(e) and c:IsFaceup() then
				Duel.BreakEffect()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetTargetRange(0,0xff)
				e1:SetValue(LOCATION_REMOVED)
				e1:SetTarget(s.rmtg)
				c:RegisterEffect(e1)
				-- 增加特效提示
				c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2)) 
			end
		end
	end
end
function s.rmtg(e,c)
	return c:GetOwner()==1-e:GetHandlerPlayer()
end

-- 效果2条件：场上·墓地有机械族·暗属性·10星的同调怪兽
function s.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(10) and c:IsType(TYPE_SYNCHRO) 
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end

-- 效果2检索过滤
function s.thfilter(c)
	return c:IsLevel(11) and c:IsAbleToHand()
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果2处理
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
