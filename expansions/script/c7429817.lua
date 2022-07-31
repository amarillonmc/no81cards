--可拉巴托亚
local m=7429817
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
	--return replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	c:RegisterEffect(e3)
end
GM_global_to_deck_check=true
function cm.zonelimit(e)
	local tp=e:GetHandlerPlayer()
	local zone=0
	if Duel.GetFieldCard(tp,LOCATION_MZONE,2) or Duel.GetFieldCard(tp,LOCATION_MZONE,0) then else zone=zone|0x2 end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,3) or Duel.GetFieldCard(tp,LOCATION_MZONE,1) then else zone=zone|0x4 end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,4) or Duel.GetFieldCard(tp,LOCATION_MZONE,2) then else zone=zone|0x8 end
	return zone
end
function cm.splimit(e,c,tp)
	local zone_check=false
	for i=1,3 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then
		else
			if Duel.GetFieldCard(tp,LOCATION_MZONE,i+1) or Duel.GetFieldCard(tp,LOCATION_MZONE,i-1) then 
			else
				zone_check=true
			end
		end
	end
	if not zone_check or Duel.GetLocationCount(tp,LOCATION_MZONE)<2   
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,7429501,0,TYPES_TOKEN_MONSTER,2000,500,2,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) or not Duel.IsPlayerCanSpecialSummonCount(tp,2)
	or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return true
end
function cm.sumlimit(e,c,tp)
	local c=e:GetHandler()
	local zone_check=false
	local a=c:GetTributeRequirement()
	for i=1,3 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then
			if not Duel.GetFieldCard(tp,LOCATION_MZONE,i):IsReleasable(c) or Duel.GetFieldCard(tp,LOCATION_MZONE,i+1) or Duel.GetFieldCard(tp,LOCATION_MZONE,i-1) or a==0 then
			else
				zone_check=true
			end
		else
			if Duel.GetFieldCard(tp,LOCATION_MZONE,i+1) or Duel.GetFieldCard(tp,LOCATION_MZONE,i-1) then 
			else
				zone_check=true
			end
		end
	end
	if not zone_check  
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,7429501,0,TYPES_TOKEN_MONSTER,2000,500,2,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) or not Duel.IsPlayerCanSpecialSummonCount(tp,1) then return false end
	return true
end
function cm.tokenop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(e:GetHandler():GetSequence()+1)))>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(e:GetHandler():GetSequence()-1)))>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7429501,0,TYPES_TOKEN_MONSTER,2000,500,2,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK) then
		for i=0,1 do
			local token=Duel.CreateToken(tp,7429501)
			local seq=e:GetHandler():GetSequence()
			local seq_i=(1<<(seq-1))
			if i==0 then
				seq_i=(1<<(seq-1))
			else
				seq_i=(1<<(seq+1))
				token=Duel.CreateToken(tp,7429512)
			end
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
	local g=Duel.GetDecktopGroup(tp,6)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==6 end
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
function cm.eqfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsCode(7429501) and c:IsControler(tp)
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg)
	eg:KeepAlive()
	return eg:IsExists(cm.eqfilter,1,nil,tp)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local eg=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,eg) end
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
		or not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,eg)  then return end
	Duel.Hint(HINT_CARD,0,m)
	local eqg=eg:Filter(cm.eqfilter,nil,tp)
	if eqg:GetCount()>0 then
		local tc=eqg:GetFirst()
		while tc do
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,eg)
				Duel.HintSelection(sg)
				tc:CancelToGrave()
				Duel.Equip(tp,tc,sg:GetFirst())
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(sg:GetFirst())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(2000)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			tc=eqg:GetNext()
		end
	end
end
function cm.repfilter(c,tp,rp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsCode(7429501)
	and c:GetReasonPlayer()==1-tp
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and eg:IsExists(cm.repfilter,1,nil,tp,rp) end
	local eqg=eg:Filter(cm.eqfilter,nil,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
		or not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,eg) or eqg:GetCount()<=0 then return false end
	local tc=eqg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	while tc do
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,eg)
			local sc=sg:GetFirst()
			Duel.HintSelection(sg)
			Duel.Equip(tp,tc,sc)
			tc:CreateRelation(sc,RESET_EVENT+RESETS_STANDARD)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(sc)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(2000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		tc=eqg:GetNext()
	end
	return true
end
function cm.repval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsCode(7429501)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
