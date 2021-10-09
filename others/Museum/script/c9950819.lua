--fate·亚德
function c9950819.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9950819.mfilter,1)
--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c9950819.costchange)
	c:RegisterEffect(e2)
 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950819,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9950819.eqtg)
	e1:SetOperation(c9950819.eqop)
	c:RegisterEffect(e1)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950819,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c9950819.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9950819.sptg)
	e2:SetOperation(c9950819.spop)
	c:RegisterEffect(e2)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950819.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950819.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950819,0))
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950819,1))
end
function c9950819.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2 and c:IsSetCard(0xba5)
end
function c9950819.costchange(e,re,rp,val)
	if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP) and not re:GetHandler():IsCode(9236985,57496978) then
		return 0
	else
		return val
	end
end
function c9950819.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950819.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9950819.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9950819.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9950819.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c9950819.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9950819.eqlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
Duel.Hint(HINT_SOUND,0,aux.Stringid(9950819,2))
end
function c9950819.eqlimit(e,c)
	return c:IsSetCard(0xba5)
end
function c9950819.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c9950819.spfilter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950819.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c9950819.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950819.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950819.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950819.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
