--变化形兽 三元麒麟
local s,id,o=GetID()
local SET_METAFORM=0x9D71

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),2,2)

	--全局记录：自己的融合怪兽在主要阶段从场上离开
	if not s.global_check then
		s.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_LEAVE_FIELD)
		ge:SetOperation(s.checkop)
		Duel.RegisterEffect(ge,0)
	end

	--① 特殊召唤成功：丢1手，从卡组选1只「化形兽」灵摆怪兽加入手卡或特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thspcost)
	e1:SetTarget(s.thsptg)
	e1:SetOperation(s.thspop)
	c:RegisterEffect(e1)

	--② 通常起动效果：解放自身，额外表侧最多2只「化形兽」灵摆怪兽放置到灵摆区
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	--e2:SetCategory(CATEGORY_TOFIELD)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.pzigncon)
	e2:SetCost(s.pzcost)
	e2:SetTarget(s.pztg)
	e2:SetOperation(s.pzop)
	c:RegisterEffect(e2)

	--② 条件满足时变成快速效果，双方回合都能发动
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCondition(s.pzqcon)
	c:RegisterEffect(e3)
end

--==============================
-- 记录：自己的融合怪兽在主要阶段从场上离开
--==============================
function s.leftfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:GetPreviousTypeOnField()&TYPE_FUSION)~=0
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_MAIN1 and ph~=PHASE_MAIN2 then return end
	for p=0,1 do
		if eg:IsExists(s.leftfilter,1,nil,p) then
			Duel.RegisterFlagEffect(p,id+100,RESET_PHASE+ph,0,1)
		end
	end
end

--==============================
-- ① 从卡组加入手卡或特殊召唤
--==============================
function s.thspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function s.deckfilter(c,e,tp)
	return c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_MONSTER)
		and c:IsType(TYPE_PENDULUM)
		and (
			c:IsAbleToHand()
			or (
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			)
		)
end

function s.thsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.deckfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.thspop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.deckfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end

	local b1=tc:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)

	if not b1 and not b2 then return end

	local op
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif b1 then
		op=0
	else
		op=1
	end

	if op==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--==============================
-- ② 解放自身，额外表侧最多2只放置到灵摆区
--==============================
function s.can_quick_pz(tp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and Duel.GetFlagEffect(tp,id+100)>0
end

function s.pzigncon(e,tp,eg,ep,ev,re,r,rp)
	--快速条件成立时隐藏起动版，避免自己回合同时出现两个同名效果
	return not s.can_quick_pz(tp)
end

function s.pzqcon(e,tp,eg,ep,ev,re,r,rp)
	return s.can_quick_pz(tp)
end

function s.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function s.pzone_count(tp)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	return ct
end

function s.pzfilter(c)
	return c:IsFaceup()
		and c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_MONSTER)
		and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden()
end

function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=s.pzone_count(tp)
	if chk==0 then
		return ft>0
			and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	--Duel.SetOperationInfo(0,CATEGORY_TOFIELD,nil,1,tp,LOCATION_EXTRA)
end

function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local ft=s.pzone_count(tp)
	if ft<=0 then return end

	local g=Duel.GetMatchingGroup(s.pzfilter,tp,LOCATION_EXTRA,0,nil)
	if #g==0 then return end

	local maxct=math.min(2,ft,#g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=g:Select(tp,1,maxct,nil)

	local tc=sg:GetFirst()
	while tc do
		if s.pzone_count(tp)>0
			and tc:IsFaceup()
			and not tc:IsForbidden() then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		tc=sg:GetNext()
	end
end
