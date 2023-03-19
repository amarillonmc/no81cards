--满开之大行进 莲南
local m=40010584
local cm=_G["c"..m]
cm.named_with_WorldTreemarchingband=1
function cm.WorldTreemarchingband(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_WorldTreemarchingband
end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
   -- e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge2,0)
	end
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tgf2(c)
	local seq=c:GetSequence()
	if seq>3 then return false end
	return Duel.CheckLocation(c:GetControler(),LOCATION_MZONE,seq+1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.opf2(c,seq)
	return c:GetSequence()==seq
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	local n=0
	for i=3,0,-1 do
		g=Duel.GetMatchingGroup(cm.opf2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,i)
		for tc in aux.Next(g) do
			if Duel.CheckLocation(tc:GetControler(),LOCATION_MZONE,i+1) then 
				Duel.MoveSequence(tc,i+1) 
				n=n+1
			end
		end
	end
	g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if n>0 and #g>0 and Duel.SelectYesNo(tp,1104) then
		Duel.BreakEffect()
		g=g:Select(tp,1,n,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--e3
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	local ct=Duel.GetFlagEffect(tp,m)
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then
		Duel.MoveSequence(c,seq+1)
		if ct>0 then Duel.Draw(tp,ct,REASON_EFFECT) end
	else
		if Duel.IsPlayerAffectedByEffect(tp,40010592) and seq<3 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+2) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.MoveSequence(c,seq+2)
			if ct>0 then Duel.Draw(tp,ct,REASON_EFFECT) end
		else
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function cm.chfliter(c) 
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE)
end 
--GlobalEffect
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END and eg:Filter(cm.chfliter,nil):GetCount()>0 then
		eg:Filter(cm.chfliter,nil):ForEach(function(c) Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_STANDBY,0,1) end)
		--local ct=Duel.GetFlagEffect(rp,m)

		--Debug.Message("check:")
		--Debug.Message(ct)

	end
end
