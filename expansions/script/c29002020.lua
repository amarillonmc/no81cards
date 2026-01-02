--方舟骑士团-年
c29002020.named_with_Arknight=1
function c29002020.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29002020,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c29002020.sprcon)
	e1:SetOperation(c29002020.sprop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c29002020.splimit)
	c:RegisterEffect(e2) 
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29002020,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c29002020.drcon)
	e4:SetTarget(c29002020.drtg)
	e4:SetOperation(c29002020.dract)
	c:RegisterEffect(e4)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29002020,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c29002020.efilter)
	c:RegisterEffect(e3)
	if not c29002020.global_check then
		c29002020.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c29002020.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
--
function c29002020.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c29002020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29002020.dract(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
		local dc=Duel.DiscardHand(tp,Card.IsDiscardable,1,99,REASON_EFFECT+REASON_DISCARD,nil)
		if dc>0 then
			Duel.Draw(tp,dc,REASON_EFFECT)
		end
	end
end
--
function c29002020.atktg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c29002020.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(0,29002020,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c29002020.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c29002020.cfilter(c,tp)
	return c:IsSetCard(0x87af) and (c:IsControler(tp) or c:IsFaceup())
end
function c29002020.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local x=Duel.GetFlagEffect(0,29002020)
	return x>=12 and Duel.CheckReleaseGroup(tp,c29002020.cfilter,3,nil)
end
function c29002020.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c29002020.cfilter,3,3,nil)
	Duel.Release(g,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002020.itarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c29002020.ioperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c29002020.efilter)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END) 
	e2:SetOwnerPlayer(tp) 
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(29002020,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(29002020)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
--function c29002020.efilter(e,te)
	--if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	--if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	--local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	--return not g or not g:IsContains(e:GetHandler())
--end
function c29002020.efilter(e,re,rp,c)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and not g or not g:IsContains(c)
end