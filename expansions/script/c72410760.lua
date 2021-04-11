--狩猎千龙之兽 蒂拉
function c72410760.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410760,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,72410760)
	e1:SetTarget(c72410760.sptg)
	e1:SetOperation(c72410760.spop)
	c:RegisterEffect(e1)
		--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410760,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72410761)
	e2:SetTarget(c72410760.destg)
	e2:SetOperation(c72410760.desop)
	c:RegisterEffect(e2)
end
function c72410760.spcostfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DINOSAUR) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.GetMZoneCount(tp,c)>0
end
function c72410760.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c72410760.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c72410760.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c72410760.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c72410760.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
		and Duel.IsExistingMatchingCard(c72410760.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c72410760.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c72410760.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72410760.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c72410760.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c72410760.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c72410760.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c72410760.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRace(RACE_DINOSAUR) then
		local g=Duel.GetMatchingGroup(c72410760.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if g:GetCount()>0 then
			g:AddCard(tc)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end