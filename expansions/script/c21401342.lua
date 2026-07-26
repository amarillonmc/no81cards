--熔岩谷的春风
local s,id,o=GetID()

function s.initial_effect(c)
	--①：卡的发动并检索「熔岩」怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：对方发动的怪兽效果处理时，
	--把那个效果变成“对方进行1只超量怪兽的超量召唤”
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(
		EFFECT_TYPE_FIELD
		+EFFECT_TYPE_CONTINUOUS
	)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.chcon)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)

	--③：作为超量素材被取除的场合，
	--这张卡回到手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(
		EFFECT_TYPE_SINGLE
		+EFFECT_TYPE_TRIGGER_O
	)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.retcon)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end

s.listed_series={0x39}

--①

function s.thfilter(c)
	return c:IsSetCard(0x39)
		and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.thfilter,
			tp,
			LOCATION_DECK,
			0,
			1,
			nil
		)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		nil,
		1,
		tp,
		LOCATION_DECK
	)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_ATOHAND
	)

	local g=Duel.SelectMatchingCard(
		tp,
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		1,
		1,
		nil
	)

	if g:GetCount()>0
		and Duel.SendtoHand(
			g,
			nil,
			REASON_EFFECT
		)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end

--②

--标准版YGOPro：
--当前可以进行超量召唤的额外卡组怪兽
function s.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end

function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=1-rp

	return rp==1-tp
		and re:IsActiveType(TYPE_MONSTER)
		and c:GetFlagEffect(id+100)==0
		and Duel.IsExistingMatchingCard(
			s.xyzfilter,
			p,
			LOCATION_EXTRA,
			0,
			1,
			nil
		)
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	if c:GetFlagEffect(id+100)>0 then
		return
	end

	--这里的p是“原本发动怪兽效果的玩家的对方”
	--也就是改写文本中的“对方”
	local p=1-rp

	if not Duel.IsExistingMatchingCard(
		s.xyzfilter,
		p,
		LOCATION_EXTRA,
		0,
		1,
		nil
	) then
		return
	end

	if not Duel.SelectYesNo(
		tp,
		aux.Stringid(id,1)
	) then
		return
	end

	--②这张表侧场地本回合已适用
	c:RegisterFlagEffect(
		id+100,
		RESET_EVENT
			+RESETS_STANDARD
			+RESET_PHASE
			+PHASE_END,
		0,
		1
	)

	--原效果不再处理原来的对象
	Duel.ChangeTargetCard(
		ev,
		Group.CreateGroup()
	)

	--把那个怪兽效果的处理改成：
	--“对方进行1只超量怪兽的超量召唤”
	Duel.ChangeChainOperation(
		ev,
		function(e,tp,eg,ep,ev,re,r,rp)
			s.xyzop(c,p)
		end
	)
end

function s.xyzop(c,tp)
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

	local xc=g:Select(
		tp,
		1,
		1,
		nil
	):GetFirst()

	if not xc then
		return
	end

	Duel.XyzSummon(
		tp,
		xc,
		nil
	)

	--超量召唤成功后破坏这张卡
	if not xc:IsLocation(LOCATION_MZONE)
		or not xc:IsSummonType(SUMMON_TYPE_XYZ) then
		return
	end

	Duel.BreakEffect()

	if c:IsFaceup()
		and c:IsLocation(LOCATION_SZONE) then
		Duel.Destroy(
			c,
			REASON_EFFECT
		)
	end
end

--③

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	return c:IsPreviousLocation(LOCATION_OVERLAY)
		and (
			c:IsReason(REASON_COST)
			or c:IsReason(REASON_EFFECT)
		)
end

function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		return c:IsAbleToHand()
			and not aux.NecroValleyNegateCheck(c)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		c,
		1,
		tp,
		LOCATION_GRAVE
	)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	if c:IsRelateToEffect(e)
		and c:IsLocation(LOCATION_GRAVE)
		and c:IsAbleToHand()
		and not aux.NecroValleyNegateCheck(c) then
		Duel.SendtoHand(
			c,
			nil,
			REASON_EFFECT
		)
	end
end
