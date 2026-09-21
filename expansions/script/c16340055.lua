--轻型航空母舰
local s,id=GetID()

function s.initial_effect(c)
	--①效果：自己主要阶段二选一
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)

	--②效果：作为永续陷阱存在时
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

--------------------------------------------------
-- ① 自己主要阶段二选一
--------------------------------------------------

function s.mainfilter(c)
	return c:IsSetCard(0x3dce) and c:IsAbleToHand()
end

function s.revfilter(c,e,tp)
	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)
		and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(
		s.mainfilter,
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
		nil,
		e,
		tp
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
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end

	e:SetLabel(op)
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()

	--检索1张深海舰队卡，然后手卡送墓1张卡
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

		local g=Duel.SelectMatchingCard(
			tp,
			s.mainfilter,
			tp,
			LOCATION_DECK,
			0,
			1,
			1,
			nil
		)

		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)

			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
				Duel.Hint(
					HINT_SELECTMSG,
					tp,
					HINTMSG_DISCARD
				)

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

				if #hg>0 then
					Duel.SendtoGrave(
						hg,
						REASON_EFFECT+REASON_DISCARD
					)
				end
			end
		end

	--墓地特殊召唤1只4星以下深海舰队怪兽
	else
		Duel.Hint(
			HINT_SELECTMSG,
			tp,
			HINTMSG_SPSUMMON
		)

		local g=Duel.SelectMatchingCard(
			tp,
			s.revfilter,
			tp,
			LOCATION_GRAVE,
			0,
			1,
			1,
			nil,
			e,
			tp
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

--------------------------------------------------
-- 作为永续陷阱存在时的效果
--------------------------------------------------

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
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

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false)

	local b2=
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsDestructable()
		and Duel.IsPlayerCanSpecialSummonMonster(
			tp,
			16340085,
			0x3dce,
			TYPE_TOKEN,
			800,
			800,
			2,
			RACE_MACHINE,
			ATTRIBUTE_WATER
		)

	if chk==0 then
		return b1 or b2
	end

	local op
	if b1 and b2 then
		op=Duel.SelectOption(
			tp,
			aux.Stringid(id,4),
			aux.Stringid(id,5)
		)
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,4))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,5))+1
	end

	e:SetLabel(op)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()

	--特殊召唤自身
	if op==0 then
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

	--破坏自身，生成1只飞机衍生物，并限制额外卡组特殊召唤
	else
		if not c:IsRelateToEffect(e) then
			return
		end

		local ct=Duel.Destroy(c,REASON_EFFECT)

		if ct>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(
				tp,
				16340085,
				0x3dce,
				TYPE_TOKEN,
				800,
				800,
				2,
				RACE_MACHINE,
				ATTRIBUTE_WATER
			) then

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

			--本回合非深海舰队怪兽不能从额外卡组特殊召唤
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.sumlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function s.sumlimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
		and not c:IsSetCard(0x3dce)
end