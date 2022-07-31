---可拉克
local m=7429805
local cm=_G["c"..m]

function cm.initial_effect(c)
	--zone limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MUST_USE_MZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(cm.zonelimit)
	c:RegisterEffect(e0)
	--spsummon cost
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SPSUMMON_COST)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCost(cm.splimit)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_SUMMON_COST)
	e02:SetCost(cm.sumlimit)
	c:RegisterEffect(e02)
	local e03=e01:Clone()
	e03:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e03)
	local e04=e02:Clone()
	e04:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e04)
	--spsummon token
	local e05=Effect.CreateEffect(c)
	e05:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e05:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e05:SetCode(EVENT_SUMMON_SUCCESS)
	e05:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e05:SetOperation(cm.tokenop)
	c:RegisterEffect(e05)
	local e06=e05:Clone()
	e06:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e06)
	local e07=e05:Clone()
	e07:SetCode(EVENT_FLIP)
	c:RegisterEffect(e07)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_END_PHASE,TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetCost(cm.spcost)
	--e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--leave field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
	--cannot battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.btcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--immuse
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.btcon)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--Recover
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.recon)
	e5:SetOperation(cm.reop)
	c:RegisterEffect(e5)
end
GM_global_to_deck_check=true
function cm.zonelimit(e)
	local tp=e:GetHandlerPlayer()
	local zone=0
	if Duel.GetFieldCard(tp,LOCATION_MZONE,1) then else zone=zone|0x1 end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,2) then else zone=zone|0x2 end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,3) then else zone=zone|0x4 end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,4) then else zone=zone|0x8 end
	return zone
end
function cm.splimit(e,c,tp)
	local zone_check=false
	for i=0,3 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then
		else
			if Duel.GetFieldCard(tp,LOCATION_MZONE,i+1) then 
			else
				zone_check=true
			end
		end
	end
	if not zone_check or Duel.GetLocationCount(tp,LOCATION_MZONE)<2   
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,7429201,0,TYPES_TOKEN_MONSTER,0,4000,5,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) or not Duel.IsPlayerCanSpecialSummonCount(tp,2)
	or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return true
end
function cm.sumlimit(e,c,tp)
	local c=e:GetHandler()
	local zone_check=false
	local a=c:GetTributeRequirement()
	for i=0,3 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then
			if not Duel.GetFieldCard(tp,LOCATION_MZONE,i):IsReleasable(c) or a==0 or Duel.GetFieldCard(tp,LOCATION_MZONE,i+1) then
			else
				zone_check=true
			end
		else
			if Duel.GetFieldCard(tp,LOCATION_MZONE,i+1) then 
			else
				zone_check=true
			end
		end
	end
	if not zone_check  
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,7429201,0,TYPES_TOKEN_MONSTER,0,4000,5,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) or not Duel.IsPlayerCanSpecialSummonCount(tp,1) then return false end
	return true
end
function cm.tokenop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(e:GetHandler():GetSequence()+1)))>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7429201,0,TYPES_TOKEN_MONSTER,0,4000,5,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) then
		for i=0,0 do
			local token=Duel.CreateToken(tp,7429201)
			local seq=e:GetHandler():GetSequence()
			local seq_i=(1<<(seq+1))
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK,seq_i)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e3,true)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			token:RegisterEffect(e4,true)
			local e5=e2:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e5,true)
		end
		Duel.SpecialSummonComplete()
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,7)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==7 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function cm.seqfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re~=e and GM_global_to_deck_check and eg:IsContains(c) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local exg=Group.__band(g,eg):Filter(Card.IsAbleToExtraAsCost,nil)
	g:Sub(exg)
	g:AddCard(e:GetHandler())
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,m)
		GM_global_to_deck_check=false
		local tc=exg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			tc:RegisterEffect(e1,true)
			tc=g:GetNext()
		end
		Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		local p=tp
		for i=1,2 do
			local dg=g:Filter(cm.seqfilter,nil,p)
			if #dg>1 then
				Duel.SortDecktop(tp,p,#dg)
			end
			for i=1,#dg do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
			p=1-tp
		end
		GM_global_to_deck_check=true
		return true
	else return false end
end
function cm.repval(e,c)
	return false
end
function cm.btfilter(c)
	return c:IsFaceup() and c:IsCode(7429201)
end
function cm.btcon(e,tp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.btfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.refilter(c,tp)
	return c:IsCode(7429201) and c:GetPreviousControler()==tp
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.refilter,1,nil,tp)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,7429201)
	Duel.Recover(tp,4000,REASON_EFFECT)
end
