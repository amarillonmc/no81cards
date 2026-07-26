--熔岩于归
local s,id=GetID()
function s.initial_effect(c)
	--卡的发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①：破坏自己场上1张表侧卡，
	--从卡组特殊召唤1只「熔岩」怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(
		CATEGORY_DESTROY
		+CATEGORY_SPECIAL_SUMMON
	)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--②：自己的超量怪兽特殊召唤时，
	--墓地的这张卡成为那只怪兽的超量素材
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(
		EFFECT_TYPE_FIELD
		+EFFECT_TYPE_TRIGGER_O
	)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(
		EFFECT_FLAG_DELAY
		+EFFECT_FLAG_CARD_TARGET
	)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.ovcon)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
s.listed_series={0x39}

--①

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x39)
		and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(
			e,
			0,
			tp,
			false,
			false
		)
end

--选择这张卡破坏后，
--必须能确保至少存在1个可用怪兽区域
function s.desfilter(c,e,tp)
	return c:IsFaceup()
		and c:IsDestructable()
		and c:IsCanBeEffectTarget(e)
		and Duel.GetMZoneCount(tp,c)>0
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_ONFIELD)
			and s.desfilter(chkc,e,tp)
	end

	if chk==0 then
		return Duel.IsExistingTarget(
				s.desfilter,
				tp,
				LOCATION_ONFIELD,
				0,
				1,
				nil,
				e,
				tp
			)
			and Duel.IsExistingMatchingCard(
				s.spfilter,
				tp,
				LOCATION_DECK,
				0,
				1,
				nil,
				e,
				tp
			)
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_DESTROY
	)
	local g=Duel.SelectTarget(
		tp,
		s.desfilter,
		tp,
		LOCATION_ONFIELD,
		0,
		1,
		1,
		nil,
		e,
		tp
	)

	Duel.SetOperationInfo(
		0,
		CATEGORY_DESTROY,
		g,
		1,
		0,
		0
	)
	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		1,
		tp,
		LOCATION_DECK
	)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc
		or not tc:IsRelateToEffect(e) then
		return
	end

	--必须实际破坏成功
	if Duel.Destroy(
		tc,
		REASON_EFFECT
	)==0 then
		return
	end

	Duel.BreakEffect()

	--处理时重新检查怪兽区域
	if Duel.GetLocationCount(
		tp,
		LOCATION_MZONE
	)<=0 then
		return
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_SPSUMMON
	)
	local g=Duel.SelectMatchingCard(
		tp,
		s.spfilter,
		tp,
		LOCATION_DECK,
		0,
		1,
		1,
		nil,
		e,
		tp
	)

	if g:GetCount()>0 then
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

--②

--本次特殊召唤成功的，
--自己场上的表侧超量怪兽
function s.ovfilter(c,tp)
	return c:IsControler(tp)
		and c:IsLocation(LOCATION_MZONE)
		and c:IsFaceup()
		and c:IsType(TYPE_XYZ)
end

function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(
		s.ovfilter,
		1,
		nil,
		tp
	)
end

function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=eg:Filter(
		s.ovfilter,
		nil,
		tp
	)

	if chkc then
		return g:IsContains(chkc)
	end

	if chk==0 then
		return c:IsLocation(LOCATION_GRAVE)
			and c:IsCanOverlay()
			and g:GetCount()>0
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TARGET
	)
	local sg=g:Select(
		tp,
		1,
		1,
		nil
	)
	Duel.SetTargetCard(sg)

	Duel.SetOperationInfo(
		0,
		CATEGORY_LEAVE_GRAVE,
		c,
		1,
		tp,
		LOCATION_GRAVE
	)
end

function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()

	--这张卡必须仍能成为超量素材
	if not c:IsRelateToEffect(e)
		or not c:IsLocation(LOCATION_GRAVE)
		or not c:IsCanOverlay()
		or c:IsImmuneToEffect(e) then
		return
	end

	--目标必须仍是自己场上的表侧超量怪兽
	if not tc
		or not tc:IsRelateToEffect(e)
		or not tc:IsControler(tp)
		or not tc:IsLocation(LOCATION_MZONE)
		or not tc:IsFaceup()
		or not tc:IsType(TYPE_XYZ)
		or tc:IsImmuneToEffect(e) then
		return
	end

	Duel.Overlay(
		tc,
		Group.FromCards(c)
	)
end
