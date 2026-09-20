--深海舰队 轻型航空母舰 Ryūjō
local s,id=GetID()

function s.initial_effect(c)


	---------------------------------
	--连接召唤
	---------------------------------

	aux.AddLinkProcedure(
		c,
		s.matfilter,
		2,
		99
	)

	c:EnableReviveLimit()



	---------------------------------
	--① 连接召唤检索
	---------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.lkcon)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)



	---------------------------------
	--② 永续陷阱破坏替代
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.repcon)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)

end



---------------------------------
--素材
---------------------------------

function s.matfilter(c)

	return c:IsSetCard(0x3dce)

end



---------------------------------
--①
---------------------------------

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)

end



function s.thfilter(c)

	return c:IsSetCard(0x3dce)
		and c:IsAbleToHand()

end



function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return Duel.IsExistingMatchingCard(
			s.thfilter,
			tp,
			LOCATION_DECK+LOCATION_GRAVE,
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
		LOCATION_DECK+LOCATION_GRAVE
	)

end



function s.thop(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.SelectMatchingCard(
		tp,
		s.thfilter,
		tp,
		LOCATION_DECK+LOCATION_GRAVE,
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

	end



	if Duel.SelectYesNo(
		tp,
		aux.Stringid(id,1)
	)
	then


		local g1=Duel.SelectMatchingCard(
			tp,
			aux.TRUE,
			tp,
			LOCATION_ONFIELD,
			0,
			1,
			1,
			nil
		)


		local g2=Duel.SelectMatchingCard(
			tp,
			aux.TRUE,
			1-tp,
			LOCATION_ONFIELD,
			0,
			1,
			1,
			nil
		)


		g1:Merge(g2)


		if #g1>0 then

			Duel.Destroy(
				g1,
				REASON_EFFECT
			)

		end

	end

end



---------------------------------
--②
---------------------------------

function s.repcon(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()


	if not eg:IsExists(
		s.repfilter,
		1,
		nil,
		tp
	)
	then
		return false
	end


	return Duel.IsExistingMatchingCard(
		aux.TRUE,
		1-tp,
		LOCATION_ONFIELD,
		0,
		1,
		nil
	)

end



function s.repfilter(c,tp)

	return c:IsPreviousLocation(LOCATION_SZONE)
		and c:IsPreviousControler(tp)
		and c:IsType(TYPE_TRAP)
		and c:IsType(TYPE_CONTINUOUS)

end



function s.repop(e,tp,eg,ep,ev,re,r,rp)

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

end