--奇术师 万圣节女巫
function c10700273.initial_effect(c)
	c:SetUniqueOnField(1,0,10700273)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10700273.lcheck)
	c:EnableReviveLimit()   
	--coin result
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700273,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10700273)
	e1:SetCondition(c10700273.coincon1)
	e1:SetOperation(c10700273.coinop1)
	c:RegisterEffect(e1) 
	--reset  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(10700273,1))  
	e2:SetCategory(CATEGORY_POSITION)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)
	e2:SetTarget(c10700273.postg)  
	e2:SetOperation(c10700273.posop)  
	c:RegisterEffect(e2) 
end
function c10700273.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xf1a3)
end
function c10700273.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>0 then
		e:SetLabelObject(re)
		return (re:GetHandler():IsSetCard(0xf1a3) or aux.iscodelisted(re:GetHandler(),10700270))
	else return false end
end
function c10700273.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10700273.coincon2)
	e1:SetOperation(c10700273.coinop2)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c10700273.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c10700273.coinop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10700273)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
function c10700273.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10700273.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)  
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	end
end