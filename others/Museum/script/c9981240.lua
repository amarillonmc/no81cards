--骑士时刻王蛇·基础形态2002
function c9981240.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,c9981240.mfilter,1,1)
	c:EnableReviveLimit()
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981240,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9981240)
	e1:SetTarget(c9981240.thtg)
	e1:SetOperation(c9981240.thop)
	c:RegisterEffect(e1)
 --atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981240,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
   e3:SetCountLimit(1)
	e3:SetCondition(c9981240.atkcon)
	e3:SetOperation(c9981240.atkop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981240.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981240.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981240,0))
end 
function c9981240.mfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xbca)
end
function c9981240.thfilter(c)
	return c:IsSetCard(0xbca) and not c:IsCode(9981240) and c:IsAbleToHand()
end
function c9981240.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9981240.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981240.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9981240.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9981240.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981240,0))
end
function c9981240.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetBaseAttack()*2~=c:GetAttack()
end
function c9981240.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(bc:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981240,0))
end