--解封灵使 希塔
function c10700433.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700433,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e1:SetCountLimit(1,10700433)
	e1:SetCondition(c10700433.spcon)
	e1:SetOperation(c10700433.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700433,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e2:SetCountLimit(1,10700433)
	e2:SetCondition(c10700433.spcon2)
	e2:SetOperation(c10700433.spop2)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700433,2))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10700433.discon)
	e3:SetCost(c10700433.discost)
	e3:SetTarget(c10700433.distg)
	e3:SetOperation(c10700433.disop)
	c:RegisterEffect(e3)
	--flip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700433,2))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e4:SetTarget(c10700433.distg)
	e4:SetOperation(c10700433.disop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700433,4))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,10700434)
	e5:SetTarget(c10700433.thtg)
	e5:SetOperation(c10700433.thop)
	c:RegisterEffect(e5)
end
function c10700433.spfilter1(c,tp)
	return c:IsCode(759393) and c:IsAbleToGraveAsCost()
end
function c10700433.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10700433.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
end
function c10700433.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700433.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700433.spfilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function c10700433.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10700433.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,2,nil,tp)
end
function c10700433.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10700433.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,2,2,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10700433.discon(e,tp,eg,ep,ev,re,r,rp)
	return rc~=e:GetHandler()
end 
function c10700433.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end  
	local pos=Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK)  
	Duel.ChangePosition(c,pos)
end  
function c10700433.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c10700433.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10700433.ctfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c10700433.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c10700433.cfilter(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsSetCard(0xbf)) and c:IsType(TYPE_MONSTER) and not c:IsCode(10700433)
end
function c10700433.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e)
		and not tc:IsImmuneToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c10700433.ctcon)
		tc:RegisterEffect(e1)
		 if (Duel.GetMatchingGroupCount(c10700433.cfilter,tp,LOCATION_MZONE,0,1,nil)>=1 or tc:IsAttribute(ATTRIBUTE_FIRE) or tc:IsSetCard(0xbf)) and Duel.SelectYesNo(tp,aux.Stringid(10700433,3)) then   
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		 end
	end
end
function c10700433.ctcon(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	return c:IsHasCardTarget(h)
end
function c10700433.thfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDefense(1500) and c:IsAbleToHand()) or c:IsSetCard(0xbf) or c:IsSetCard(0xc0)
end
function c10700433.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700433.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700433.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700433.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end