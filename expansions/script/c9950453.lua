--fate·超越XX
function c9950453.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,9950453)
	e1:SetCondition(c9950453.spcon)
	e1:SetOperation(c9950453.spop)
	c:RegisterEffect(e1)
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(c9950453.tgval)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c9950453.efilter)
	c:RegisterEffect(e4)
--increase lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950453,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9950453.lvcost)
	e2:SetTarget(c9950453.lvtg)
	e2:SetOperation(c9950453.lvop)
	c:RegisterEffect(e2)
  --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950453,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950453.thcon)
	e3:SetTarget(c9950453.thtg)
	e3:SetOperation(c9950453.thop)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950453.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950453.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950453,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950453,3))
end
function c9950453.spfilter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xba5) and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(5) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c9950453.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9950453.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,tp)
end
function c9950453.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950453.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950453.tgval(e,re,rp)
	return re:IsActiveType(TYPE_EFFECT)
end
function c9950453.efilter(e,re)
	return re:IsActiveType(TYPE_EFFECT)
end
function c9950453.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9950453.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5)
end
function c9950453.filter(c,tp)
	return c:IsFaceup() and Duel.CheckReleaseGroupEx(tp,c9950453.cfilter,1,c,c)
end
function c9950453.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9950453.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingTarget(c9950453.filter,tp,LOCATION_MZONE,0,1,nil,tp)
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c9950453.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local sg=Duel.SelectReleaseGroupEx(tp,c9950453.cfilter,1,1,tc,tc)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function c9950453.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950453,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9950453,4))
end
function c9950453.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9950453.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9950453.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950453.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950453.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9950453.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9950453.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950453,0))
end