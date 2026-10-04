--深海舰队 总旗舰 Abyss Yamato
--16340075

local s,id=GetID()

function s.initial_effect(c)

	---------------------------------
	-- Link召唤
	---------------------------------

	aux.AddLinkProcedure(c,s.matfilter,5,5)
	c:EnableReviveLimit()


	---------------------------------
	-- ① Link召唤成功
	-- 尽可能将「深海舰队」怪兽放置为永续陷阱
	-- 然后从魔陷区特殊召唤
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
	-- ② 对方发动效果
	-- 送墓1张「深海舰队」卡
	-- 无效并破坏
	-- 给对方800伤害
	---------------------------------

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
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
	-- ③ 被对方战斗破坏
	-- 破坏自己场上的全部卡
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
-- 「深海舰队」效果怪兽5只
---------------------------------

function s.matfilter(c)
	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_EFFECT)
end


---------------------------------
-- Link召唤成功
---------------------------------

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end


---------------------------------
-- 从手卡·墓地·除外区选择
-- 非Link「深海舰队」怪兽
---------------------------------

function s.srcfilter(c)
	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_LINK)
end


---------------------------------
-- 魔陷区的「深海舰队」怪兽
--
-- 参考 16322110 的写法
---------------------------------

function s.spfilter2(c,e,tp)
	return c:IsFaceup()
		and c:IsSetCard(0x3dce)
		and c:GetOriginalType()&TYPE_MONSTER>0
		and c:GetSequence()<5
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


---------------------------------
-- ①发动条件
---------------------------------

function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)

	---------------------------------
	-- 当前魔陷区可放置数量
	---------------------------------

	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)

	---------------------------------
	-- 可以从手卡·墓地·除外区
	-- 放置的「深海舰队」怪兽
	---------------------------------

	local g=Duel.GetMatchingGroup(
		s.srcfilter,
		tp,
		LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		nil
	)

	---------------------------------
	-- 魔陷区已经存在的
	-- 「深海舰队」怪兽
	---------------------------------

	local rg=Duel.GetMatchingGroup(
		s.spfilter2,
		tp,
		LOCATION_SZONE,
		0,
		nil,
		e,
		tp
	)

	if chk==0 then
		-- 能放置，或者已经有可以特殊召唤的魔陷区怪兽
		return (ft>0 and #g>0)
			or (#rg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
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


---------------------------------
-- ①效果处理
---------------------------------

function s.lkop(e,tp,eg,ep,ev,re,r,rp)

	---------------------------------
	-- 先处理放置
	---------------------------------

	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)

	local g=Duel.GetMatchingGroup(
		s.srcfilter,
		tp,
		LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		nil
	)

	if ft>0 and #g>0 then

		---------------------------------
		-- 尽可能放置
		---------------------------------

		local sg

		if #g<=ft then
			sg=g
		else
			Duel.Hint(
				HINT_SELECTMSG,
				tp,
				HINTMSG_TOFIELD
			)

			sg=g:Select(
				tp,
				ft,
				ft,
				nil
			)
		end

		for tc in aux.Next(sg) do

			if Duel.MoveToField(
				tc,
				tp,
				tp,
				LOCATION_SZONE,
				POS_FACEUP,
				true
			) then

				---------------------------------
				-- 变成永续陷阱
				---------------------------------

				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(
					RESET_EVENT
					+RESETS_STANDARD
					-RESET_TURN_SET
				)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)

			end
		end
	end


	---------------------------------
	-- 再从魔陷区特殊召唤
	---------------------------------

	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end

	local rg=Duel.GetMatchingGroup(
		s.spfilter2,
		tp,
		LOCATION_SZONE,
		0,
		nil,
		e,
		tp
	)

	if #rg==0 then
		return
	end

	---------------------------------
	-- 这里按照 16322110 的方式
	-- 从魔陷区选择可特殊召唤的本家怪兽
	---------------------------------

	Duel.BreakEffect()

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_SPSUMMON
	)

	local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)

	if ft2<=0 then
		return
	end

	local sg=rg:Select(
		tp,
		1,
		math.min(ft2,#rg),
		nil,
		e,
		tp
	)

	if #sg==0 then
		return
	end

	---------------------------------
	-- 特殊召唤
	---------------------------------

	Duel.SpecialSummon(
		sg,
		0,
		tp,
		tp,
		false,
		false,
		POS_FACEUP
	)

end


---------------------------------
-- ② 无效效果
---------------------------------

function s.negfilter(c)
	return c:IsSetCard(0x3dce)
		and c:IsAbleToGraveAsCost()
end


function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
		and Duel.IsChainNegatable(ev)
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

	Duel.SendtoGrave(
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
		CATEGORY_NEGATE,
		eg,
		1,
		0,
		0
	)

	Duel.SetOperationInfo(
		0,
		CATEGORY_DESTROY,
		eg,
		1,
		0,
		0
	)

	Duel.SetOperationInfo(
		0,
		CATEGORY_DAMAGE,
		nil,
		0,
		1-tp,
		800
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
-- ③ 战斗破坏
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