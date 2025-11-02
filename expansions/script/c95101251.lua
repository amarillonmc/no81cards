--惑界蛇 弗朗西斯·里德尔
function c95101251.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,nil,1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c95101251.atkval)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c95101251.tnval)
	c:RegisterEffect(e2)
	--cosplay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101251,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c95101251.costg)
	e3:SetOperation(c95101251.cosop)
	c:RegisterEffect(e3)
end
function c95101251.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsCode,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,c:GetCode())*100
end
function c95101251.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c95101251.costg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsLevelAbove(1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsLevelAbove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsLevelAbove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,1)
end
function c95101251.cosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local race=tc:GetRace()
		local attr=tc:GetAttribute()
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(race)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(attr)
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(lv)
		c:RegisterEffect(e4)
	end
end
