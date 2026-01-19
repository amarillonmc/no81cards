--女神之令-摩阿
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,6100138)
	--①：仪式召唤成功检索 & 仪式怪兽取对象抗性
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：二速解放（展示魔法盖陷阱 / 展示陷阱特召怪兽）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

--------------------------------------------------------------------------------
-- ①效果
--------------------------------------------------------------------------------

--检索过滤：同名卡不在自己的场上·墓地存在
function s.thfilter(c,tp)
	return c:IsSetCard(0x611) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	
	--赋予抗性：这个回合，对方不能把自己场上的仪式怪兽作为效果的对象
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--添加提示
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

--------------------------------------------------------------------------------
-- ②效果
--------------------------------------------------------------------------------
function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

--过滤器：手卡本家魔法
function s.rvspell(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
--过滤器：卡组本家通常陷阱
function s.setfilter(c)
	--IsType(TYPE_TRAP)且GetType()==TYPE_TRAP即为通常陷阱（排除永续/反击）
	return c:IsSetCard(0x611) and c:IsType(TYPE_TRAP) and c:GetType()==TYPE_TRAP and c:IsSSetable()
end

--过滤器：手卡本家陷阱
function s.rvtrap(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_TRAP) and not c:IsPublic()
end
--过滤器：墓地其他本家怪兽
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x611) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	--Cost支付后，检查是否满足效果条件
	local b1 = Duel.IsExistingMatchingCard(s.rvspell,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		
	local b2 = Duel.IsExistingMatchingCard(s.rvtrap,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		--盖放通常不设Category，除非涉及墓地
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	
	--选项1：展示魔法，盖通常陷阱
	if op==0 then
		--在效果处理时进行展示
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g1=Duel.SelectMatchingCard(tp,s.rvspell,tp,LOCATION_HAND,0,1,1,nil)
		if #g1>0 then
			Duel.ConfirmCards(1-tp,g1)
			Duel.ShuffleHand(tp)
			
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g2=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g2:GetFirst()
			if tc and Duel.SSet(tp,tc)>0 then
				--盖放的回合也能发动
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
		
	--选项2：展示陷阱，特召墓地怪兽
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g1=Duel.SelectMatchingCard(tp,s.rvtrap,tp,LOCATION_HAND,0,1,1,nil)
		if #g1>0 then
			Duel.ConfirmCards(1-tp,g1)
			Duel.ShuffleHand(tp)
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #g2>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end