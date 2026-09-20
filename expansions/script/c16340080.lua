--深海舰队的补给
--16340100

local s,id=GetID()

function s.initial_effect(c)

	---------------------------------
	--① 放置深海舰队
	---------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)


	---------------------------------
	--② 墓地回收
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

end



---------------------------------
--① 过滤
---------------------------------

function s.filter(c)

	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)

end



function s.filter2(c)

	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)

end



---------------------------------
--① 目标
---------------------------------

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)

	local b1=Duel.IsExistingMatchingCard(
		s.filter,
		tp,
		LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		1,
		nil
	)

	local b2=Duel.IsExistingMatchingCard(
		s.filter,
		tp,
		LOCATION_DECK,
		0,
		1,
		nil
	)


	if chk==0 then
		return b1
	end


	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		1,
		tp,
		LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED
	)

end



---------------------------------
--① 执行
---------------------------------

function s.setop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()


	if Duel.GetLocationCount(
		tp,
		LOCATION_SZONE
	)<=0 then
		return
	end



	--第一只

	local g=Duel.SelectMatchingCard(
		tp,
		s.filter,
		tp,
		LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		1,
		1,
		nil
	)


	local tc=g:GetFirst()


	if tc then

		s.movetrap(tc,tp)

	end



	--对方卡比自己多，追加第二只

	if Duel.GetFieldGroupCount(
		1-tp,
		LOCATION_ONFIELD,
		0
	)
	>
	Duel.GetFieldGroupCount(
		tp,
		LOCATION_ONFIELD,
		0
	)
	then


		if Duel.GetLocationCount(
			tp,
			LOCATION_SZONE
		)>0 then


			local g2=Duel.SelectMatchingCard(
				tp,
				s.filter,
				tp,
				LOCATION_DECK,
				0,
				1,
				1,
				nil
			)


			local tc2=g2:GetFirst()


			if tc2 then

				s.movetrap(tc2,tp)

			end

		end

	end

end



---------------------------------
--移动到魔陷区作为永续陷阱
---------------------------------

function s.movetrap(c,tp)

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

end



---------------------------------
--② 回收条件
---------------------------------

function s.thcon(e,tp,eg,ep,ev,re,r,rp)

	return Duel.GetTurnPlayer()==1-tp

end



function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return e:GetHandler():IsAbleToHand()

	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		e:GetHandler(),
		1,
		tp,
		LOCATION_GRAVE
	)

end



function s.thop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()


	if c:IsRelateToEffect(e) then

		Duel.SendtoHand(
			c,
			nil,
			REASON_EFFECT
		)

	end

end