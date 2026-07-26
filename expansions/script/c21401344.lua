--熔岩心底
local s,id,o=GetID()

local SET_LAVAL=0x39

--用于记录对方在当前主要阶段发动过怪兽效果
local FLAG_MAIN1=id+100
local FLAG_MAIN2=id+101

function s.initial_effect(c)
	--全局记录双方在主要阶段发动怪兽效果的情况
	if not s.global_check then
		s.global_check=true

		local ge=Effect.CreateEffect(c)
		ge:SetType(
			EFFECT_TYPE_FIELD
			+EFFECT_TYPE_CONTINUOUS
		)
		ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge:SetCode(EVENT_CHAINING)
		ge:SetOperation(s.handcheck)
		Duel.RegisterEffect(ge,0)
	end

	--①：主要阶段中，
	--自己场上现有的「熔岩」卡获得保护
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(
		0,
		TIMINGS_CHECK_MONSTER
		+TIMING_MAIN_END
	)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.actcon)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)

	--对方发动过怪兽效果的这个主要阶段，
	--这张卡可以从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)

	--②：除外墓地的这张卡，进行超量召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(
		0,
		TIMINGS_CHECK_MONSTER
		+TIMING_MAIN_END
	)
	e3:SetCountLimit(1,id+200)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end

s.listed_series={SET_LAVAL}

--从手卡发动的记录

function s.getphaseflag()
	local ph=Duel.GetCurrentPhase()

	if ph==PHASE_MAIN1 then
		return FLAG_MAIN1
	elseif ph==PHASE_MAIN2 then
		return FLAG_MAIN2
	end

	return 0
end

function s.handcheck(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()

	if ph~=PHASE_MAIN1
		and ph~=PHASE_MAIN2 then
		return
	end

	if not re:IsActiveType(TYPE_MONSTER) then
		return
	end

	local flag
	if ph==PHASE_MAIN1 then
		flag=FLAG_MAIN1
	else
		flag=FLAG_MAIN2
	end

	--怪兽效果由rp发动，
	--因此给其对方玩家登记手卡发动资格
	local p=1-rp

	if Duel.GetFlagEffect(p,flag)==0 then
		Duel.RegisterFlagEffect(
			p,
			flag,
			RESET_PHASE+ph,
			0,
			1
		)
	end
end

function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	local flag=s.getphaseflag()

	return flag~=0
		and Duel.GetFlagEffect(
			tp,
			flag
		)>0
end

--①

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()

	return ph==PHASE_MAIN1
		or ph==PHASE_MAIN2
end

--结算时要保护的、自己场上已经表侧存在的「熔岩」卡
function s.imfilter(c,e)
	return c:IsFaceup()
		and c:IsSetCard(SET_LAVAL)
		--防止这张陷阱自身如果也是「熔岩」卡时，
		--自己把自己算作发动条件
		and c~=e:GetHandler()
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.imfilter,
			tp,
			LOCATION_ONFIELD,
			0,
			1,
			nil,
			e
		)
	end
end

--不受对方发动的效果影响，
--但以这张被保护卡自身为对象的效果除外
function s.efilter(e,re)
	local c=e:GetHandler()
	local tp=e:GetLabel()

	--已经不在原本玩家场上时，不再适用
	if not c:IsControler(tp) then
		return false
	end

	if re:GetOwnerPlayer()==tp then
		return false
	end

	if not re:IsActivated() then
		return false
	end

	--对方发动的取对象效果，
	--如果确实以这张卡为对象，则不免疫
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(
			0,
			CHAININFO_TARGET_CARDS
		)
		if g and g:IsContains(c) then
			return false
		end
	end

	return true
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()

	--结算时必须仍然是主要阶段
	if ph~=PHASE_MAIN1
		and ph~=PHASE_MAIN2 then
		return
	end

	local g=Duel.GetMatchingGroup(
		s.imfilter,
		tp,
		LOCATION_ONFIELD,
		0,
		nil,
		e
	)

	if g:GetCount()==0 then
		return
	end

	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(
			e:GetHandler()
		)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetLabel(tp)
		e1:SetValue(s.efilter)
		e1:SetReset(
			RESET_EVENT
			+RESETS_STANDARD
			+RESET_PHASE
			+ph
		)
		tc:RegisterEffect(e1)

		tc=g:GetNext()
	end
end

--②

function s.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end

function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.xyzfilter,
			tp,
			LOCATION_EXTRA,
			0,
			1,
			nil
		)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		1,
		tp,
		LOCATION_EXTRA
	)
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(
		s.xyzfilter,
		tp,
		LOCATION_EXTRA,
		0,
		nil
	)

	if g:GetCount()==0 then
		return
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_SPSUMMON
	)

	local tc=g:Select(
		tp,
		1,
		1,
		nil
	):GetFirst()

	if not tc then
		return
	end

	Duel.XyzSummon(
		tp,
		tc,
		nil
	)
end
