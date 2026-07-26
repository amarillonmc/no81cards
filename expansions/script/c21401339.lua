--熔岩谷侵略的入魔
local s,id,o=GetID()

local SET_LAVAL=0x39
local SET_LSWARM=0x0a
local FLAG_DESTROY_ONCE=id+100

function s.initial_effect(c)
	--自己场上只能有1张表侧表示存在
	c:SetUniqueOnField(1,0,id)

	--卡的发动：通常发动，不适用①
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(s.actcost)
	c:RegisterEffect(e0)

	--卡的发动：怪兽送去墓地时，可以发动并适用①
	local e0a=Effect.CreateEffect(c)
	e0a:SetDescription(aux.Stringid(id,0))
	e0a:SetCategory(CATEGORY_DESTROY)
	e0a:SetType(EFFECT_TYPE_ACTIVATE)
	e0a:SetCode(EVENT_TO_GRAVE)
	e0a:SetProperty(
		EFFECT_FLAG_CARD_TARGET
		+EFFECT_FLAG_DAMAGE_STEP
	)
	e0a:SetCondition(s.descon)
	e0a:SetCost(s.actdescost)
	e0a:SetTarget(s.destg)
	e0a:SetOperation(s.desop)
	c:RegisterEffect(e0a)

	--卡的发动：怪兽除外时，可以发动并适用①
	local e0b=e0a:Clone()
	e0b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e0b)

	--把「入魔」卡作为发动代价送墓的场合，可以从手卡发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.handcon)
	c:RegisterEffect(e1)

	--①：怪兽送去墓地时，破坏场上1张卡
	--伤害步骤也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(
		EFFECT_TYPE_FIELD
		+EFFECT_TYPE_TRIGGER_O
	)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(
		EFFECT_FLAG_CARD_TARGET
		+EFFECT_FLAG_DAMAGE_STEP
	)
	e2:SetCondition(s.descon)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)

	--①：怪兽除外时，和送墓时的效果共享次数
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2b)

	--②：「熔岩谷侵略的入魔」在自己场上只能有1张表侧表示存在，
	--自己不是超量怪兽不能从额外卡组特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	c:RegisterEffect(e3)

	--③：超量怪兽回到额外卡组
	--并当作超量召唤特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(
		CATEGORY_TODECK
		+CATEGORY_SPECIAL_SUMMON
	)
	e4:SetType(
		EFFECT_TYPE_SINGLE
		+EFFECT_TYPE_TRIGGER_O
	)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(
		EFFECT_FLAG_DELAY
		+EFFECT_FLAG_CARD_TARGET
	)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

s.listed_series={
	SET_LAVAL,
	SET_LSWARM
}

--卡的发动代价

function s.actcostfilter(c)
	return (
			c:IsSetCard(SET_LAVAL)
			or c:IsSetCard(SET_LSWARM)
		)
		and c:IsAbleToGraveAsCost()
end

function s.lswarmfilter(c)
	return c:IsSetCard(SET_LSWARM)
end

function s.checkactcost(tp,exc,handact)
	local hg=Duel.GetMatchingGroup(
		s.actcostfilter,
		tp,
		LOCATION_HAND,
		0,
		exc
	)
	local xg=Duel.GetMatchingGroup(
		s.actcostfilter,
		tp,
		LOCATION_EXTRA,
		0,
		nil
	)

	if hg:GetCount()==0
		or xg:GetCount()==0 then
		return false
	end

	return not handact
		or hg:IsExists(
			s.lswarmfilter,
			1,
			nil
		)
		or xg:IsExists(
			s.lswarmfilter,
			1,
			nil
		)
end

function s.handcon(e)
	local c=e:GetHandler()

	return s.checkactcost(
		e:GetHandlerPlayer(),
		c,
		true
	)
end

function s.handpickfilter(c,xg,handact)
	return s.actcostfilter(c)
		and (
			not handact
			or c:IsSetCard(SET_LSWARM)
			or xg:IsExists(
				s.lswarmfilter,
				1,
				nil
			)
		)
end

function s.extrapickfilter(c,needlswarm)
	return s.actcostfilter(c)
		and (
			not needlswarm
			or c:IsSetCard(SET_LSWARM)
		)
end

function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local handact=c:IsStatus(
		STATUS_ACT_FROM_HAND
	)

	if chk==0 then
		return s.checkactcost(
			tp,
			c,
			handact
		)
	end

	local xg=Duel.GetMatchingGroup(
		s.actcostfilter,
		tp,
		LOCATION_EXTRA,
		0,
		nil
	)

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TOGRAVE
	)
	local hg=Duel.SelectMatchingCard(
		tp,
		s.handpickfilter,
		tp,
		LOCATION_HAND,
		0,
		1,
		1,
		c,
		xg,
		handact
	)

	local hc=hg:GetFirst()
	if not hc then
		return
	end

	local needlswarm=
		handact
		and not hc:IsSetCard(SET_LSWARM)

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TOGRAVE
	)
	local egx=Duel.SelectMatchingCard(
		tp,
		s.extrapickfilter,
		tp,
		LOCATION_EXTRA,
		0,
		1,
		1,
		nil,
		needlswarm
	)

	if egx:GetCount()==0 then
		return
	end

	hg:Merge(egx)

	Duel.SendtoGrave(
		hg,
		REASON_COST
	)
