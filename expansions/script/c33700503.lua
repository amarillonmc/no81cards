--珊瑚海
local m=33700503
local cm=_G["c"..m]
function cm.initial_effect(c)
	cm[c]=0
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		if chk==0 then return true end
		local c=e:GetHandler()
		local op=Duel.SelectOption(tp,m*16,m*16+1)
		cm[c]=op
		if op==0 then
			c:SetEntityCode(m)
		else
			c:SetEntityCode(m+1)
		end
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local l=e:GetLabel()
		e:SetLabel(0)
		if chk==0 then return l==1 end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local g0=Duel.GetMatchingGroup(Card.IsFaceup,cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,cm.GetNorthPlayer(c,tp),0,LOCATION_MZONE,nil)
		local dg=Group.CreateGroup()
		local d0=cm.GetData(g0,Card.GetRace)
		local d1=cm.GetData(g1,Card.GetAttribute)
		if cm.GetDataCount(g0,Card.GetRace)>1 and Duel.SelectYesNo(cm.GetNorthPlayer(c,tp),m*16+2) then
			Duel.Hint(HINT_SELECTMSG,cm.GetNorthPlayer(c,tp),m*16+5)
			local ds=Duel.AnnounceRace(cm.GetNorthPlayer(c,tp),1,d0)
			dg=dg+g0:Filter(function(c) return not c:IsRace(ds) end,nil)
		end
		if cm.GetDataCount(g1,Card.GetAttribute)>1 and Duel.SelectYesNo(1-cm.GetNorthPlayer(c,tp),m*16+2) then
			Duel.Hint(HINT_SELECTMSG,1-cm.GetNorthPlayer(c,tp),m*16+6)
			local ds=Duel.AnnounceAttribute(1-cm.GetNorthPlayer(c,tp),1,d1)
			dg=dg+g1:Filter(function(c) return not c:IsAttribute(ds) end,nil)
		end
		if #dg>0 then
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(m*16+3)
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(cm.damcon)
	e8:SetTarget(cm.damtg)
	e8:SetOperation(cm.damop)
	c:RegisterEffect(e8)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(m*16+4)
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(cm.damcon1)
	e8:SetTarget(cm.damtg1)
	e8:SetOperation(cm.damop1)
	c:RegisterEffect(e8)
end
function cm.GetData(g,f)
	local v=0
	for tc in aux.Next(g) do
		v=v|f(tc)
	end
	return v
end
function cm.GetNorthPlayer(c,tp)
	if cm[c]==0 then
		return tp
	else
		return 1-tp
	end
end
function cm.GetDataCount(g,f)
	local v=cm.GetData(g,f)
	local col=1
	local count=0
	while col<=v do
		if col&v>0 then count=count+1 end
		col=col<<1
	end
	return count
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
	return cm.GetDataCount(g,Card.GetRace)>1
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
	local d=cm.GetDataCount(g,Card.GetRace)*700
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,cm.GetNorthPlayer(c,tp),d)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
	local d=cm.GetDataCount(g,Card.GetRace)*700
	Duel.Damage(cm.GetNorthPlayer(c,tp),d,REASON_EFFECT)
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
	return cm.GetDataCount(g,Card.GetAttribute)>1
end
function cm.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
	local d=cm.GetDataCount(g,Card.GetAttribute)*1000
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-cm.GetNorthPlayer(c,tp),d)
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-cm.GetNorthPlayer(c,tp),LOCATION_MZONE,0,nil)
	local d=cm.GetDataCount(g,Card.GetAttribute)*1000
	Duel.Damage(1-cm.GetNorthPlayer(c,tp),d,REASON_EFFECT)
end
