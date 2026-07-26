--熔岩谷紧握的大日
local s,id,o=GetID()

local SET_LAVAL=0x39
local SET_VYLON=0x30
local FLAG_EQUIP_ONCE=id+100

function s.initial_effect(c)
	--自己场上只能有1张表侧表示存在
	c:SetUniqueOnField(1,0,id)

	--卡的发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(s.actcost)
	e0:SetTarget(s.acttg)
	c:RegisterEffect(e0)

	--把「大日」卡作为发动代价送墓的场合，可以从手卡发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.handcon)
	c:RegisterEffect(e1)

	--①：墓地·除外状态的最多3只怪兽作为装备卡装备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(
		0,
		TIMINGS_CHECK_MONSTER
		+TIMING_MAIN_END
	)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)

	--②：自己不是超量怪兽不能从额外卡组特殊召唤
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
	SET_VYLON
}

--卡的发动代价

function s.actcostfilter(c)
	return (
			c:IsSetCard(SET_LAVAL)
			or c:IsSetCard(SET_VYLON)
		)
		and c:IsAbleToGraveAsCost()
end

function s.vylonfilter(c)
	return c:IsSetCard(SET_VYLON)
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
			s.vylonfilter,
			1,
			nil
		)
		or xg:IsExists(
			s.vylonfilter,
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
			or c:IsSetCard(SET_VYLON)
			or xg:IsExists(
				s.vylonfilter,
				1,
				nil
			)
		)
end

function s.extrapickfilter(c,needvylon)
	return s.actcostfilter(c)
		and (
			not needvylon
			or c:IsSetCard(SET_VYLON)
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

	local needvylon=
		handact
		and not hc:IsSetCard(SET_VYLON)

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
		needvylon
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

--卡的发动时，可以适用①
function s.acttg(
	e,tp,eg,ep,ev,re,r,rp,chk,chkc
)
	if chkc then
		return s.eqtg(
			e,tp,eg,ep,ev,re,r,rp,
			chk,chkc
		)
	end

	if chk==0 then
		return true
	end

	local b=s.eqtg(
		e,tp,eg,ep,ev,re,r,rp,0
	)

	if b
		and Duel.SelectYesNo(
			tp,
			aux.Stringid(id,0)
		) then

		e:SetCategory(CATEGORY_EQUIP)
		e:SetProperty(
			EFFECT_FLAG_CARD_TARGET
		)
		e:SetOperation(s.eqop)

		s.eqtg(
			e,tp,eg,ep,ev,re,r,rp,1
		)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

--①

function s.eqfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_TOKEN)
		and (
			c:IsLocation(LOCATION_GRAVE)
			or (
				c:IsLocation(LOCATION_REMOVED)
				and c:IsFaceup()
			)
		)
		and not c:IsForbidden()
		and (
			c:IsControler(tp)
			or c:IsAbleToChangeControler()
		)
		and c:IsCanBeEffectTarget(e)
end

function s.eqtargetfilter(c,e)
	return c:IsFaceup()
		and c:IsType(TYPE_MONSTER)
		and not c:IsImmuneToEffect(e)
end

function s.eqtg(
	e,tp,eg,ep,ev,re,r,rp,chk,chkc
)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(
		tp,
		LOCATION_SZONE
	)
	local maxct=math.min(3,ft)

	if chkc then
		return chkc:IsLocation(
				LOCATION_GRAVE
				+LOCATION_REMOVED
			)
			and aux.NecroValleyFilter(
				s.eqfilter
			)(chkc,e,tp)
	end

	if chk==0 then
		return c:GetFlagEffect(
				FLAG_EQUIP_ONCE
			)==0
			and maxct>0
			and Duel.IsExistingMatchingCard(
				s.eqtargetfilter,
				tp,
				LOCATION_MZONE,
				LOCATION_MZONE,
				1,
				nil,
				e
			)
			and Duel.IsExistingTarget(
				aux.NecroValleyFilter(
					s.eqfilter
				),
				tp,
				LOCATION_GRAVE
					+LOCATION_REMOVED,
				LOCATION_GRAVE
					+LOCATION_REMOVED,
				1,
				nil,
				e,
				tp
			)
	end

	c:RegisterFlagEffect(
		FLAG_EQUIP_ONCE,
		RESET_EVENT+RESETS_STANDARD,
		0,
		1
	)

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TARGET
	)
	local g=Duel.SelectTarget(
		tp,
		aux.NecroValleyFilter(
			s.eqfilter
		),
		tp,
		LOCATION_GRAVE
			+LOCATION_REMOVED,
		LOCATION_GRAVE
			+LOCATION_REMOVED,
		1,
		maxct,
		nil,
		e,
		tp
	)

	Duel.SetOperationInfo(
		0,
		CATEGORY_EQUIP,
		g,
		g:GetCount(),
		0,
		LOCATION_GRAVE
			+LOCATION_REMOVED
	)
end

function s.eqresfilter(c,e,tp)
	return c:IsRelateToEffect(e)
		and c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_TOKEN)
		and (
			c:IsLocation(LOCATION_GRAVE)
			or (
				c:IsLocation(LOCATION_REMOVED)
				and c:IsFaceup()
			)
		)
		and not c:IsForbidden()
		and (
			c:IsControler(tp)
			or c:IsAbleToChangeControler()
		)
		and not (
			c:IsLocation(LOCATION_GRAVE)
			and aux.NecroValleyNegateCheck(c)
		)
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.addequipeffects(ec,tc)
	--装备限制
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(
		EFFECT_FLAG_CANNOT_DISABLE
	)
	e1:SetReset(
		RESET_EVENT+RESETS_STANDARD
	)
	e1:SetLabelObject(tc)
	e1:SetValue(s.eqlimit)
	ec:RegisterEffect(e1)

	--装备怪兽攻击力上升500
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	e2:SetReset(
		RESET_EVENT+RESETS_STANDARD
	)
	ec:RegisterEffect(e2)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(
		0,
		CHAININFO_TARGET_CARDS
	)

	if not g then
		return
	end

	g=g:Filter(
		s.eqresfilter,
		nil,
		e,
		tp
	)

	if g:GetCount()==0 then
		return
	end

	local ft=Duel.GetLocationCount(
		tp,
		LOCATION_SZONE
	)

	if ft<=0 then
		return
	end

	if g:GetCount()>ft then
		Duel.Hint(
			HINT_SELECTMSG,
			tp,
			HINTMSG_EQUIP
		)
		g=g:Select(
			tp,
			ft,
			ft,
			nil
		)
	end

	local mg=Duel.GetMatchingGroup(
		s.eqtargetfilter,
		tp,
		LOCATION_MZONE,
		LOCATION_MZONE,
		nil,
		e
	)

	if mg:GetCount()==0 then
		return
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_EQUIP
	)
	local tc=mg:Select(
		tp,
		1,
		1,
		nil
	):GetFirst()

	if not tc then
		return
	end

	local ec=g:GetFirst()

	while ec do
		if Duel.GetLocationCount(
			tp,
			LOCATION_SZONE
		)<=0 then
			break
		end

		if not tc:IsFaceup()
			or not tc:IsLocation(
				LOCATION_MZONE
			) then
			break
		end

		if Duel.Equip(
			tp,
			ec,
			tc,
			true
		) then
			s.addequipeffects(
				ec,
				tc
			)
		end

		ec=g:GetNext()
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
			or c:IsSetCard(SET_VYLON)
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
