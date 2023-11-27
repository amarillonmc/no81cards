--星光歌剧 神乐光
function c64832002.initial_effect(c)
	--summon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(64832002,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c64832002.sumcon)
	e0:SetOperation(c64832002.sumop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64832002,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,64832002)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c64832002.thtg)
	e2:SetOperation(c64832002.thop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64832002,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,64832003)
	e3:SetCost(c64832002.smcost)
	e3:SetTarget(c64832002.smtg)
	e3:SetOperation(c64832002.smop)
	c:RegisterEffect(e3)
end
function c64832002.refil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x6410)
end
function c64832002.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c64832002.refil,tp,LOCATION_EXTRA,0,1,nil)
end
function c64832002.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c64832002.refil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c64832002.showfilter(c,tp)
	local cd=c:GetCode()
	return c:IsSetCard(0x6410) and Duel.IsExistingMatchingCard(c64832002.sumfilter,tp,LOCATION_HAND,0,1,c,cd) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c64832002.sumfilter(c,cd)
	return c:IsSetCard(0x6410) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and not c:IsCode(cd)
end
function c64832002.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64832002.showfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c64832002.showfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
end
function c64832002.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c64832002.smop(e,tp,eg,ep,ev,re,r,rp)
	local cd=e:GetLabelObject():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c64832002.sumfilter,tp,LOCATION_HAND,0,1,1,nil,cd)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function c64832002.thfil(c)
	return c:IsSetCard(0x6410) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c64832002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c64832002.thfil(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and not chkc==e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c64832002.thfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c64832002.thfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c64832002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end