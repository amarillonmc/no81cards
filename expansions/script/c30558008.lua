--破灭幻械 -[创造者]-
function c30558008.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c30558008.activate)
	c:RegisterEffect(e0)
	 --summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,0)
	e1:SetTarget(c30558008.extg)
	e1:SetValue(POS_FACEUP_ATTACK)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c30558008.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--tohand&spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,30558008)
	e3:SetTarget(c30558008.tg)
	e3:SetOperation(c30558008.op)
	c:RegisterEffect(e3)
end
function c30558008.tgfil(c)
	return c:IsSetCard(0x307) and c:IsAbleToHand()
end
function c30558008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30558008.tgfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c30558008.tgfil2(c)
	return c:IsSetCard(0x307) and c:IsSummonable(true,nil)
end
function c30558008.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c30558008.tgfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then 
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(c30558008.tgfil2,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(30558008,1)) then
				local sg=Duel.SelectMatchingCard(tp,c30558008.tgfil2,tp,LOCATION_HAND,0,1,1,nil)
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function c30558008.extg(e,c)
	return c~=e:GetHandler()
end
function c30558008.eftg(e,c)
	return c:IsSetCard(0x307)
end
function c30558008.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x307) and c:IsAbleToHand()
end
function c30558008.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c30558008.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(30558008,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end