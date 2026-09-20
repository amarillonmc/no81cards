--幻指绘彩 覆血
--c33310471
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

	--【灵摆】②：对方怪兽进行战斗的攻击宣言时，那只怪兽的攻击力下降流血指示物数量×100，并给与对方相同数值伤害
	--不入连锁直接适用的永续效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	--【灵摆】②：对方怪兽发动的效果处理时同样适用（不入连锁直接适用）
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(s.chainop)
	c:RegisterEffect(e3)

	--【怪兽】①：这张卡召唤·特殊召唤成功的场合，可以从以下效果选择1个发动（这个卡名的以下效果1回合各能选择1次）
	--单一效果对象＋选择菜单＝同一次召唤只能选择1个；
	--各选项的“1回合1次”在【发动时】登记（不是解决时），因此同名卡同时出场时不会在同一连锁上重复适用同一选项。
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,9))
	e4:SetCategory(CATEGORY_SSET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(s.sumtg)
	e4:SetOperation(s.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)

	--【怪兽】②：自己·对方受到效果伤害的场合才能发动。额外卡组表侧表示的这张卡在灵摆区域放置或加入手卡。
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,6))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_DAMAGE)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCountLimit(1,id)
	e8:SetCondition(s.extcon)
	e8:SetTarget(s.exttg)
	e8:SetOperation(s.extop)
	c:RegisterEffect(e8)
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

--●从卡组把1张「幻指」魔法·陷阱卡在自己场上盖放。那之后，可以取除1个灵感指示物，让这个效果盖放的速攻魔法·陷阱卡在盖放的回合也能发动
function s.setfilter(c)
	return c.VHisc_HUANZHI and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc or Duel.SSet(tp,tc)==0 then return end
	--那之后，可以取除1个灵感指示物，让盖放的速攻魔法·陷阱卡在盖放的回合也能发动
	if not Duel.IsCanRemoveCounter(tp,1,0,COUNTER_INSPIRE,1,REASON_EFFECT) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
	Duel.RemoveCounter(tp,1,0,COUNTER_INSPIRE,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,5))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	if tc:IsType(TYPE_QUICKPLAY) then
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e1)
	elseif tc:IsType(TYPE_TRAP) then
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e1)
	end
end

--「从以下效果选择1个发动」的统一处理
--b1/b2：该选项本回合还没用过，且现在可以使用
--★计数码：●1=id+10、●2=id+20（按卡名共享）
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id+10)==0
		and Duel.IsExistingMatchingCard(s.placefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(tp,id+20)==0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local opt
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		opt=0
	elseif b2 then
		opt=1
	else
		--同一连锁上的第2张同名卡（两个选项都已被使用）：不做任何处理
		e:SetLabel(2)
		return
	end
	e:SetLabel(opt)
	--关键：在【发动时】登记，而不是在解决时登记。
	--这样同名卡同时出场（同一连锁）时，后发动的卡在 chk==1 就会看到该选项已经用过，无法重复适用同一选项。
	--★登记码必须与上面的检查码一一对应：opt=0→id+10(●1)，opt=1→id+20(●2)。
	--  （此前写成 id+10+opt，opt=1 时会登记到 id+11，与 b2 检查的 id+20 不匹配，
	--   导致●2的次数形同虚设、同名卡在同一连锁上可重复适用●2。此处修正为 id+10+opt*10。）
	Duel.RegisterFlagEffect(tp,id+10+opt*10,RESET_PHASE+PHASE_END,0,1)
	if opt==1 then
		Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_DECK)
	end
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==0 then
		s.placeop(e,tp,eg,ep,ev,re,r,rp)
	elseif opt==1 then
		s.setop(e,tp,eg,ep,ev,re,r,rp)
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
