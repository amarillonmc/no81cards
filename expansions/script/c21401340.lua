--熔岩谷牵系的薰风
local s,id,o=GetID()

local SET_LAVAL=0x39
local SET_GUSTO=0x10
local FLAG_CONTROL_ONCE=id+100

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

	--把「薰风」卡作为发动代价送墓的场合，可以从手卡发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.handcon)
	c:RegisterEffect(e1)

	--①：转移控制权，结束阶段回到手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(
		CATEGORY_CONTROL
		+CATEGORY_TOHAND
	)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(
		0,
		TIMINGS_CHECK_MONSTER
		+TIMING_MAIN_END
	)
	e2:SetCost(s.ctcost)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
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
	SET_GUSTO
}

--卡的发动代价

function s.actcostfilter(c)
	return (
			c:IsSetCard(SET_LAVAL)
			or c:IsSetCard(SET_GUSTO)
		)
		and c:IsAbleToGraveAsCost()
end

function s.gustofilter(c)
	return c:IsSetCard(SET_GUSTO)
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
			s.gustofilter,
			1,
			nil
		)
		or xg:IsExists(
			s.gustofilter,
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
			or c:IsSetCard(SET_GUSTO)
			or xg:IsExists(
				s.gustofilter,
				1,
				nil
			)
		)
end

function s.extrapickfilter(c,needgusto)
	return s.actcostfilter(c)
		and (
			not needgusto
			or c:IsSetCard(SET_GUSTO)
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

	local needgusto=
		handact
		and not hc:IsSetCard(SET_GUSTO)

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
		needgusto
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
		return s.cttg(
			e,tp,eg,ep,ev,re,r,rp,
			chk,chkc
		)
	end

	if chk==0 then
		return true
	end

	local b=s.ctcost(
			e,tp,eg,ep,ev,re,r,rp,0
		)
		and s.cttg(
			e,tp,eg,ep,ev,re,r,rp,0
		)

	if b
		and Duel.SelectYesNo(
			tp,
			aux.Stringid(id,2)
		) then

		e:SetCategory(
			CATEGORY_CONTROL
			+CATEGORY_TOHAND
		)
		e:SetProperty(
			EFFECT_FLAG_CARD_TARGET
		)
		e:SetOperation(s.ctop)

		s.ctcost(
			e,tp,eg,ep,ev,re,r,rp,1
		)
		s.cttg(
			e,tp,eg,ep,ev,re,r,rp,1
		)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

--①

function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		return c:GetFlagEffect(
			FLAG_CONTROL_ONCE
		)==0
	end

	c:RegisterFlagEffect(
		FLAG_CONTROL_ONCE,
		RESET_EVENT+RESETS_STANDARD,
		0,
		1
	)
end

function s.ctfilter(c,e)
	return c:IsAbleToChangeControler()
		and c:IsCanBeEffectTarget(e)
end

--只转移1只时，接收方当前必须有可用区域
function s.cansinglecontrol(c)
	local cp=c:GetControler()

	return Duel.GetMZoneCount(
		1-cp,
		nil,
		cp,
		LOCATION_REASON_CONTROL
	)>0
end

--交换时，这只怪兽离开后，
--原控制者必须能接收另一只怪兽
function s.canswapcontrol(c)
	local cp=c:GetControler()

	return Duel.GetMZoneCount(
		cp,
		c,
		cp,
		LOCATION_REASON_CONTROL
	)>0
end

function s.ctpairfilter(c,e,tc)
	return c:GetControler()
			~=tc:GetControler()
		and s.ctfilter(c,e)
		and s.canswapcontrol(c)
		and s.canswapcontrol(tc)
end

function s.ctfirstfilter(c,e,tp)
	if not s.ctfilter(c,e) then
		return false
	end

	if s.cansinglecontrol(c) then
		return true
	end

	if not s.canswapcontrol(c) then
		return false
	end

	if c:IsControler(tp) then
		return Duel.IsExistingMatchingCard(
			s.ctpairfilter,
			tp,
			0,
			LOCATION_MZONE,
			1,
			nil,
			e,
			c
		)
	else
		return Duel.IsExistingMatchingCard(
			s.ctpairfilter,
			tp,
			LOCATION_MZONE,
			0,
			1,
			nil,
			e,
			c
		)
	end
end

function s.cttg(
	e,tp,eg,ep,ev,re,r,rp,chk,chkc
)
	if chkc then
		return chkc:IsLocation(
				LOCATION_MZONE
			)
			and s.ctfirstfilter(
				chkc,
				e,
				tp
			)
	end

	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.ctfirstfilter,
			tp,
			LOCATION_MZONE,
			LOCATION_MZONE,
			1,
			nil,
			e,
			tp
		)
	end

	local fg=Duel.GetMatchingGroup(
		s.ctfirstfilter,
		tp,
		LOCATION_MZONE,
		LOCATION_MZONE,
		nil,
		e,
		tp
	)

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_CONTROL
	)
	local tc=fg:Select(
		tp,
		1,
		1,
		nil
	):GetFirst()

	if not tc then
		return
	end

	local sg=Group.FromCards(tc)
	local og

	if tc:IsControler(tp) then
		og=Duel.GetMatchingGroup(
			s.ctpairfilter,
			tp,
			0,
			LOCATION_MZONE,
			nil,
			e,
			tc
		)
	else
		og=Duel.GetMatchingGroup(
			s.ctpairfilter,
			tp,
			LOCATION_MZONE,
			0,
			nil,
			e,
			tc
		)
	end

	local mustselect=
		not s.cansinglecontrol(tc)

	if og:GetCount()>0
		and (
			mustselect
			or Duel.SelectYesNo(
				tp,
				aux.Stringid(id,2)
			)
		) then

		Duel.Hint(
			HINT_SELECTMSG,
			tp,
			HINTMSG_CONTROL
		)
		local tc2=og:Select(
			tp,
			1,
			1,
			nil
		):GetFirst()

		if tc2 then
			sg:AddCard(tc2)
		end
	end

	Duel.SetTargetCard(sg)

	Duel.SetOperationInfo(
		0,
		CATEGORY_CONTROL,
		sg,
		sg:GetCount(),
		0,
		0
	)
	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		sg,
		sg:GetCount(),
		0,
		LOCATION_MZONE
	)
