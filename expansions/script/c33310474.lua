--幻指塑兽 述血
--c33310474
local s,id=GetID()
s.VHisc_HUANZHI=true
local CARD_SAKUSEI=33310479

--自定义指示物
local COUNTER_BLEED=0x356a    --流血指示物
local COUNTER_INSPIRE=0x556a  --灵感指示物

function s.initial_effect(c)
	--灵摆化（灵摆区域放置、灵摆召唤等）
	aux.EnablePendulumAttribute(c)

	--【灵摆】①：1回合1次，把自己场上1个灵感指示物取除才能发动。这张卡特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.pspcost)
	e1:SetTarget(s.psptg)
	e1:SetOperation(s.pspop)
	c:RegisterEffect(e1)

	--【灵摆】②：每次对方场上的怪兽进行战斗的攻击宣言时，那只怪兽的攻击力下降流血指示物数量×100，并给与对方相同数值的伤害
	--不入连锁直接适用的永续效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	--【灵摆】②：对方场上的怪兽发动的效果处理时同样适用（不入连锁直接适用）
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(s.chainop)
	c:RegisterEffect(e3)

	--【怪兽】①●：从卡组·墓地把1张「幻指作成」在场地区域表侧表示放置
	--「以下效果1回合各能选择1次」→ 两个选项拆成两个效果对象，各自用SetCountLimit（发动时计数）
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SSET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_END_PHASE)
	e4:SetCountLimit(1,id+10)
	e4:SetTarget(s.placetg)
	e4:SetOperation(s.placeop)
	c:RegisterEffect(e4)

	--【怪兽】①●：选场上1只怪兽放置3个流血指示物。那之后，可以把自己场上1个灵感指示物取除，让那只怪兽的效果无效化
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_END_PHASE)
	e5:SetCountLimit(1,id+20)
	e5:SetTarget(s.cntg)
	e5:SetOperation(s.cnop)
	c:RegisterEffect(e5)

	--【怪兽】②：自己·对方受到效果伤害的场合才能发动。额外卡组表侧表示的这张卡在灵摆区域放置或加入手卡。
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,6))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.extcon)
	e6:SetTarget(s.exttg)
	e6:SetOperation(s.extop)
	c:RegisterEffect(e6)
end

--============================
--【灵摆】①
--============================
function s.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,COUNTER_INSPIRE,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,COUNTER_INSPIRE,1,REASON_COST)
end

function s.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_PZONE)
end

function s.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--============================
--【灵摆】②
--============================
--下降攻击力并给与对方相同数值的伤害
function s.bleedop(e,tp,tc)
	if not tc or not tc:IsFaceup() then return end
	local ct=tc:GetCounter(COUNTER_BLEED)
	if ct<=0 then return end
	local val=ct*100
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.Damage(1-tp,val,REASON_EFFECT)
end

--攻击宣言（不入连锁，直接适用）
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc or not tc:IsControler(1-tp) then return end
	s.bleedop(e,tp,tc)
end

--发动的效果处理时（不入连锁，直接适用）
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	if not re or not re:IsActiveType(TYPE_MONSTER) then return end
	local rc=re:GetHandler()
	if not rc or not rc:IsFaceup() or not rc:IsLocation(LOCATION_MZONE) or not rc:IsControler(1-tp) then return end
	s.bleedop(e,tp,rc)
end

--============================
--【怪兽】①
--============================
--●从卡组·墓地把1张「幻指作成」在场地区域表侧表示放置
function s.placefilter(c,tp)
	return c:IsCode(CARD_SAKUSEI) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function s.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.placefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
end

function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.placefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	--场地区域已有卡时先按规则送去墓地，再表侧表示放置
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end

--●选场上1只怪兽放置3个流血指示物。那之后，可以把自己场上1个灵感指示物取除，让那只怪兽的效果无效化
function s.cnfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_BLEED,3)
end

function s.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,COUNTER_BLEED)
end

function s.cnop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.cnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	if not tc:AddCounter(COUNTER_BLEED,3) then return end
	--那之后，可以把自己场上1个灵感指示物取除，让那只怪兽的效果无效化
	if not Duel.IsCanRemoveCounter(tp,1,0,COUNTER_INSPIRE,1,REASON_EFFECT) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
	Duel.RemoveCounter(tp,1,0,COUNTER_INSPIRE,1,REASON_EFFECT)
	Duel.BreakEffect()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end

--============================
--【怪兽】②
--============================
function s.extcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>0 and (r&REASON_EFFECT)~=0 and e:GetHandler():IsFaceup()
end

function s.exttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsFaceup() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) or c:IsAbleToHand())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_EXTRA)
end

function s.extop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=c:IsAbleToHand()
	if b1 and b2 then
		if Duel.SelectOption(tp,aux.Stringid(id,7),aux.Stringid(id,8))==0 then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SendtoHand(c,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	elseif b1 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	elseif b2 then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
	end
end
