--混沌虚幻力场·死域
function c79029504.initial_effect(c)
	 c:EnableCounterPermit(0x13)
	 c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--mzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c79029504.mcon)
	e2:SetOperation(c79029504.mop)
	c:RegisterEffect(e2) 
	--COUNTER
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c79029504.ccon)
	e3:SetOperation(c79029504.cop)
	c:RegisterEffect(e3)
	--to extra
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c79029504.tecost)
	e4:SetOperation(c79029504.teop)
	c:RegisterEffect(e4)
end
function c79029504.fil(c,tp)
	return (c:IsSetCard(0x2048) or c:IsSetCard(0x1048)) and c:GetControler()==tp
end
function c79029504.mcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029504.fil,1,nil,tp)
end
function c79029504.mop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.SelectYesNo(tp,aux.Stringid(79029504,0)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	  local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	  local nseq=math.log(s,2)
	  Duel.MoveSequence(eg:GetFirst(),nseq)
end
end
function c79029504.fil1(c,tp)
	return c:IsSetCard(0x2048) or c:IsSetCard(0x1048)
end
function c79029504.ccon(e,tp,eg,ep,ev,re,r,rp)
	 return eg:IsExists(c79029504.fil1,1,nil,tp)
end
function c79029504.cop(e,tp,eg,ep,ev,re,r,rp)
	 e:GetHandler():AddCounter(0x13,1)
end
function c79029504.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x13,5,REASON_COST) end
	 e:GetHandler():RemoveCounter(tp,0x13,5,REASON_COST)
end
function c79029504.teop(e,tp,eg,ev,re,r,rp)
	op=Duel.SelectOption(tp,aux.Stringid(79029504,1),aux.Stringid(79029504,2))
	e:SetLabel(op)
	if op~=0 then
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={0x2048,OPCODE_ISSETCARD}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local c=Duel.CreateToken(tp,ac)
	Duel.Remove(c,POS_FACEUP,REASON_RULE) 
	Duel.SendtoHand(c,nil,REASON_RULE) 
	else
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={0x1048,OPCODE_ISSETCARD}
	table.insert(getmetatable(e:GetHandler()).announce_filter,TYPE_MONSTER)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISTYPE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local c=Duel.CreateToken(tp,ac)
	Duel.Remove(c,POS_FACEUP,REASON_RULE) 
	Duel.SendtoHand(c,nil,REASON_RULE)
end
end








