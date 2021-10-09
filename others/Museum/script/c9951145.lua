--妖妖梦·西行寺幽幽子
function c9951145.initial_effect(c)
	   --pendulum summon
	aux.EnablePendulumAttribute(c)
 --Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,9951145)
	e3:SetTarget(c9951145.drawtg)
	e3:SetOperation(c9951145.drawop)
	c:RegisterEffect(e3)
 --draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951145,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9951145.drcon)
	e3:SetTarget(c9951145.drtg)
	e3:SetOperation(c9951145.drop)
	c:RegisterEffect(e3)
 --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951145,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99511450)
	e1:SetTarget(c9951145.thtg)
	e1:SetOperation(c9951145.thop)
	c:RegisterEffect(e1)
   --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951145,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9951145.negcon)
	e3:SetTarget(c9951145.negtg)
	e3:SetOperation(c9951145.negop)
	c:RegisterEffect(e3)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951145.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951145.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951145,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951145,2))
end
function c9951145.cfilter2(c)
	return c:IsSetCard(0x3bd2)
end
function c9951145.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c9951145.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9951145.drawop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.DiscardHand(tp,c9951145.cfilter2,1,1,REASON_EFFECT)>0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951145,0))
  Duel.Hint(HINT_SOUND,0,aux.Stringid(9951145,3))
end
function c9951145.cfilter(c)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_EFFECT)~=0 and c:IsPreviousSetCard(0x3bd2)
end
function c9951145.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9951145.cfilter,1,nil)
end
function c9951145.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9951145.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951145,0))
  Duel.Hint(HINT_SOUND,0,aux.Stringid(9951145,3))
end
function c9951145.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9951145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951145.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c9951145.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951145.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951145,0))
  Duel.Hint(HINT_SOUND,0,aux.Stringid(9951145,3))
end
function c9951145.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c9951145.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9951145.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951145,0))
end