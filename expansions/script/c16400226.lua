--Servant-咒腕哈桑
local cm,m,o=GetID()
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,2)
	--e1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
	--e2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--e3
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(m,2))
	e22:SetType(EFFECT_TYPE_QUICK_O)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_BECOME_TARGET)
	e22:SetCondition(cm.cgcon)
	e22:SetTarget(cm.cgtg)
	e22:SetOperation(cm.cgop)
	c:RegisterEffect(e22)
	local e3=e22:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	--e4
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m+10000000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.btcost)
	e1:SetOperation(cm.btop)
	c:RegisterEffect(e1)
end
--xyz summon
function cm.mfilter(c,xyzc)
	return c:IsSetCard(0xce3) and c:IsRace(RACE_FIEND)
end
--e1
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--e2
function cm.efilter(e,te)
	local tc=te:GetHandler()
	local c=e:GetHandler()
	local seq1=aux.MZoneSequence(c:GetSequence())
	local seq2=0
	if tc:IsLocation(LOCATION_MZONE) then 
		seq2=aux.MZoneSequence(tc:GetSequence())
	elseif tc:IsLocation(LOCATION_FZONE) then
		seq2=100
	elseif tc:IsLocation(LOCATION_SZONE) then
		seq2=aux.SZoneSequence(tc:GetSequence())
	else
		seq2=100
	end
	return (seq1~=4-seq2 and tc:GetOwner()~=c:GetOwner()) or (seq1~=seq2 and tc:GetOwner()==c:GetOwner())
end
--e3
function cm.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) 
end
function cm.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq={}
	local u=0
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) then
			u=u+1
			seq[u]=i
		end
	end
	if u==0 then return end
	local r=math.random(1,u)
	Duel.MoveSequence(c,seq[r])
end


--e4
function cm.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.btcon2)
	e1:SetOperation(cm.btop2)
	c:RegisterEffect(e1)
end
function cm.btcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function cm.btop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end






