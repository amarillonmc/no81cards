--天下布武·织田幕府
function c9950066.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3ba5),3,false)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9950066)
	e1:SetCondition(c9950066.spcon)
	c:RegisterEffect(e1)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950066,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950066)
	e1:SetTarget(c9950066.target)
	e1:SetOperation(c9950066.operation)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950066,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99500660)
	e2:SetCondition(c9950066.tgcon)
	e2:SetTarget(c9950066.tgtg)
	e2:SetOperation(c9950066.tgop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950066.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9950066.material_setcode=0x3ba5
function c9950066.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950066,1))
end
function c9950066.spcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)
end
function c9950066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c9950066.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<3 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,9950075,0x3ba5,0x4011,200,200,1,RACE_WARRIOR,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE,1-tp) then return end
	for i=1,3 do
		local token=Duel.CreateToken(tp,9950075)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
function c9950066.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3ba5) and not c:IsCode(9950066)
end
function c9950066.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950066.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950066.filter(c,tohand)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
		and (c:IsAbleToGrave() or (tohand and c:IsAbleToHand()))
end
function c9950066.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then
		local tohand=Duel.IsEnvironment(9950103)
		return Duel.IsExistingMatchingCard(c9950066.filter,tp,LOCATION_DECK,0,1,nil,tohand)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9950066.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tohand=Duel.IsEnvironment(9950103)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950066.filter,tp,LOCATION_DECK,0,1,1,nil,tohand)
	local tc=g:GetFirst()
	if not tc then return end
	if tohand and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(9950066,2))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950066,1))
end
