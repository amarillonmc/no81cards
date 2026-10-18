--破灭幻械 警戒型
local s,id,o=GetID()
function s.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(s.adcon)
	c:RegisterEffect(e1)
	 --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--wudieffect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(s.con)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCountLimit(1)
	e4:SetCondition(s.con2)
	c:RegisterEffect(e4)
end
function s.adcon(e,c)
	return c:IsSetCard(0x307)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) and Duel.IsChainDisablable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and  (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) and Duel.IsChainDisablable(ev) and not e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.tgfil(c)
	return (c:IsLevel(7) or c:IsRank(7)) and c:IsReleasable() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function s.tgfil2(c)
	return c:IsSetCard(0x307) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tgfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	local b2=e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and Duel.IsExistingMatchingCard(s.tgfil2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_ONFIELD)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsAbleToGrave() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if Duel.NegateEffect(ev) then
			if re:GetHandler():IsRelateToEffect(re) then
				Duel.SendtoGrave(eg,REASON_EFFECT)
			end
			local g
			local thf=false
			if c:IsSummonType(SUMMON_TYPE_ADVANCE) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				g=Duel.GetMatchingGroup(s.tgfil2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
				thf=true
			else
				g=Duel.GetMatchingGroup(s.tgfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
			end
			if g:GetCount()>0 then
				local sg=g:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				if sg:GetCount()>0 then
					if thf then
						Duel.SendtoHand(sg,tp,REASON_EFFECT)
					else
						Duel.Release(sg,REASON_EFFECT)
					end
				end
			end
	end
end
function s.spfilter(c,tp)
	return  Duel.GetMZoneCount(1-tp,c,tp)>0 and (c:IsReleasable(REASON_EFFECT) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
