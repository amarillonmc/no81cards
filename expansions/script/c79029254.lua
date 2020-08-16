--个人行动·代号“欧贝利斯克”
function c79029254.initial_effect(c)
   --obeylisc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029254)
	e1:SetCondition(c79029254.discon)
	e1:SetCost(c79029254.discost)
	e1:SetTarget(c79029254.distg)
	e1:SetOperation(c79029254.disop)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99177923,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029254.srcon)
	e1:SetCost(c79029254.srcost)
	e1:SetTarget(c79029254.srtg)
	e1:SetOperation(c79029254.srop)
	c:RegisterEffect(e1)
end
function c79029254.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(79029247) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c79029254.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029254.disfil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.ConfirmCards(tp,e:GetHandler())
end
function c79029254.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,79029254,0,0x11,4000,4000,10,RACE_DEVINE,ATTRIBUTE_DEVINE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029254.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ChangeChainOperation(ev,c79029254.repop)
	Debug.Message("压碎他们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029254,0))
end
function c79029254.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,79029254):GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029254,0,0x11,4000,4000,10,RACE_DEVINE,ATTRIBUTE_DEVINE) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:CopyEffect(10000000,RESET_EVENT+RESETS_STANDARD)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(10000000)
	c:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function c79029254.srcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return ev==ct and eg:IsContains(c)
end
function c79029254.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c79029254.cfilter2(c,e,tp,tc)
	return  c:IsAbleToGrave() and c:IsType(TYPE_TUNER) 
end
function c79029254.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029254.cfilter2,tp,LOCATION_DECK,0,nil)
	local lv=c:GetLevel()
	return c:IsAbleToGrave() and g:CheckWithSumEqual(Card.GetLevel,10+lv,1,99) and not c:IsType(TYPE_TUNER)
end
function c79029254.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false) and c:IsCode(79029247) and Duel.IsExistingMatchingCard(c79029254.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c79029254.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c79029254.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029254.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79029254.srop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029254.cfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029254.cfilter2,tp,LOCATION_DECK,0,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,10+lv,1,99)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	e:GetHandler():SetMaterial(g1)
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
	Debug.Message("所站立之地，即为神灵眷土。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029247,4))
end
end



