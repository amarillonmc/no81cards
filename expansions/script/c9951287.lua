--伊莉雅-Berseker形态
function c9951287.initial_effect(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaba8),aux.FilterBoolFunction(Card.IsLevelAbove,5),true)
  --To hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951287,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c9951287.thcon)
	e4:SetTarget(c9951287.thtg)
	e4:SetOperation(c9951287.thop)
	c:RegisterEffect(e4)
 --ATK Gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9951287.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
 --Pos Change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_POSITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c9951287.target)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e5)
	--Prevent Activation
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetValue(c9951287.aclimit)
	c:RegisterEffect(e6)
  --Extra Attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdcon)
	e4:SetTarget(c9951287.atktg)
	e4:SetOperation(c9951287.atkop)
	c:RegisterEffect(e4)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951287.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951287.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951287,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951287,1))
end
function c9951287.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c9951287.filter(c)
	return c:IsSetCard(0xaba8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951287.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951287.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951287.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9951287.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951287.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951287,0))
end
function c9951287.val(e,c)
	return Duel.GetMatchingGroupCount(c9951287.filter2,c:GetControler(),0,LOCATION_GRAVE+LOCATION_MZONE,nil)*1000
end
function c9951287.filter2(c)
	return (c:IsLevelAbove(5) or c:IsLinkAbove(3) or c:IsRankAbove(5)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c9951287.target(e,c)
	return c:IsLevelAbove(5) or c:IsRankAbove(5)
end
function c9951287.aclimit(e,re,tp)
	return (re:GetHandler():IsLevelAbove(5) or re:GetHandler():IsRankAbove(5) or re:GetHandler():IsLinkAbove(3)) and re:IsActiveType(TYPE_MONSTER)
end
function c9951287.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) end
end
function c9951287.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951287,0))
end