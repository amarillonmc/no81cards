--IG-冠军卡蜜尔
function c9981565.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c9981565.ovfilter,aux.Stringid(9981565,0))
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981565.condition)
	e1:SetOperation(c9981565.regop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981565,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c9981565.drtg)
	e2:SetOperation(c9981565.drop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981565.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(9981565,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9981565)
	e2:SetCondition(c9981565.descon1)
	e2:SetCost(c9981565.descost)
	e2:SetTarget(c9981565.destg)
	e2:SetOperation(c9981565.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9981565.descon2)
	c:RegisterEffect(e3)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981565,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99815650)
	e2:SetCondition(c9981565.spcon)
	e2:SetTarget(c9981565.sptg)
	e2:SetOperation(c9981565.spop)
	c:RegisterEffect(e2)
end
function c9981565.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981565,1))
end
function c9981565.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9981565.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c9981565.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9981565.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(9981565) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c9981565.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bce) and c:IsType(TYPE_XYZ) and not c:IsCode(9981565) and c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_EQUIP)
end
function c9981565.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c9981565.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9981565.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981565.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9981565.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981565,1))
end
function c9981565.descon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9bce)
end
function c9981565.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9bce)
end
function c9981565.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981565.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9981565.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981565,1))
end
function c9981565.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetOverlayCount()==0 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9981565.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x9bce) and c:IsType(TYPE_XYZ) and not c:IsCode(9981565) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9981565.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c9981565.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9981565.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c)<=0 or not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9981565.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end