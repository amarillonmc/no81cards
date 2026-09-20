--深海舰队 战列舰 Musashi
--16340060

local s,id=GetID()

function s.initial_effect(c)

	--Link召唤条件
	aux.AddLinkProcedure(c,s.matfilter,2,99)
	c:EnableReviveLimit()


	-------------------------------
	--① Link召唤成功
	-------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.lkcon)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.lktg)
	e1:SetOperation(s.lkop)
	c:RegisterEffect(e1)


	-------------------------------
	--② 破坏对方卡 + 墓地铺设
	-------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)

end


---------------------------------
-- Link素材
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


--只允许深海舰队怪兽
function s.filter(c)

	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)
		and (
			c:IsLocation(LOCATION_GRAVE)
			or c:IsLocation(LOCATION_REMOVED)
		)

end


function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.filter,
			tp,
			LOCATION_GRAVE+LOCATION_REMOVED,
			0,
			2,
			nil
		)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		1,
		tp,
		LOCATION_GRAVE+LOCATION_REMOVED
	)

end



function s.settrap(c,tp)

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
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)

	c:RegisterEffect(e1)

end



function s.lkop(e,tp,eg,ep,ev,re,r,rp)

	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then
		return
	end


	local g=Duel.SelectMatchingCard(
		tp,
		s.filter,
		tp,
		LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		2,
		2,
		nil
	)

	if #g<2 then
		return
	end


	for tc in aux.Next(g) do
		s.settrap(tc,tp)
	end


	local sg=g:Filter(
		Card.IsCanBeSpecialSummoned,
		nil,
		e,
		0,
		tp,
		false,
		false
	)


	if #sg>0 then

		local sc=sg:Select(
			tp,
			1,
			1,
			nil
		):GetFirst()


		if sc then

			Duel.SpecialSummon(
				sc,
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

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return Duel.IsExistingMatchingCard(
			aux.TRUE,
			tp,
			0,
			LOCATION_ONFIELD,
			1,
			nil
		)

	end


	local g=Duel.SelectMatchingCard(
		tp,
		aux.TRUE,
		tp,
		0,
		LOCATION_ONFIELD,
		1,
		1,
		nil
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



--只允许深海舰队怪兽
function s.grfilter(c)

	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_LINK)

end



function s.desop(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetChainInfo(
		0,
		CHAININFO_TARGET_CARDS
	)


	if g then
		Duel.Destroy(
			g,
			REASON_EFFECT
		)
	end


	if Duel.GetLocationCount(
		tp,
		LOCATION_SZONE
	)<=0 then
		return
	end


	local sg=Duel.SelectMatchingCard(
		tp,
		s.grfilter,
		tp,
		LOCATION_GRAVE,
		0,
		0,
		1,
		nil
	)


	if #sg>0 then

		s.settrap(
			sg:GetFirst(),
			tp
		)

	end

end