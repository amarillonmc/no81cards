--恨约冥河 斯提克斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--宣言卡名
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--放置
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.pencon)
    e2:SetTarget(s.pentg)
	e2:SetOperation(s.penop)
	c:RegisterEffect(e2)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function s.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end    
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainDisablable(0) then
    	Duel.NegateEffect(0)
        return
    end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	--发动封锁    
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
    e1:SetLabel(ac)
	e1:SetCondition(s.actcon)
	e1:SetValue(s.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	--检测    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetLabel(ac)
	e2:SetOperation(s.checkop)
    e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    Duel.RegisterEffect(e3,tp)
    local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP)
    Duel.RegisterEffect(e4,tp)	            
end
function s.codefilter(c,code)
	return c:GetFlagEffect(id)>0 and c:IsCode(code)
end
function s.actcon(e)
	return not Duel.IsExistingMatchingCard(s.codefilter,e:GetHandlerPlayer(),0xff,0xff,1,nil,e:GetLabel())
end
function s.actlimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc&LOCATION_ONFIELD~=0 and re:IsActiveType(TYPE_MONSTER)
end
function s.cfilter(c,tp,code)
	return c:IsCode(code) and c:IsFaceup() and c:IsSummonPlayer(tp)
end    
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.cfilter,nil,1-tp,e:GetLabel())
    for tc in aux.Next(sg) do
    	tc:RegisterFlagEffect(id,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
    end
end
function s.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPIRIT)
end    
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
    	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end