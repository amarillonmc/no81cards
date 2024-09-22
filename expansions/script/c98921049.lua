--遥远的故乡 网罟座泽塔星
function c98921049.initial_effect(c)
	aux.AddCodeList(c,64382839)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921049+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98921049.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c98921049.atkvalue)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921049,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(c98921049.discon)
	e3:SetTarget(c98921049.distg)
	e3:SetOperation(c98921049.disop)
	c:RegisterEffect(e3)
end
function c98921049.thfilter(c)
	return aux.IsCodeListed(c,64382839) and not c:IsCode(98921049) and c:IsAbleToHand()
end
function c98921049.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98921049.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98921049,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c98921049.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c98921049.atkvalue(e,c)
	local g=Duel.GetMatchingGroup(c98921049.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)
	local ct=g:GetCount()
	return ct*100
end
function c98921049.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(64382840) and c:IsControler(tp)
end
function c98921049.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921049.cfilter,1,nil,tp)
end
function c98921049.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921049.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98921049.filter(c)
	return c:IsLinkSummonable(nil)
end
function c98921049.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98921049.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end