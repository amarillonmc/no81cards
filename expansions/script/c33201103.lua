--自奏圣乐的交响曲
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.efcon)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(33201103)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

--check
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x11b) and Duel.IsPlayerAffectedByEffect(rp,33201103) then
		Duel.RegisterFlagEffect(rp,33201103,RESET_PHASE+PHASE_END,0,1)
	end
end

--e1
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,id)+1
	return re:GetHandler():IsSetCard(0x11b) and ct>0 and ct%3==0 and Duel.GetFlagEffect(tp,id+1)<3
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local ec=Duel.GetFlagEffect(tp,id+1)
	Duel.Hint(HINT_CARD,tp,id)
	if ec==0 and Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil):Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,tc,nil)
		Duel.RegisterFlagEffect(rp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	if ec==1 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT) 
		local mg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=mg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local sq=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
		local nseq=math.log(sq,2)
		Duel.MoveSequence(tc,nseq-16)
		Duel.RegisterFlagEffect(rp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	if ec==2 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
		Duel.RegisterFlagEffect(rp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.lkfilter(c)
	return c:IsSetCard(0x11b) and c:IsLinkSummonable(nil)
end