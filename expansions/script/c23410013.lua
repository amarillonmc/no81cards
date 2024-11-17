--孟婆
local cm,m,o=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(c.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,m+10000000)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.atktg)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.sumcon)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc and tc:IsFacedown() do
		Duel.RegisterFlagEffect(1-tc:GetControler(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.atktg(e,c)
	return c:IsRace(RACE_ILLUSION)
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_REMOVED,nil)
	return #g*100
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=1
	if Duel.GetLP(1-tp)>=4000 then num=num+1 end
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=10 then num=num+1 end
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)<Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil) then num=num+1 end
	if Duel.IsPlayerAffectedByEffect(tp,m) then
		--Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	if chk==0 then return Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)==num end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,num,1-tp,LOCATION_DECK)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local num=1
	if Duel.GetLP(1-tp)>=4000 then num=num+1 end
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=10 then num=num+1 end
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)<Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil) then num=num+1 end
	if Duel.IsPlayerAffectedByEffect(tp,m) then
		Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	local g=Duel.GetDecktopGroup(1-tp,num)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
