--脱兔『Fluster Escape』
function c11200069.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c11200069.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,11200069+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c11200069.tg3)
	e3:SetOperation(c11200069.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11200069,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,11200169)
	e4:SetCondition(c11200069.con4)
	e4:SetTarget(c11200069.tg4)
	e4:SetOperation(c11200069.op4)
	c:RegisterEffect(e4)
--
end
--
c11200069.xig_ihs_0x132=1
c11200069.xig_ihs_0x133=1
--
function c11200069.cfilter1(c)
	return not (c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT))
end
function c11200069.con1(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c11200069.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c11200069.tfilter3(c,e,tp)
	return (c:IsSetCard(0x621) or c:IsCode(11200019) or c.xig_ihs_0x132)
		and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200069.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11200069.tfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c11200069.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11200069.tfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
--
function c11200069.con4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x621)
end
--
function c11200069.tfilter4(c)
	return c:IsSetCard(0x621) and c:IsAbleToDeck()
end
function c11200069.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() or Duel.IsExistingMatchingCard(c11200069.tfilter4,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,LOCATION_GRAVE+LOCATION_MZONE)
end
--
function c11200069.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_MZONE,0)
	local tg=sg:Filter(c11200069.tfilter4,nil)
	if c:IsRelateToEffect(e) then tg:AddCard(c) end
	if tg:GetCount()<1 then return end
	if Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--
