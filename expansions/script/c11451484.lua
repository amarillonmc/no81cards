--魔人★双子相杀
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp,chk)
	if eg:IsExists(cm.counterfilter,1,nil) then cm[0]=cm[0]+1 end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
end
function cm.counterfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function cm.chkfilter1(c,e,tp)
	return c:IsSetCard(0x97b) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c) and Duel.IsExistingMatchingCard(cm.chkfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function cm.chkfilter2(c,e,tp,att)
	return c:IsSetCard(0x97b) and c:IsType(TYPE_MONSTER) and c:GetAttribute()~=att and not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,1-tp,c)
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x97b) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function cm.filter2(c,e,tp,att)
	return c:IsSetCard(0x97b) and c:IsType(TYPE_MONSTER) and c:GetAttribute()~=att and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local act=e:IsHasType(EFFECT_TYPE_ACTIVATE)
	if chk==0 then return not act or cm[0]<2 end
	if act then
		--[[local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetValue(2-sp)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)--]]
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e4:SetTargetRange(1,1)
		e4:SetCondition(cm.econ)
		e4:SetValue(cm.elimit)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.econ(e)
	return cm[0]>=2
end
function cm.elimit(e,c)
	return c:IsLocation(LOCATION_DECK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.chkfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local g1=sg:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetAttribute())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetLabel(tc2:GetRealFieldID())
		e1:SetCondition(cm.macon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetLabel(tc1:GetRealFieldID())
		tc2:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		--e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e3:SetValue(cm.bttg)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetLabel(tc1:GetRealFieldID())
		tc2:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e5:SetValue(LOCATION_HAND)
		tc1:RegisterEffect(e5)
		local e6=e5:Clone()
		tc2:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e7:SetCode(EVENT_TO_HAND)
		e7:SetCondition(cm.thcon)
		e7:SetOperation(cm.thop)
		Duel.RegisterEffect(e7,tp)
		tc1:RegisterFlagEffect(m,RESET_EVENT+0x1de0000,0,1,tc1:GetRealFieldID())
		tc2:RegisterFlagEffect(m,RESET_EVENT+0x1de0000,0,1,tc2:GetRealFieldID())
	end
end
function cm.thfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.filter(c,fid,ac)
	local flag=c:GetFlagEffectLabel(m)
	return flag and flag==fid and c:IsCanBeBattleTarget(ac)
end
function cm.macon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,e:GetHandler(),e:GetLabel(),e:GetHandler())
end
function cm.bttg(e,c)
	local flag=c:GetFlagEffectLabel(m)
	return flag and flag==e:GetLabel()
end