--雾动机龙·嵌合体
function c50223040.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,2,c50223040.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50223040,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,50223040)
	e1:SetCondition(c50223040.thcon)
	e1:SetTarget(c50223040.thtg)
	e1:SetOperation(c50223040.thop)
	c:RegisterEffect(e1)
	--special summon from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50223040,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50223041)
	e2:SetTarget(c50223040.sptg)
	e2:SetOperation(c50223040.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50223040,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,50223042)
	e3:SetCondition(c50223040.scon)
	e3:SetTarget(c50223040.stg)
	e3:SetOperation(c50223040.sop)
	c:RegisterEffect(e3)
end
function c50223040.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd8)
end
function c50223040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50223040.thfilter(c,e)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsAbleToHand()
end
function c50223040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(c50223040.thfilter,nil)
	if chk==0 then return mg:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,mg:GetCount(),tp,LOCATION_EXTRA)
end
function c50223040.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(c50223040.thfilter,nil)
	if mg:GetCount()>0 then
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
end
function c50223040.tfilter(c,e,tp)
	local ec=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xd8) and ec:GetLinkedGroup():IsContains(c)
	and (not e or c:IsCanBeEffectTarget(e)) and Duel.IsExistingMatchingCard(c50223040.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c50223040.spfilter(c,e,tp,tc)
	return c:IsSetCard(0xd8) and c:IsLevel(tc:GetLevel())
		and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50223040.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=eg:Filter(c50223040.tfilter,nil,e,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tg=g:Clone()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tg=g:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,0,0)
end
function c50223040.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50223040.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c50223040.sfilter(c,e,tp)
	return c:IsSetCard(0xd8) and c:IsFaceup() and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_PZONE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50223040.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50223040.sfilter,1,nil,e,tp)
end
function c50223040.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 end
	local g=eg:Filter(c50223040.sfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50223040.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=g:Select(tp,1,1,nil)
	if rg:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end