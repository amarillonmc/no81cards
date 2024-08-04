--墓碑
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x0520)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.postg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.postg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(s.attg)
	e6:SetValue(s.atlimit)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(s.atktg)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(s.spcon)
	e8:SetTarget(s.sptg)
	e8:SetOperation(s.spop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,0))
	e9:SetCategory(CATEGORY_COUNTER)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_DAMAGE_STEP_END)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(s.ccon)
	e9:SetTarget(s.ctg)
	e9:SetOperation(s.cop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_COUNTER)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PHASE+PHASE_END)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(s.ctg)
	e10:SetOperation(s.cop)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,2))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetCountLimit(1)
	e11:SetCondition(s.spcon3)
	e11:SetTarget(s.sptg3)
	e11:SetOperation(s.spop3)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,10))
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e12:SetCondition(s.handcon)
	c:RegisterEffect(e12)
end
function s.posfilter(c)
	return c:IsPosition(POS_DEFENSE) and c:IsSetCard(0xc520)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumpos,POS_DEFENSE)>0 and c:IsSetCard(0xc520)
end
function s.postg(e,c)
	return c:IsSetCard(0xc520)
end
function s.handcon(e)
	return not Duel.IsExistingMatchingCard(s.hcfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil)
end
function s.hcfilter(c)
	return not c:IsSetCard(0xc520)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xc520)
end
function s.attg(e,c)
	e:SetLabelObject(c)
	return c:IsFaceup() and c:IsSetCard(0xc520) and c:IsLocation(LOCATION_MZONE)
end
function s.atlimit(e,c)
	local lc=e:GetLabelObject()
	return not lc:GetColumnGroup():IsContains(c)
end
function s.atkfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end
function s.atktg(e,c)
	local cg=c:GetColumnGroup()
	return c:IsFaceup() and c:IsSetCard(0xc520) and not cg:IsExists(s.atkfilter,1,nil,e:GetHandlerPlayer())
end
function s.filter(c,cc,e,tp)
	return c:IsSetCard(0xc520) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetLevel()>0 and cc:IsCanRemoveCounter(tp,0x0520,c:GetLevel(),REASON_COST)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rpc)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e:GetHandler(),e,tp) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil,e:GetHandler(),e,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	e:GetHandler():RemoveCounter(tp,0x0520,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.sfilter(c,lv,e,tp)
	return c:IsSetCard(0xc520) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetLevel()==lv
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsSetCard(0xc520) and Duel.GetAttacker():IsControler(tp) and Duel.GetAttackTarget()==nil
end
function s.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x0520,2) end
end
function s.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x0520,2)
	end
end
function s.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,57300402,0xc520,TYPES_TOKEN_MONSTER,600,1400,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
end
function s.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,57300413,0xc520,TYPES_TOKEN_MONSTER,600,1600,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return end
	local zone=1<<c:GetSequence()
	local ss=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ss>0 then
		local token=Duel.CreateToken(tp,57300402)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetOperation(s.backop)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	else
		return
	end
end
function s.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Exile(c,0)
end