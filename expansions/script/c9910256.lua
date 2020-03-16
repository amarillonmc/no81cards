--幽鬼王子 河野初雪
function c9910256.initial_effect(c)
	c:EnableCounterPermit(0x953)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910256)
	e1:SetCondition(c9910256.spcon)
	e1:SetOperation(c9910256.spop)
	c:RegisterEffect(e1)
	--add counter / counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c9910256.cttg)
	e2:SetOperation(c9910256.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910256.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x953,2,REASON_COST)
end
function c9910256.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x953,2,REASON_COST)
end
function c9910256.thfilter(c)
	return c:IsSetCard(0x953) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(9910256)
end
function c9910256.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanAddCounter(0x953,3) and Duel.GetFlagEffect(tp,9910256)==0
	local b2=Duel.IsExistingMatchingCard(c9910256.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,9910257)==0
	if chk==0 then return b1 or b2 end
end
function c9910256.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsRelateToEffect(e) and c:IsCanAddCounter(0x953,3) and Duel.GetFlagEffect(tp,9910256)==0
	local b2=Duel.IsExistingMatchingCard(c9910256.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,9910257)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9910256,0),aux.Stringid(9910256,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9910256,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(9910256,1))+1
	else return end
	if op==0 then
		c:AddCounter(0x953,3)
		Duel.RegisterFlagEffect(tp,9910256,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910256.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.RegisterFlagEffect(tp,9910257,RESET_PHASE+PHASE_END,0,1)
	end
end
