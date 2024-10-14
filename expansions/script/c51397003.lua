--K·G 华雪折像 冬华
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    c:SetSPSummonOnce(id)
    aux.AddCodeList(c,51397000)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.srcon)
	e1:SetTarget(s.srtg)
	e1:SetOperation(s.srop)
	c:RegisterEffect(e1)
end
function s.srfilter(c)
	return ((c:IsSetCard(0x3a03) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL)) or (c:IsSetCard(0xa00) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL))) and c:IsAbleToHand()
end
function s.sefilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        if Duel.IsExistingMatchingCard(s.sefilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetLocation(LOCATION_MZONE) then
            if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                local gs=Duel.GetMatchingGroup(s.sefilter,tp,LOCATION_DECK,0,nil)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
                local sg1=gs:Select(tp,1,1,nil)
                Duel.ConfirmCards(1-tp,sg1)
           		local e1=Effect.CreateEffect(e:GetHandler())
               	e1:SetType(EFFECT_TYPE_SINGLE)
            	e1:SetCode(EFFECT_CHANGE_LEVEL)
          		e1:SetValue(sg1:GetFirst():GetLevel())
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
           		e:GetHandler():RegisterEffect(e1)
            end
        end
	end
end