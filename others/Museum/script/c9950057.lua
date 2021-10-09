--局中法度·土方岁三
function c9950057.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5ba5),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9950057+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c9950057.spcon)
	c:RegisterEffect(e1)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950057,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c9950057.condition)
	e1:SetCost(c9950057.cost)
	e1:SetTarget(c9950057.target)
	e1:SetOperation(c9950057.activate)
	c:RegisterEffect(e1)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950057,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9950057.drcon)
	e1:SetTarget(c9950057.drtg)
	e1:SetOperation(c9950057.drop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950057.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950057.spcon(e,tp,eg,ep,ev,re,r,rp)
	 local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9950057.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950057,3))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950057,4))
end
function c9950057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=4000 and Duel.GetAttackTarget()~=nil
end
function c9950057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9950057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9950057.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(8000-Duel.GetLP(tp))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950057,3))
end
function c9950057.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c9950057.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9950057.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)==8000 then return end
	Duel.SetLP(tp,8000)
	Duel.Draw(tp,2,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950057,3))
end