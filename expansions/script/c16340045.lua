--深海舰队 O级航空母舰
--16340045

local s,id=GetID()

function s.initial_effect(c)

	---------------------------------
	--① 解放1只怪兽，从手卡·墓地特殊召唤
	---------------------------------

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
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
--① 解放
---------------------------------

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return Duel.IsExistingMatchingCard(
			aux.TRUE,
			tp,
			LOCATION_MZONE,
			0,
			1,
			nil
		)
	end

	local g=Duel.SelectMatchingCard(
		tp,
		aux.TRUE,
		tp,
		LOCATION_MZONE,
		0,
		1,
		1,
		nil
	)

	Duel.Release(g,REASON_COST)

end


---------------------------------
--① 特殊召唤过滤
---------------------------------

function s.spfilter(c,e,tp)

	return c:IsSetCard(0x3dce)
		and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(
			e,
			0,
			tp,
			false,
			false
		)

end


function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.spfilter,
			tp,
			LOCATION_HAND+LOCATION_GRAVE,
			0,
			1,
			nil,
			e,
			tp
		)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		1,
		tp,
		LOCATION_HAND+LOCATION_GRAVE
	)

end


function s.spop(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.SelectMatchingCard(
		tp,
		s.spfilter,
		tp,
		LOCATION_HAND+LOCATION_GRAVE,
		0,
		1,
		1,
		nil,
		e,
		tp
	)

	local tc=g:GetFirst()

	if tc then

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
--② 永续陷阱发动条件
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


---------------------------------
--② 选择效果
---------------------------------

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)

	local c=e:GetHandler()

	--效果①：特殊召唤自身
	local b1=c:IsCanBeSpecialSummoned(
		e,
		0,
		tp,
		false,
		false
	)

	--效果②：至少有2个怪兽区空位
	local b2=Duel.GetLocationCount(
		tp,
		LOCATION_MZONE
	)>=2

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


---------------------------------
--② 执行
---------------------------------

function s.effop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	---------------------------------
	--① 自身特殊召唤
	---------------------------------

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


	---------------------------------
	--② 破坏+2 Token
	---------------------------------

	else

		if not c:IsRelateToEffect(e) then
			return
		end

		Duel.Destroy(
			c,
			REASON_EFFECT
		)


		--生成2只深海舰队飞机衍生物

		for i=1,2 do

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


		---------------------------------
		--额外卡组特殊召唤限制
		---------------------------------

		local e1=Effect.CreateEffect(c)

		e1:SetType(EFFECT_TYPE_FIELD)

		e1:SetCode(
			EFFECT_CANNOT_SPECIAL_SUMMON
		)

		e1:SetProperty(
			EFFECT_FLAG_PLAYER_TARGET
		)

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


---------------------------------
--额外卡组限制
---------------------------------

function s.sumlimit(e,c)

	return c:IsLocation(LOCATION_EXTRA)
		and not c:IsSetCard(0x3dce)

end