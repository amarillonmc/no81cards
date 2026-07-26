--熔岩蛇
local s,id,o=GetID()
function s.initial_effect(c)
	--①：特殊召唤并装备「熔岩」怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--②：无效并破坏，之后送墓1张「熔岩」卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+2)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
s.listed_series={0x39}

--①
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function s.eqfilter(c,e)
	return c:IsSetCard(0x39)
		and c:IsType(TYPE_MONSTER)
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
		and not c:IsType(TYPE_TOKEN)
		and not c:IsForbidden()
		and c:IsCanBeEffectTarget(e)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE)
			and aux.NecroValleyFilter(s.eqfilter)(chkc,e)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(
				aux.NecroValleyFilter(s.eqfilter),
				tp,
				LOCATION_MZONE+LOCATION_GRAVE,
				0,1,nil,e
			)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(
		tp,
		aux.NecroValleyFilter(s.eqfilter),
		tp,
		LOCATION_MZONE+LOCATION_GRAVE,
		0,1,1,nil,e
	)
	Duel.SetOperationInfo(
		0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND
	)
	Duel.SetOperationInfo(
		0,CATEGORY_EQUIP,g,1,tp,
		LOCATION_MZONE+LOCATION_GRAVE
	)
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if Duel.SpecialSummon(
		c,0,tp,tp,false,false,POS_FACEUP
	)==0 then
		return
	end
	if not tc
		or not tc:IsRelateToEffect(e)
		or not c:IsFaceup()
		or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
		or aux.NecroValleyNegateCheck(tc) then
		return
	end
	if not Duel.Equip(tp,tc,c,true) then return end
	--那只怪兽只能装备给这张卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(c)
	e1:SetValue(s.eqlimit)
	tc:RegisterEffect(e1)
end

--②
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
		and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainDisablable(ev)
end

function s.tgfilter(c)
	return c:IsSetCard(0x39)
		and c:IsAbleToGrave()
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil
		)
	end
	Duel.SetOperationInfo(
		0,CATEGORY_DISABLE,eg,1,0,0
	)
	Duel.SetOperationInfo(
		0,CATEGORY_DESTROY,eg,1,0,0
	)
	Duel.SetOperationInfo(
		0,CATEGORY_TOGRAVE,nil,1,tp,
		LOCATION_HAND+LOCATION_ONFIELD
	)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateEffect(ev) then return end
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
	Duel.BreakEffect()
	if not Duel.IsExistingMatchingCard(
		s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil
	) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(
		tp,s.tgfilter,tp,
		LOCATION_HAND+LOCATION_ONFIELD,0,
		1,1,nil
	)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
