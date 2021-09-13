--方舟骑士-薪火的帕拉斯
function c82568051.initial_effect(c)
	c:EnableReviveLimit()
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(82568051,1))
	e3:SetCountLimit(1,82568051)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c82568051.rccon)
	e3:SetTarget(c82568051.rctg)
	e3:SetOperation(c82568051.rcop)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568051,1))
	e4:SetCategory(CATEGORY_COUNTER + CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82568051.ctcon)
	e4:SetTarget(c82568051.cttg)
	e4:SetOperation(c82568051.ctop)
	c:RegisterEffect(e4)
	--chain attack
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82568051,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(c82568051.atcon)
	e6:SetOperation(c82568051.atop)
	c:RegisterEffect(e6)
end
function c82568051.rccon(e)
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL 
		   and Duel.GetLP(tp)<=4000
end
function c82568051.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return true end
	 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,nil)
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82568051.rcfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x825) and c:IsAbleToHand()
end
function c82568051.rcfilter2(c)
	return c:IsCode(82567785)
end
function c82568051.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c82568051.rcfilter,tp,LOCATION_DECK,0,1,nil) and 
	   Duel.IsExistingMatchingCard(c82568051.rcfilter2,tp,LOCATION_DECK,0,1,nil) and
	   Duel.SelectYesNo(tp,aux.Stringid(82568051,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82568051.rcfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c82568051.rcfilter2,tp,LOCATION_DECK,0,1,1,nil)
	g:Merge(g2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
end
function c82568051.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x825) and rp==tp and 
	not re:GetHandler():IsCode(82568051) and Duel.GetLP(tp)>=4000 and  re:GetHandler():IsFaceup() 
	and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c82568051.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return true end
	e:SetLabelObject(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,nil,nil)
end
function c82568051.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Damage(tp,200,REASON_EFFECT) 
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)
	then tc:AddCounter(0x5825,1)
	end
end
function c82568051.atfilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82568051.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.bdcon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable() and Duel.GetAttacker()==c and
	 Duel.IsExistingMatchingCard(c82568051.atfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82568051.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c82568051.atfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if e:GetHandler():IsRelateToEffect(e) then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(500)
	tc:RegisterEffect(e2)
	end
	Duel.ChainAttack()
end