end

--卡的发动时适用①：
--必须原本就在“怪兽送墓/除外时”的发动窗口，
--发动代价本身送墓不再让①成立
function s.actdescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.actcost(
				e,tp,eg,ep,ev,re,r,rp,0
			)
			and s.descost(
				e,tp,eg,ep,ev,re,r,rp,0
			)
	end

	s.actcost(
		e,tp,eg,ep,ev,re,r,rp,1
	)
	s.descost(
		e,tp,eg,ep,ev,re,r,rp,1
	)
end

--①

function s.desmonfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(
		s.desmonfilter,
		1,
		nil
	)
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		return c:GetFlagEffect(
			FLAG_DESTROY_ONCE
		)==0
	end

	c:RegisterFlagEffect(
		FLAG_DESTROY_ONCE,
		RESET_EVENT
			+RESETS_STANDARD
			+RESET_PHASE
			+PHASE_END,
		0,
		1
	)
end

function s.desfilter(c,e)
	return c:IsOnField()
		and c:IsDestructable()
		and c:IsCanBeEffectTarget(e)
end

function s.destg(
	e,tp,eg,ep,ev,re,r,rp,chk,chkc
)
	if chkc then
		return chkc:IsOnField()
			and s.desfilter(chkc,e)
	end

	if chk==0 then
		return Duel.IsExistingTarget(
			s.desfilter,
			tp,
			LOCATION_ONFIELD,
			LOCATION_ONFIELD,
			1,
			nil,
			e
		)
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_DESTROY
	)
	local g=Duel.SelectTarget(
		tp,
		s.desfilter,
		tp,
		LOCATION_ONFIELD,
		LOCATION_ONFIELD,
		1,
		1,
		nil,
		e
	)

	Duel.SetOperationInfo(
		0,
		CATEGORY_DESTROY,
		g,
		1,
		0,
		0
	)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()

	if tc
		and tc:IsRelateToEffect(e) then
		Duel.Destroy(
			tc,
			REASON_EFFECT
		)
	end
end

--②

function s.splimit(
	e,c,sump,sumtype,sumpos,targetp,se
)
	return c:IsLocation(LOCATION_EXTRA)
		and not c:IsType(TYPE_XYZ)
end

--③

function s.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)
		and (
			c:IsSetCard(SET_LAVAL)
			or c:IsSetCard(SET_LSWARM)
		)
		and not c:IsForbidden()
		and c:IsAbleToExtra()
		and c:IsCanBeEffectTarget(e)
end

function s.sptg(
	e,tp,eg,ep,ev,re,r,rp,chk,chkc
)
	local c=e:GetHandler()

	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(
				LOCATION_GRAVE
			)
			and aux.NecroValleyFilter(
				s.spfilter
			)(chkc,e,tp)
	end

	if chk==0 then
		return c:IsAbleToDeck()
			and not aux.NecroValleyNegateCheck(c)
			and Duel.GetLocationCountFromEx(
				tp,
				tp,
				nil,
				TYPE_XYZ
			)>0
			and Duel.IsExistingTarget(
				aux.NecroValleyFilter(
					s.spfilter
				),
				tp,
				LOCATION_GRAVE,
				0,
				1,
				nil,
				e,
				tp
			)
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TARGET
	)
	local g=Duel.SelectTarget(
		tp,
		aux.NecroValleyFilter(
			s.spfilter
		),
		tp,
		LOCATION_GRAVE,
		0,
		1,
		1,
		nil,
		e,
		tp
	)

	local dg=g:Clone()
	dg:AddCard(c)

	Duel.SetOperationInfo(
		0,
		CATEGORY_TODECK,
		dg,
		dg:GetCount(),
		tp,
		LOCATION_GRAVE
	)
	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		g,
		1,
		tp,
		LOCATION_EXTRA
	)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()

	if not tc
		or not tc:IsRelateToEffect(e)
		or not tc:IsLocation(
			LOCATION_GRAVE
		)
		or aux.NecroValleyNegateCheck(tc) then
		return
	end

	if Duel.SendtoDeck(
		tc,
		nil,
		SEQ_DECKSHUFFLE,
		REASON_EFFECT
	)==0
		or not tc:IsLocation(
			LOCATION_EXTRA
		) then
		return
	end

	Duel.BreakEffect()

	if Duel.GetLocationCountFromEx(
		tp,
		tp,
		nil,
		tc
	)<=0
		or not tc:IsCanBeSpecialSummoned(
			e,
			SUMMON_TYPE_XYZ,
			tp,
			false,
			false
		) then
		return
	end

	if Duel.SpecialSummon(
		tc,
		SUMMON_TYPE_XYZ,
		tp,
		tp,
		false,
		false,
		POS_FACEUP
	)==0 then
		return
	end

	tc:CompleteProcedure()

	Duel.BreakEffect()

	if c:IsRelateToEffect(e)
		and c:IsLocation(
			LOCATION_GRAVE
		)
		and c:IsAbleToDeck()
		and not aux.NecroValleyNegateCheck(c) then
		Duel.SendtoDeck(
			c,
			nil,
			SEQ_DECKSHUFFLE,
			REASON_EFFECT
		)
	end
end
