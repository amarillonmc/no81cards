--深海舰队 装甲航空母舰 Taihō
local s,id=GetID()

function s.initial_effect(c)


	---------------------------------
	--Link
	---------------------------------

	aux.AddLinkProcedure(
		c,
		s.matfilter,
		3,
		99
	)

	c:EnableReviveLimit()



	---------------------------------
	--① 生成飞机
	---------------------------------

	local e1=Effect.CreateEffect(c)

	e1:SetDescription(aux.Stringid(id,0))

	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)

	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)

	e1:SetCode(EVENT_SPSUMMON_SUCCESS)

	e1:SetCondition(s.lkcon)

	e1:SetCountLimit(1,id)

	e1:SetOperation(s.tokenop)

	c:RegisterEffect(e1)



	---------------------------------
	--② 全舰队强化
	---------------------------------

	local e2=Effect.CreateEffect(c)

	e2:SetType(EFFECT_TYPE_FIELD)

	e2:SetCode(EFFECT_UPDATE_ATTACK)

	e2:SetRange(LOCATION_MZONE)

	e2:SetTargetRange(LOCATION_MZONE,0)

	e2:SetTarget(aux.TargetBoolFunction(
		Card.IsSetCard,
		0x3dce
	))

	e2:SetValue(s.atkval)

	c:RegisterEffect(e2)



	---------------------------------
	--③ 离场复活
	---------------------------------

	local e3=Effect.CreateEffect(c)

	e3:SetDescription(aux.Stringid(id,1))

	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)

	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)

	e3:SetProperty(EFFECT_FLAG_DELAY)

	e3:SetCode(EVENT_TO_GRAVE)

	e3:SetCountLimit(1,id+1)

	e3:SetCondition(s.spcon)

	e3:SetTarget(s.sptg)

	e3:SetOperation(s.spop)

	c:RegisterEffect(e3)



	local e4=e3:Clone()

	e4:SetCode(EVENT_REMOVE)

	c:RegisterEffect(e4)


end



---------------------------------

function s.matfilter(c)

	return c:IsSetCard(0x3dce)

end



---------------------------------
--①
---------------------------------

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsSummonType(
		SUMMON_TYPE_LINK
	)

end



function s.tokenop(e,tp,eg,ep,ev,re,r,rp)

	for i=1,3 do

		if Duel.GetLocationCount(
			tp,
			LOCATION_MZONE
		)<=0 then
			break
		end


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



	local e1=Effect.CreateEffect(
		e:GetHandler()
	)

	e1:SetType(EFFECT_TYPE_FIELD)

	e1:SetCode(
		EFFECT_CANNOT_SPECIAL_SUMMON
	)

	e1:SetProperty(
		EFFECT_FLAG_PLAYER_TARGET
	)

	e1:SetTargetRange(
		1,
		0
	)

	e1:SetTarget(s.sumlimit)

	e1:SetReset(
		RESET_PHASE+PHASE_END
	)

	Duel.RegisterEffect(
		e1,
		tp
	)

end



function s.sumlimit(e,c)

	return not c:IsSetCard(0x3dce)

end



---------------------------------
--②
---------------------------------

function s.atkval(e,c)

	return Duel.GetMatchingGroupCount(
		Card.IsMonster,
		e:GetHandlerPlayer(),
		LOCATION_MZONE,
		0,
		nil
	)*300

end



---------------------------------
--③
---------------------------------

function s.spcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsReason(
		REASON_EFFECT
	)

end



function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return Duel.GetLocationCount(
			tp,
			LOCATION_MZONE
		)>0

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


	if Duel.GetLocationCount(
		tp,
		LOCATION_MZONE
	)<=0 then
		return
	end


	local g=Duel.SelectMatchingCard(
		tp,
		aux.TRUE,
		tp,
		LOCATION_ONFIELD,
		0,
		1,
		1,
		nil
	)


	if #g>0 then

		Duel.SendtoGrave(
			g,
			REASON_EFFECT
		)


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