--深海舰队 总旗舰 Yamato
local s,id=GetID()

function s.initial_effect(c)

	--连接召唤条件：效果怪兽2只以上
	aux.AddLinkProcedure(
		c,
		aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),
		2
	)

	c:EnableReviveLimit()


	---------------------------------
	--① 特殊召唤成功：墓地/除外深海舰队变永续陷阱
	---------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sztg)
	e1:SetOperation(s.szop)
	c:RegisterEffect(e1)



	---------------------------------
	--② 墓地特殊召唤
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)

end



---------------------------------
--①
---------------------------------

function s.filter(c)

	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_LINK)
		and not c:IsForbidden()

end



function s.sztg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return Duel.GetLocationCount(
			tp,
			LOCATION_SZONE
		)>0
		and Duel.IsExistingMatchingCard(
			s.filter,
			tp,
			LOCATION_GRAVE+LOCATION_REMOVED,
			0,
			1,
			nil
		)

	end

end



function s.szop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()


	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end


	local g=Duel.SelectMatchingCard(
		tp,
		s.filter,
		tp,
		LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		1,
		1,
		nil
	)


	local tc=g:GetFirst()


	if tc then

		Duel.MoveToField(
			tc,
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

		tc:RegisterEffect(e1)

	end

end



---------------------------------
--②
---------------------------------

function s.spcon(e,tp,eg,ep,ev,re,r,rp)

	return Duel.IsExistingMatchingCard(
		aux.TRUE,
		1-tp,
		LOCATION_MZONE,
		0,
		1,
		nil
	)

end



function s.rmfilter(c)

	return c:IsLocation(LOCATION_GRAVE)
		or c:IsLocation(LOCATION_REMOVED)

end



function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return Duel.GetLocationCount(
			tp,
			LOCATION_MZONE
		)>0
		and Duel.GetMatchingGroupCount(
			aux.TRUE,
			tp,
			LOCATION_GRAVE,
			0,
			e:GetHandler()
		)>=2

	end


	Duel.SetOperationInfo(
		0,
		CATEGORY_REMOVE,
		nil,
		2,
		tp,
		LOCATION_GRAVE
	)

	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		e:GetHandler(),
		1,
		0,
		0
	)

end



function s.spop2(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()


	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end


	local g=Duel.SelectMatchingCard(
		tp,
		aux.TRUE,
		tp,
		LOCATION_GRAVE,
		0,
		2,
		2,
		nil
	)


	if #g<2 then
		return
	end


	Duel.Remove(
		g,
		POS_FACEUP,
		REASON_COST
	)


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