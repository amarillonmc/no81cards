--苍岚水师 罗兰
function c33200709.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,33200711+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c33200709.spcon0)
	e0:SetOperation(c33200709.spop0)
	c:RegisterEffect(e0)
	--att change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200709,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33200709)
	e1:SetTarget(c33200709.sptg)
	e1:SetOperation(c33200709.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200709,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33200710)
	e2:SetTarget(c33200709.rmtg)
	e2:SetOperation(c33200709.rmop)
	c:RegisterEffect(e2)
end

--e0
function c33200709.spfilter0(c)
	return c:IsSetCard(0xc32a) and c:IsAbleToRemoveAsCost()
end
function c33200709.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33200709.spfilter0,tp,LOCATION_GRAVE,0,1,nil)
end
function c33200709.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200709.spfilter0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--e1
function c33200709.spfilter(c,e,tp)
	local count=c:GetLink()
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xc32a) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) 
end
function c33200709.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c33200709.spfilter(chkc,e,tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33200709.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33200709.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	e:SetLabel(100)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33200709.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=100 then return end
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local count=tc:GetLink()
	if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT) then
		if Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33200709.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c33200709.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xc32a) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end

--e2
function c33200709.thfilter(c)
	return c:IsSetCard(0xc32a) and c:IsType(TYPE_MONSTER) and not c:IsCode(32200709) and c:IsAbleToHand()
end
function c33200709.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200709.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200709.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200709.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end