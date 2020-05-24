--凯尔特·斯卡哈
function c9950642.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,3,4,c9950642.ovfilter,aux.Stringid(9950642,1),3,c9950642.xyzop)
	c:EnableReviveLimit()
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950642.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9950642.defval)
	c:RegisterEffect(e2)
  --to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950642,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9950642.cost)
	e2:SetTarget(c9950642.tgtg)
	e2:SetOperation(c9950642.tgop)
	c:RegisterEffect(e2)
 --
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950642,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetTarget(c9950642.xyztg)
	e4:SetOperation(c9950642.xyzop)
	c:RegisterEffect(e4)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950642.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950642.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950642,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950642,4))
end
function c9950642.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ba2) and not c:IsCode(9950642)
end
function c9950642.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9950642)==0 end
	Duel.RegisterFlagEffect(tp,9950642,RESET_PHASE+PHASE_END,0,1)
end
function c9950642.atkfilter(c)
	return c:IsSetCard(0x6ba2) and c:GetAttack()>=0
end
function c9950642.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950642.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9950642.deffilter(c)
	return c:IsSetCard(0x6ba2) and c:GetDefense()>=0
end
function c9950642.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950642.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c9950642.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950642.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c9950642.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950642,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9950642,5))
end
function c9950642.xyzfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c9950642.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9950642.xyzfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c9950642.xyzfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9950642.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950642,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9950642,6))
end