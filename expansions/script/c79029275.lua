--格拉尼·瑟谣浮收藏-西部警长
function c79029275.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029024)
	c:RegisterEffect(e2)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c79029275.spcon)
	e2:SetTarget(c79029275.sptg)
	e2:SetOperation(c79029275.spop)
	c:RegisterEffect(e2)			
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,79029275)
	e3:SetCost(c79029275.lkcost)
	e3:SetOperation(c79029275.lkop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,09029275)
	e4:SetCondition(c79029275.sprcon)
	e4:SetOperation(c79029275.sprop)
	c:RegisterEffect(e4)
end
function c79029275.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029275.spfilter1(c,e,tp)
	if c:IsFaceup() and c:IsType(TYPE_LINK) then
		local zone=c:GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c79029275.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,zone) and c:GetLinkedGroup():IsContains(e:GetHandler())
	else return false end
end
function c79029275.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c79029275.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79029275.spfilter1(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c79029275.spfilter1,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Debug.Message("把大家托付给我吗？没问题，我会努力保护整个小队的！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029275,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029275.spfilter1,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end 
function c79029275.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetFirstTarget()
	if lc:IsRelateToEffect(e) and lc:IsFaceup() then
		local zone=lc:GetLinkedZone(tp)
		if zone==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c79029275.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) 
end
end
function c79029275.lkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
end
function c79029275.lkop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local xy=Duel.AnnounceType(tp)
	 local ty=0
	 if xy==0 then 
	 ty=TYPE_MONSTER 
	 elseif xy==0 then 
	 ty=TYPE_SPELL 
	 else
	 ty=TYPE_TRAP 
	 end  
	 local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,ty)
	 if Duel.ConfirmCards(tp,g)~=0 then
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	 e1:SetCode(EFFECT_UPDATE_ATTACK)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	 e1:SetValue(g:GetCount()*1500)
	 e1:SetRange(LOCATION_MZONE)
	 c:RegisterEffect(e1)
	Debug.Message("报告博士！巡查完毕，没有异常！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029275,1))
end
end
function c79029275.cfilter2(c,e,tp,tc)
	return c:IsType(TYPE_TUNER) 
end
function c79029275.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029275.cfilter2,tp,LOCATION_DECK,0,nil)
	local lv=c:GetLevel()
	return g:CheckWithSumEqual(Card.GetLevel,12-lv,1,99) and not c:IsType(TYPE_TUNER)
end
function c79029275.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029275.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c79029275.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029275.cfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029275.cfilter2,tp,LOCATION_DECK,0,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,12-lv,1,99)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)~=0 then
	e:GetHandler():SetMaterial(g1)
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	Debug.Message("我的战场，可不只是在地面！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029275,2))
end
end










