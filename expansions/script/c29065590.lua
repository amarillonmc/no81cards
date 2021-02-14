--长眠尽头的醒唤
function c29065590.initial_effect(c)
	aux.AddCodeList(c,29065577)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,29065590+EFFECT_COUNT_CODE_OATH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065590,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29065590.thtg)
	e2:SetOperation(c29065590.thop)
	c:RegisterEffect(e2)   
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c29065590.desreptg)
	e2:SetValue(c29065590.desrepval)
	e2:SetOperation(c29065590.desrepop)
	c:RegisterEffect(e2)
end
function c29065590.tdfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x87af)
end
function c29065590.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(29065591) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c29065590.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMatchingGroupCount(c29065590.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>=1) or (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065577) and Duel.IsExistingMatchingCard(c29065590.spfil,tp,LOCATION_MZONE,0,1,nil,e,tp)) end
	if (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065577) and Duel.IsExistingMatchingCard(c29065590.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) and Duel.SelectYesNo(tp,aux.Stringid(29065590,0)) then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,0)
	e:SetLabel(0)
	else
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,0)
	e:SetLabel(1)
	end 
end
function c29065590.thop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
	if Duel.GetMatchingGroupCount(c29065590.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>0 then
	local tc=Duel.SelectMatchingCard(tp,c29065590.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)  
	end
	else
	local g=Duel.GetMatchingGroup(c29065590.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=1 then
	local xg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c29065590.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
end
function c29065590.rmfil(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x87af) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c29065590.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c29065590.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c29065590.rmfil,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c29065590.desrepval(e,c)
	return c29065590.repfilter(c,e:GetHandlerPlayer())
end
function c29065590.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c29065590.rmfil,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,29065590)
end










