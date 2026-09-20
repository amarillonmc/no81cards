--深海舰队 航空战列舰
--16340040

local s,id=GetID()

function s.initial_effect(c)

	---------------------------------
	--① 手卡丢弃1张特殊召唤
	---------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)


	---------------------------------
	--② 变永续陷阱+飞机Token
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)


	---------------------------------
	--③ 永续陷阱效果
	---------------------------------

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+2)
	e3:SetCondition(s.effcon)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)

end


---------------------------------
--①
---------------------------------

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return Duel.IsExistingMatchingCard(
			Card.IsDiscardable,
			tp,
			LOCATION_HAND,
			0,
			1,
			e:GetHandler()
		)
	end

	Duel.DiscardHand(
		tp,
		Card.IsDiscardable,
		1,
		1,
		REASON_COST+REASON_DISCARD
	)

end


function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return e:GetHandler():IsCanBeSpecialSummoned(
			e,
			0,
			tp,
			false,
			false
		)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		e:GetHandler(),
		1,
		0,
		0
	)

end


function s.spop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	if c:IsRelateToEffect(e) then

		Duel.SpecialSummon(
			c,
			0,
			tp,
			tp,
			false,
			false,
			POS_FACEUP
		)

	end

end



---------------------------------
--②
---------------------------------

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end

end


function s.setop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	if not c:IsRelateToEffect(e) then
		return
	end


	Duel.MoveToField(
		c,
		tp,
		tp,
		LOCATION_SZONE,
		POS_FACEUP,
		true
	)


	local e1=Effect.CreateEffect(c)

	e1:SetType(EFFECT_TYPE_SINGLE)

	e1:SetCode(EFFECT_CHANGE_TYPE)

	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)

	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)

	e1:SetReset(
		RESET_EVENT+RESETS_STANDARD
	)

	c:RegisterEffect(e1)



	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then

		local token=Duel.CreateToken(
			tp,
			16340085
		)

		Duel.SpecialSummon(
			token,
			0,
			tp,
			tp,
			false,
			false,
			POS_FACEUP
		)

	end

end



---------------------------------
--③
---------------------------------

function s.effcon(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	local ph=Duel.GetCurrentPhase()

	return c:IsType(TYPE_TRAP)
		and c:IsType(TYPE_CONTINUOUS)
		and (
			ph==PHASE_MAIN1
			or ph==PHASE_MAIN2
			or (
				ph>=PHASE_BATTLE_START
				and ph<=PHASE_BATTLE
			)
		)

end



function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)

	local c=e:GetHandler()


	local b1=c:IsCanBeSpecialSummoned(
		e,
		0,
		tp,
		false,
		false
	)


	local b2=Duel.IsExistingMatchingCard(
		aux.TRUE,
		1-tp,
		LOCATION_ONFIELD,
		0,
		1,
		nil
	)


	if chk==0 then
		return b1 or b2
	end


	local op

	if b1 and b2 then

		op=Duel.SelectOption(
			tp,
			aux.Stringid(id,3),
			aux.Stringid(id,4)
		)

	elseif b1 then

		op=0

	else

		op=1

	end


	e:SetLabel(op)

end



function s.effop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()


	if e:GetLabel()==0 then


		if c:IsRelateToEffect(e) then

			Duel.SpecialSummon(
				c,
				0,
				tp,
				tp,
				false,
				false,
				POS_FACEUP
			)

		end



	else


		if not c:IsRelateToEffect(e) then
			return
		end


		Duel.Destroy(
			c,
			REASON_EFFECT
		)


		local g=Duel.SelectMatchingCard(
			tp,
			aux.TRUE,
			1-tp,
			LOCATION_ONFIELD,
			0,
			1,
			1,
			nil
		)


		if #g>0 then

			Duel.Destroy(
				g,
				REASON_EFFECT
			)

		end



		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then

			local token=Duel.CreateToken(
				tp,
				16340085
			)

			Duel.SpecialSummon(
				token,
				0,
				tp,
				tp,
				false,
				false,
				POS_FACEUP
			)

		end

	end

end