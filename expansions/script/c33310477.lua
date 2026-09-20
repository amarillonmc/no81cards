--幻指塑兽 狼面
--c33310477
local s,id=GetID()
s.VHisc_HUANZHI=true

--自定义指示物
local COUNTER_BLEED=0x356a    --流血指示物

function s.initial_effect(c)
	--连接召唤手续（包含「幻指」怪兽的效果怪兽2只以上）
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,2,99,s.lcheck)

	--①：有流血指示物放置的怪兽从场上离开的场合才能发动。把那些卡放置的流血指示物数量的流血指示物给对方场上的1只怪兽放置。
	--（离场前的时点读取并记录指示物数量：EVENT_LEAVE_FIELD 时卡已离开场上、指示物已被取除，无法再读取）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(s.lvpreop)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(e0)
	e1:SetCondition(s.lvcon)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)

	--②：自己·对方受到战斗·效果伤害的场合才能发动。墓地的这张卡特殊召唤，选对方场上1只怪兽放置3个流血指示物。因为这个效果特殊召唤的这张卡从场上离开的场合除外。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--③：这张卡和对方怪兽进行战斗的伤害计算时才能发动。这张卡的攻击力直到回合结束时上升那只对方怪兽上放置的流血指示物数量×500。有3个以上流血指示物放置的场合，这次战斗阶段中，这张卡只再1次可以攻击。
	--（「伤害计算时」的官方标准写法：EVENT_PRE_DAMAGE_CALCULATE 的 QUICK_O。
	--  不可用 EVENT_FREE_CHAIN+SetHintTiming：自由连锁类效果在没有 EFFECT_FLAG_DAMAGE_STEP 时不会在伤害步骤提供发动窗口）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetCountLimit(1)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end

--============================
--连接素材：包含「幻指」怪兽的效果怪兽2只以上
--============================
function s.matfilter(c)
	return c:IsType(TYPE_EFFECT)
end

function s.hzfilter(c)
	return c.VHisc_HUANZHI
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.hzfilter,1,nil)
end

--============================
--【①】
--============================
--可放置流血指示物的对方怪兽
function s.cntfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_BLEED,1)
end

--离场前的记录：合计「有流血指示物放置的怪兽」上放置的流血指示物数量
function s.lvpreop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:GetCounter(COUNTER_BLEED)>0 then
			ct=ct+tc:GetCounter(COUNTER_BLEED)
		end
		tc=eg:GetNext()
	end
	e:SetLabel(ct)
end

function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>0
end

function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then
		return ct>0 and Duel.IsExistingMatchingCard(s.cntfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,COUNTER_BLEED)
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(s.cntfilter,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.HintSelection(sg)
		sc:AddCounter(COUNTER_BLEED,ct)
	end
end

--============================
--【②】
--============================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>0 and (r&(REASON_BATTLE+REASON_EFFECT))~=0
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,COUNTER_BLEED)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	--因为这个效果特殊召唤的这张卡从场上离开的场合除外
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
	--选对方场上1只怪兽放置3个流血指示物
	if not Duel.IsExistingMatchingCard(s.cntfilter,tp,0,LOCATION_MZONE,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g=Duel.SelectMatchingCard(tp,s.cntfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		tc:AddCounter(COUNTER_BLEED,3)
	end
end

--============================
--【③】
--============================
--「这张卡和对方怪兽进行战斗的伤害计算时」：条件只看战斗对象（与官方 EMクレイブレイカー/リヴェンデット・スレイヤー 同型）
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc~=nil and bc:IsRelateToBattle()
		and bc:IsControler(1-tp) and bc:GetCounter(COUNTER_BLEED)>0
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local bc=c:GetBattleTarget()
	if not bc then return end
	local ct=bc:GetCounter(COUNTER_BLEED)
	if ct<=0 then return end
	--攻击力直到回合结束时上升那个数量×500
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--有3个以上流血指示物放置的场合，这次战斗阶段中，这张卡只再1次可以攻击
	if ct>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
	end
end
