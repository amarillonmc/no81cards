--破晓连结 优衣
function c10700231.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10700231.lcheck)
	c:EnableReviveLimit()
	--link
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e0:SetCondition(c10700231.lkcon)  
	e0:SetOperation(c10700231.lkop)  
	c:RegisterEffect(e0)	
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700231,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10700231+EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c10700231.negcon)
	e1:SetTarget(c10700231.negtg)
	e1:SetOperation(c10700231.negop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c10700231.negcon2)
	c:RegisterEffect(e2)  
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700221,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10700232)
	e4:SetTarget(c10700231.thtg)
	e4:SetOperation(c10700231.thop)
	c:RegisterEffect(e4)   
end
function c10700231.lcheck(g,lc)
	return g:IsExists(c10700231.mzfilter,1,nil)
end
function c10700231.mzfilter(c)
	return c:IsLinkSetCard(0x3a01) and not c:IsLinkType(TYPE_LINK)
end
function c10700231.lkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c10700231.lkop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("骑士君，终于见到你了！")
	Debug.Message("可以的话，我想为你提供帮助……")
	Debug.Message("今后也请多关照哦。")
end
function c10700231.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkState() and e:GetHandler():GetMutualLinkedGroupCount()==0
end
function c10700231.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c10700231.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c10700231.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700231.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10700231.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Debug.Message("交给我吧！")
	Debug.Message("我来治愈大家")
end
function c10700231.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
function c10700231.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c10700231.thfilter(c)
	return c:IsSetCard(0x3a01) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700231.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700231.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700231.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700231.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end