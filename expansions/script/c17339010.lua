--终烬降临
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	
	--Cannot be negated
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	
	--No tribute for "终烬" monsters while in GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(s.ntcon)
	e3:SetTarget(s.nttg)
	c:RegisterEffect(e3)
	
	--Place counter when cards are destroyed
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.ctcon)
	e4:SetTarget(s.cttg)
	e4:SetOperation(s.ctop)
	c:RegisterEffect(e4)
	
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	
	--Initial hand processing
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	ge0:SetCode(EVENT_DRAW)
	ge0:SetRange(0xff)
	ge0:SetOperation(s.quest)
	c:RegisterEffect(ge0)
end

--Initial hand processing
if not Initial_Hand_Shuffle_Count then
	Initial_Hand_Shuffle_Count=0
end

function s.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	--LP变为1
	if Duel.GetLP(tp)~=1 then
		Duel.SetLP(tp,1)
	end
	
	--召唤限制
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	
	--生成衍生物
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17339040,0x5f51,TYPES_TOKEN_MONSTER,0,0,1,RACE_PYRO,ATTRIBUTE_FIRE,POS_FACEUP) then
		local token=Duel.CreateToken(tp,17339040)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		--Cannot be tributed
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2,true)
		--Cannot be removed
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_REMOVE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
		--Destroy when LP is not 1
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_ADJUST)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(s.descon)
		e4:SetOperation(s.desop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()
	end
	
	--胜利条件跟踪
	local fid=c:GetFieldID()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetLabel(fid,0)
	e5:SetCondition(s.wincon)
	e5:SetOperation(s.winop)
	e5:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e5,tp)
end

function s.counterfilter(c)
	return c:IsSetCard(0x5f51)
end

function s.splimit(e,c)
	return not c:IsSetCard(0x5f51)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=1
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function s.nttg(e,c)
	return c:IsSetCard(0x5f51) and c:IsLevelAbove(5)
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD)
end

function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f51) and c:IsCanAddCounter(0x1f51,1)
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc then
			tc:AddCounter(0x1f51,1)
		end
	end
end

function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(fid,ct)
	if ct==2 then
		if Duel.IsExistingMatchingCard(s.tokenfilter,tp,LOCATION_MZONE,0,1,nil) then
			local WIN_REASON_EMBER_DESCENT=0xf6
			Duel.Win(tp,WIN_REASON_EMBER_DESCENT)
		end
		e:Reset()
	end
end

function s.tokenfilter(c)
	return c:IsCode(17339040)
end

-----------------------------------Initial Hand Processing--------------------------------------
function s.quest(e,tp,eg,ep,ev,re,r,rp)
	--The global variable "Initial_Hand_Shuffle_Count" is used to record the number of cards that appear in the initial hand. If it exceeds 5, a shuffle will be triggered in "ge0". Therefore, please keep "Initial_Hand_Shuffle_Count" unchanged when copying and modifying the code
	if Initial_Hand_Shuffle_Count and Initial_Hand_Shuffle_Count>5 then 
		e:Reset() 
		Duel.ShuffleDeck(tp) 
	end
	
	local c=e:GetHandler()
	if not s[c] and Duel.GetFieldGroupCount(0,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_HAND)>0 then
		s[c]=true
		e:Reset()
		if c:IsLocation(LOCATION_HAND) then return false end
		local tdg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local min_fid=32768
		for tc in aux.Next(tdg) do
			local tc_fid=tc:GetFieldID()
			if tc_fid<min_fid then min_fid=tc_fid end
		end
		if min_fid~=32768 then
			local tdg=Duel.GetMatchingGroup(s.questfilter,tp,LOCATION_HAND,0,nil,min_fid)
			Duel.SendtoDeck(tdg,nil,2,REASON_RULE)
			Duel.MoveSequence(c,SEQ_DECKTOP)
			Duel.Draw(tp,1,REASON_RULE)
		end
	elseif Duel.GetFieldGroupCount(0,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_HAND)>0 then
		e:Reset()
	end
end

function s.questfilter(c,min_fid)
	return c:GetFieldID()==min_fid
end

--to top when appear in initial hand
local _RegisterEffect=Card.RegisterEffect
function Card.RegisterEffect(rc,eff,bool)
	local int=_RegisterEffect(rc,eff,bool)
	local c=rc
	if not s[c] and c:IsCode(17339010) and Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_EXTRA)>0 then
		Initial_Hand_Shuffle_Count=Initial_Hand_Shuffle_Count+1
		Duel.MoveSequence(c,SEQ_DECKTOP)
		Duel.Draw(c:GetControler(),1,REASON_RULE)
		s[c]=true
	end
	return int
end