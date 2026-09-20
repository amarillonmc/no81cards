--深海舰队 总旗舰 Abyss Yamato
--16340075

local s,id=GetID()

function s.initial_effect(c)

	--Link召唤
	aux.AddLinkProcedure(c,s.matfilter,5,5)
	c:EnableReviveLimit()


	---------------------------------
	--① Link召唤成功
	---------------------------------

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


	---------------------------------
	--② 无效破坏
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)


	---------------------------------
	--③ 战斗破坏自毁
	---------------------------------

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(s.bacon)
	e3:SetOperation(s.baop)
	c:RegisterEffect(e3)

end



---------------------------------
-- Link素材
---------------------------------

function s.matfilter(c)
	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_EFFECT)
end



---------------------------------
--①
---------------------------------

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end


function s.setfilter(c)
	return c:IsSetCard(0x3dce)
		and not c:IsType(TYPE_LINK)
		and (
			c:IsLocation(LOCATION_HAND)
			or c:IsLocation(LOCATION_GRAVE)
			or c:IsLocation(LOCATION_REMOVED)
		)
end


function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(
				s.setfilter,
				tp,
				LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,
				0,
				1,
				nil
			)
	end


	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		1,
		tp,
		LOCATION_SZONE
	)

end



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
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)

	c:RegisterEffect(e1)

end



function s.lkop(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetMatchingGroup(
		s.setfilter,
		tp,
		LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		nil
	)


	if #g==0 then
		return
	end


	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)

	if ct<=0 then
		return
	end


	if #g>ct then
		g=g:Select(tp,ct,ct,nil)
	else
		g=g:Select(tp,#g,#g,nil)
	end


	for tc in aux.Next(g) do
		s.movetrap(tc,tp)
	end


	--特殊召唤刚才放置的怪兽

	local sg=g:Filter(
		Card.IsCanBeSpecialSummoned,
		nil,
		e,
		0,
		tp,
		false,
		false
	)


	for tc in aux.Next(sg) do

		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			break
		end

		Duel.SpecialSummon(
			tc,
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

function s.negfilter(c)
	return c:IsSetCard(0x3dce)
		and c:IsDestructable()
end


function s.negcon(e,tp,eg,ep,ev,re,r,rp)

	return rp==1-tp
		and Duel.IsExistingMatchingCard(
			s.negfilter,
			tp,
			LOCATION_ONFIELD,
			0,
			1,
			nil
		)

end



function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then

		return Duel.IsExistingMatchingCard(
			s.negfilter,
			tp,
			LOCATION_ONFIELD,
			0,
			1,
			nil
		)

	end


	local g=Duel.SelectMatchingCard(
		tp,
		s.negfilter,
		tp,
		LOCATION_ONFIELD,
		0,
		1,
		1,
		nil
	)

	Duel.Destroy(
		g,
		REASON_COST
	)

end



function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return true
	end


	Duel.SetOperationInfo(
		0,
		CATEGORY_DESTROY,
		eg,
		#eg,
		0,
		0
	)

end



function s.negop(e,tp,eg,ep,ev,re,r,rp)

	if Duel.NegateActivation(ev) then

		Duel.Destroy(
			eg,
			REASON_EFFECT
		)

		Duel.Damage(
			1-tp,
			800,
			REASON_EFFECT
		)

	end

end



---------------------------------
--③
---------------------------------

function s.bacon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsReason(REASON_BATTLE)

end



function s.baop(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetFieldGroup(
		tp,
		LOCATION_ONFIELD,
		0
	)

	if #g>0 then

		Duel.Destroy(
			g,
			REASON_EFFECT
		)

	end

end