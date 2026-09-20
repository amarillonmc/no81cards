--深海舰队 轻型航空母舰
local s,id=GetID()

function s.initial_effect(c)


	---------------------------------
	--① 检索 / 苏生
	---------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)



	---------------------------------
	--② 永续陷阱效果
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)

end



---------------------------------
--①
---------------------------------

function s.thfilter(c)

	return c:IsSetCard(0x3dce)
		and c:IsAbleToHand()

end



function s.revfilter(c)

	return c:IsSetCard(0x3dce)
		and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(
			nil,
			0,
			0,
			false,
			false
		)

end



function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)

	local b1=Duel.IsExistingMatchingCard(
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		1,
		nil
	)

	local b2=Duel.IsExistingMatchingCard(
		s.revfilter,
		tp,
		LOCATION_GRAVE,
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
			aux.Stringid(id,2),
			aux.Stringid(id,3)
		)

	elseif b1 then

		op=0

	else

		op=1

	end


	e:SetLabel(op)

end



function s.mainop(e,tp,eg,ep,ev,re,r,rp)

	if e:GetLabel()==0 then


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


		if #g>0 then

			Duel.SendtoHand(
				g,
				nil,
				REASON_EFFECT
			)

			Duel.ConfirmCards(
				1-tp,
				g
			)


			if Duel.GetFieldGroupCount(
				tp,
				LOCATION_HAND,
				0
			)>0 then


				local hg=Duel.SelectMatchingCard(
					tp,
					aux.TRUE,
					tp,
					LOCATION_HAND,
					0,
					1,
					1,
					nil
				)


				Duel.SendtoGrave(
					hg,
					REASON_EFFECT
				)

			end

		end



	else


		local g=Duel.SelectMatchingCard(
			tp,
			s.revfilter,
			tp,
			LOCATION_GRAVE,
			0,
			1,
			1,
			nil
		)


		if #g>0 then

			Duel.SpecialSummon(
				g,
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



---------------------------------
--②
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


	local b2=Duel.GetLocationCount(
		tp,
		LOCATION_MZONE
	)>0



	if chk==0 then
		return b1 or b2
	end



	local op


	if b1 and b2 then

		op=Duel.SelectOption(
			tp,
			aux.Stringid(id,1),
			aux.Stringid(id,2)
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


		if c:IsRelateToEffect(e) then


			Duel.Destroy(
				c,
				REASON_EFFECT
			)



			if Duel.GetLocationCount(
				tp,
				LOCATION_MZONE
			)>0 then


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



			local e1=Effect.CreateEffect(c)

			e1:SetType(EFFECT_TYPE_FIELD)

			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)

			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)

			e1:SetTargetRange(1,0)

			e1:SetTarget(s.sumlimit)

			e1:SetReset(
				RESET_PHASE+PHASE_END
			)

			Duel.RegisterEffect(
				e1,
				tp
			)

		end

	end

end



function s.sumlimit(e,c)

	return not c:IsSetCard(0x3dce)

end