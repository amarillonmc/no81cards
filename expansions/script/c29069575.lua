--方舟骑士-艾雅法拉
function c29069575.initial_effect(c)
	aux.AddCodeList(c,29065532)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29069575,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29069575)
	e1:SetCondition(c29069575.srcon)
	e1:SetTarget(c29069575.srtg)
	e1:SetOperation(c29069575.srop)
	c:RegisterEffect(e1)
	c29069575.summon_effect=e1  
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,29069576)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c29069575.rmtg)
	e4:SetOperation(c29069575.rmop)
	c:RegisterEffect(e4)
end
function c29069575.refilter(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsReleasableByEffect()
end
function c29069575.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c29069575.refilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(Card.IsAbleToRemove,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c29069575.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.SelectMatchingCard(tp,c29069575.refilter,tp,LOCATION_MZONE,0,1,99,nil)
		if rg:GetCount()>0 then
			local rct=Duel.Release(rg,REASON_EFFECT)
			if rct>0 then
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,rct*2,nil)
					if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then 
						local rg1=Duel.GetOperatedGroup()
						local ct=rg1:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
							if ct>0 then
								Duel.Damage(1-tp,ct*600,REASON_EFFECT)
							end
					end
			end
		end
end
--e1
function c29069575.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c29069575.srfilter(c)
	return c:IsSetCard(0x57af) and c:IsAbleToHand()
end
function c29069575.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29069575.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29069575.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29069575.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end