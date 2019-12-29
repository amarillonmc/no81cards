--fate·迷之女主角XX战损版
function c9950574.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c9950574.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c9950574.splimit)
	c:RegisterEffect(e4)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c9950574.actcon)
	c:RegisterEffect(e1)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950574,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,9950574)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9950574.cost)
	e3:SetOperation(c9950574.operation)
	c:RegisterEffect(e3)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950574.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9950574.material_type=TYPE_SYNCHRO
function c9950574.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950574,0))
end
function c9950574.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function c9950574.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandler():GetControler()  and e:GetHandler():IsAttackPos()
end
function c9950574.ffilter(c)
	return c:IsSetCard(0xba5) and c:IsFusionType(TYPE_SYNCHRO)
end
function c9950574.actcon(e)
	local a=Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and a:IsSetCard(0xba5)
end
function c9950574.filter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c9950574.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950574.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950574.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c9950574.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code, RESET_EVENT+RESETS_STANDARD)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950574,0))
end