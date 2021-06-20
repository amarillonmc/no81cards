--陷阵营副 魏续
function c9330002.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,9330002+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9330002.sprcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9331002)
	e2:SetTarget(c9330002.sptg)
	e2:SetOperation(c9330002.spop)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9330002.ctlcon)
	e3:SetTarget(c9330002.ctltg)
	e3:SetOperation(c9330002.ctlop)
	c:RegisterEffect(e3)
end
function c9330002.cfilter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330002.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf93)
end
function c9330002.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9330002.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c9330002.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9330002.filter(c,e)
	return c:IsCode(9330001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9330002.filter2(c)
	return c:IsCode(9330001) and c:IsAbleToHand()
end
function c9330002.filter3(c)
	return c:IsCode(9330001)
end
function c9330002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c9330002.filter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c9330002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c9330002.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local kg=Duel.SelectMatchingCard(tp,c9330002.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
		if  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		elseif kg:GetCount()>0 and Duel.SendtoHand(kg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,kg)
		end
	end
end
function c9330002.ctlcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
end
function c9330002.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c9330002.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end


