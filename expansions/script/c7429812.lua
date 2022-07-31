--渊狱魅魔希拉格
local m=7429812
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
	e05:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e05:SetCode(EVENT_ADJUST)
	e05:SetRange(LOCATION_MZONE)
	e05:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e05:SetOperation(cm.tokenop)
	c:RegisterEffect(e05)

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
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
GM_global_to_deck_check=true
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.zonelimit(e)
	return 0x4
end
function cm.splimit(e,c,tp)
	local fc=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	if (fc and fc~=e:GetHandler()) or Duel.GetLocationCount(tp,LOCATION_MZONE)<5   
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,7429101,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) or not Duel.IsPlayerCanSpecialSummonCount(tp,2)
	or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return true
end
function cm.sumlimit(e,c,tp)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	local fc1=Duel.GetFieldCard(tp,LOCATION_MZONE,0)
	local fc2=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
	local fc3=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
	local fc4=Duel.GetFieldCard(tp,LOCATION_MZONE,4)
	local a=c:GetTributeRequirement()
	if (fc and fc~=e:GetHandler() and (not fc:IsReleasable(c) or a==0)) or fc1 or fc2 or fc3 or fc4   
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,7429101,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) or not Duel.IsPlayerCanSpecialSummonCount(tp,1)
	or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return true
end
function cm.tokenop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m+1)~=0 then return false end
	e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,1)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7429101,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) then
		for i=0,3 do
			local token=Duel.CreateToken(tp,7429101+i)
			local seq=0
			local seq_i=i
			if i==2 then seq_i=3 end
			if i==3 then seq_i=4 end
			seq=(1<<seq_i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK,seq)
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
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(7429101)
end
--function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
--  return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,m)>0
--end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
	end
end
