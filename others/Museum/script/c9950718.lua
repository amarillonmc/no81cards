--欧布·雷霆奇迹
function c9950718.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddCodeList(c,9950282)
   --code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(9950282)
	c:RegisterEffect(e1)
	  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9950718.sprcon)
	e1:SetOperation(c9950718.sprop)
	c:RegisterEffect(e1)
--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950718,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9950718.drcon)
	e1:SetTarget(c9950718.drtg)
	e1:SetOperation(c9950718.drop)
	c:RegisterEffect(e1)
--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950718,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,9950718)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9950718.cost)
	e3:SetOperation(c9950718.operation)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950718.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950718.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950718,0))
end
function c9950718.sprfilter(c,e,tp)
	return (c:IsCode(9950282) or aux.IsCodeListed(c,9950282)) and not c:IsCode(9950718) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() 
end
function c9950718.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9950718.sprfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
end
function c9950718.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950718.sprfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	local rc=g:GetFirst()
	Duel.SendtoGrave(rc,REASON_COST)
end
function c9950718.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:IsSummonType(SUMMON_TYPE_SPECIAL) and tg:IsLevelAbove(8) 
end
function c9950718.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950718.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9950718.filter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x9bd1) and c:IsAbleToRemoveAsCost()
end
function c9950718.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950718.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950718.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c9950718.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end