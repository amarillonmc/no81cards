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
--盖放过滤器：本家通常陷阱
function s.setfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_TRAP) and c:GetType()==TYPE_TRAP and c:IsSSetable()
end

--特召过滤器：本家怪兽
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--Cost过滤器：展示手卡S/T，并检查对应效果是否可执行
function s.rvfilter(c,tp,e)
	if not (c:IsSetCard(0x611) and not c:IsPublic()) then return false end
	
	--展示魔法 -> 盖陷阱 (检查卡组是否有陷阱 & S区是否有空位)
	if c:IsType(TYPE_SPELL) then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
			
	--展示陷阱 -> 特召 (检查墓地/除外是否有怪兽 & M区是否有空位)
	--因为是Cost阶段，必须预判是否有Target
	elseif c:IsType(TYPE_TRAP) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),e,tp)
	end
	return false
end

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() 
		and Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil,tp,e) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil,tp,e)
	Duel.ConfirmCards(1-tp,g)
	local rc=g:GetFirst()
	
	--设置Label：1=魔法分支，2=陷阱分支
	if rc:IsType(TYPE_SPELL) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	
	Duel.Release(c,REASON_COST)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local label=e:GetLabel()
	
	--分支：陷阱卡展示 (苏生) - 需要取对象
	if label==2 then
		if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		
	--分支：魔法卡展示 (盖放) - 不取对象
	else
		if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
		e:SetCategory(0)
		e:SetProperty(0) --清除取对象属性
	end
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	
	--分支：魔法卡 (盖放陷阱)
	if label==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)>0 then
			--在盖放的回合也能发动
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		
	--分支：陷阱卡 (特召怪兽)
	else
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end