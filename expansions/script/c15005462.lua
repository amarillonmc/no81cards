local m=15005462
local cm=_G["c"..m]
cm.name="炽烈的还魂诗"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetCondition(cm.atkcon)
	e1:SetValue(aux.TargetBoolFunction(Card.GetBaseDefense))
	c:RegisterEffect(e1)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(m,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.atktg(e,c)
	return c:IsFaceup() and Duel.GetAttacker()==c
end
function cm.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()~=nil
end
function cm.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(m)~=0
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c:GetCode(),e,tp)
end
function cm.spfilter2(c,code,e,tp)
	return c:IsCode(code) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,0x70,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter1,tp,0x70,0,nil,e,tp)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local ssg=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tc:GetCode(),e,tp)
		if (not sg:IsExists(Card.IsCode,1,nil,tc:GetCode())) and #ssg>0 then
			sg:Merge(ssg)
		end
		tc=g:GetNext()
	end
	if #sg<=0 then return end
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),sg:GetClassCount(Card.GetCode))
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spg=sg:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if spg then
		local ct=Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		if ct>0 then Duel.Damage(tp,ct*800,REASON_EFFECT) end
	end
end