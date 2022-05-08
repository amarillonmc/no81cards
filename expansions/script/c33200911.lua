--寒霜灵兽 雪妖女
function c33200911.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200911)
	e1:SetCost(c33200911.spcost)
	e1:SetTarget(c33200911.sptg)
	e1:SetOperation(c33200911.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200911,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33210911)
	e2:SetCondition(c33200911.thcon)
	e2:SetTarget(c33200911.thtg)
	e2:SetOperation(c33200911.thop)
	c:RegisterEffect(e2)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200911.indcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end

--e1
function c33200911.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200911.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200911.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200911.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function c33200911.ffilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c33200911.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x332a) or c:IsSetCard(0x532a)) and c:IsFaceup() and c:IsAbleToHand()
end 
function c33200911.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200911.cfilter,1,nil,tp)
end
function c33200911.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200911.ffilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c33200911.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,0,LOCATION_EXTRA)
	if e:GetHandler():IsLocation(LOCATION_HAND) then 
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),nil,0,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_MZONE) then 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),nil,0,LOCATION_MZONE)
	end
end
function c33200911.thop(e,tp,eg,ep,ev,re,r,rp)
	local thc=Duel.GetMatchingGroupCount(c33200911.ffilter,tp,0,LOCATION_MZONE,nil)
	if thc>2 then thc=2 end
	if thc>0 and Duel.IsExistingMatchingCard(c33200911.thfilter,tp,LOCATION_EXTRA,0,1,nil) then
		local thg=Duel.SelectMatchingCard(tp,c33200911.thfilter,tp,LOCATION_EXTRA,0,1,thc,nil)
		if thg:GetCount()>0 then
			if Duel.SendtoHand(thg,tp,REASON_EFFECT) then
				Duel.ConfirmCards(1-tp,thg)
				Duel.BreakEffect()
				if e:GetHandler():IsLocation(LOCATION_ONFIELD) then
					Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
				elseif e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra() then 
					Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
				end
			end
		end
	end
end

--e4
function c33200911.indcon(e)
	return Duel.GetFlagEffect(tp,33200900)>0
end