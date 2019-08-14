--星光歌剧 神乐光
function c65010086.initial_effect(c)
	--summon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65010086,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c65010086.sumcon)
	e0:SetOperation(c65010086.sumop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65010086,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65010086)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65010086.thtg)
	e2:SetOperation(c65010086.thop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65010086,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65010084)
	e3:SetCost(c65010086.smcost)
	e3:SetTarget(c65010086.smtg)
	e3:SetOperation(c65010086.smop)
	c:RegisterEffect(e3)
end
function c65010086.refil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x9da0)
end
function c65010086.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c65010086.refil,tp,LOCATION_EXTRA,0,1,nil)
end
function c65010086.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c65010086.refil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65010086.showfilter(c,tp)
	local cd=c:GetCode()
	return c:IsSetCard(0x9da0) and Duel.IsExistingMatchingCard(c65010086.sumfilter,tp,LOCATION_HAND,0,1,c,cd) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c65010086.sumfilter(c,cd)
	return c:IsSetCard(0x9da0) and c:IsSummonable(true,nil,1) and not c:IsCode(cd)
end
function c65010086.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010086.showfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c65010086.showfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end
function c65010086.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c65010086.smop(e,tp,eg,ep,ev,re,r,rp)
	local cd=e:GetLabelObject():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c65010086.sumfilter,tp,LOCATION_HAND,0,1,1,nil,cd)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c65010086.thfil(c)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65010086.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65010086.thfil(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and not chkc==e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c65010086.thfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c65010086.thfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c65010086.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end