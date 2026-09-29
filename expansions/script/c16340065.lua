--深海舰队 轻型航空母舰 Ryūjō
--16340065

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
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.lkcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)


	---------------------------------
	--② 永续陷阱破坏代替
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.desreptg)
	e2:SetValue(s.desrepval)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)

end


---------------------------------
--素材
---------------------------------

function s.matfilter(c)

	return c:IsSetCard(0x3dce)

end


---------------------------------
--① 连接召唤条件
---------------------------------

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)

end


---------------------------------
--① 检索对象
---------------------------------

function s.thfilter(c)

	return c:IsSetCard(0x3dce)
		and c:IsAbleToHand()

end


---------------------------------
--① 发动条件
---------------------------------

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


---------------------------------
--① 检索
---------------------------------

function s.thop(e,tp,eg,ep,ev,re,r,rp)

	---------------------------------
	--从卡组·墓地加入手卡
	---------------------------------

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_ATOHAND
	)

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


	---------------------------------
	--之后，可以把自己以及对方场上的卡各1张破坏
	---------------------------------

	if Duel.SelectYesNo(
		tp,
		aux.Stringid(id,1)
	)
	then

		---------------------------------
		--自己场上的卡
		---------------------------------

		Duel.Hint(
			HINT_SELECTMSG,
			tp,
			HINTMSG_DESTROY
		)

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


		---------------------------------
		--对方场上的卡
		---------------------------------

		Duel.Hint(
			HINT_SELECTMSG,
			tp,
			HINTMSG_DESTROY
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


		---------------------------------
		--合并破坏
		---------------------------------

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
--② 被破坏的「永续陷阱」判定
---------------------------------

function s.repfilter(c,tp)

	return c:IsControler(tp)
		and c:IsOnField()
		and c:IsType(TYPE_TRAP)
		and c:IsType(TYPE_CONTINUOUS)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and not c:IsReason(REASON_REPLACE)

end


---------------------------------
--② 破坏代替发动条件
---------------------------------

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)

	local c=e:GetHandler()

	if chk==0 then

		return eg:IsExists(
			s.repfilter,
			1,
			nil,
			tp
		)
		and Duel.IsExistingMatchingCard(
			aux.TRUE,
			tp,
			0,
			LOCATION_ONFIELD,
			1,
			nil
		)

	end

	---------------------------------
	--选择是否使用②
	---------------------------------

	return Duel.SelectEffectYesNo(
		tp,
		c,
		96
	)

end


---------------------------------
--② 指定哪些卡可以被代替
---------------------------------

function s.desrepval(e,c)

	return s.repfilter(
		c,
		e:GetHandlerPlayer()
	)

end


---------------------------------
--② 代替处理
---------------------------------

function s.desrepop(e,tp,eg,ep,ev,re,r,rp)

	---------------------------------
	--选择对方场上1张卡
	---------------------------------

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_DESREPLACE
	)

	local g=Duel.GetMatchingGroup(
		aux.TRUE,
		tp,
		0,
		LOCATION_ONFIELD,
		nil
	)

	if #g>0 then

		g=g:Select(
			tp,
			1,
			1,
			nil
		)

		if #g>0 then

			Duel.Destroy(
				g,
				REASON_REPLACE+REASON_EFFECT
			)

		end

	end

end