end

function s.ctresfilter(c,e)
	return c:IsRelateToEffect(e)
		and c:IsLocation(
			LOCATION_MZONE
		)
		and c:IsAbleToChangeControler()
		and not c:IsImmuneToEffect(e)
end

function s.registerreturn(e,tp,g)
	if g:GetCount()==0 then
		return
	end

	local c=e:GetHandler()
	local flag=id+c:GetFieldID()
	local tc=g:GetFirst()

	while tc do
		tc:RegisterFlagEffect(
			flag,
			RESET_EVENT
				+RESETS_STANDARD
				+RESET_PHASE
				+PHASE_END,
			0,
			1
		)
		tc=g:GetNext()
	end

	g:KeepAlive()

	local e1=Effect.CreateEffect(c)
	e1:SetType(
		EFFECT_TYPE_FIELD
		+EFFECT_TYPE_CONTINUOUS
	)
	e1:SetCode(
		EVENT_PHASE
		+PHASE_END
	)
	e1:SetProperty(
		EFFECT_FLAG_IGNORE_IMMUNE
	)
	e1:SetCountLimit(1)
	e1:SetLabel(flag)
	e1:SetLabelObject(g)
	e1:SetCondition(s.rhcon)
	e1:SetOperation(s.rhop)
	e1:SetReset(
		RESET_PHASE
		+PHASE_END
	)
	Duel.RegisterEffect(e1,tp)
end

function s.rhfilter(c,flag)
	return c:IsLocation(
			LOCATION_MZONE
		)
		and c:GetFlagEffect(flag)>0
		and c:IsAbleToHand()
end

function s.rhcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()

	if not g:IsExists(
		s.rhfilter,
		1,
		nil,
		e:GetLabel()
	) then
		g:DeleteGroup()
		e:Reset()
		return false
	end

	return true
end

function s.rhop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(
		s.rhfilter,
		nil,
		e:GetLabel()
	)

	g:DeleteGroup()

	if tg:GetCount()>0 then
		Duel.SendtoHand(
			tg,
			nil,
			REASON_EFFECT
		)
	end
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(
		0,
		CHAININFO_TARGET_CARDS
	)

	if not g then
		return
	end

	g=g:Filter(
		s.ctresfilter,
		nil,
		e
	)

	if g:GetCount()==0 then
		return
	end

	local rg=Group.CreateGroup()

	if g:GetCount()==2 then
		local tc1=g:GetFirst()
		local tc2=g:GetNext()

		if tc1:GetControler()
			~=tc2:GetControler() then

			if s.canswapcontrol(tc1)
				and s.canswapcontrol(tc2)
				and Duel.SwapControl(
					tc1,
					tc2,
					0,
					0
				) then

				rg:AddCard(tc1)
				rg:AddCard(tc2)
			end
		else
			local tc=g:GetFirst()

			while tc do
				local nc=g:GetNext()
				local cp=tc:GetControler()

				if s.cansinglecontrol(tc)
					and Duel.GetControl(
						tc,
						1-cp,
						0,
						0
					)>0 then

					rg:AddCard(tc)
				end

				tc=nc
			end
		end
	else
		local tc=g:GetFirst()
		local cp=tc:GetControler()

		if s.cansinglecontrol(tc)
			and Duel.GetControl(
				tc,
				1-cp,
				0,
				0
			)>0 then

			rg:AddCard(tc)
		end
	end

	s.registerreturn(
		e,
		tp,
		rg
	)
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
			or c:IsSetCard(SET_GUSTO)
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
