--幻叙-破灭暗影
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.ovfilter(c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetAttribute)>=4
end
function s.filter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function s.sfilter(c,p,seq,loc)
	local sseq=c:GetSequence()
	if c:IsControler(1-p) then
		return loc==LOCATION_MZONE and c:IsLocation(LOCATION_MZONE)
			and (sseq==5 and seq==3 or sseq==6 and seq==1)
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and (sseq==seq or loc==LOCATION_SZONE and math.abs(sseq-seq)==1)
	end
	if sseq<5 then
		return sseq==seq or loc==LOCATION_MZONE and math.abs(sseq-seq)==1
	else
		return loc==LOCATION_MZONE and (sseq==5 and seq==1 or sseq==6 and seq==3)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.sfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,bc,bc:GetControler(),bc:GetSequence(),bc:GetLocation())
	g:AddCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle(e) then
		local g=Duel.GetMatchingGroup(s.sfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,bc,bc:GetControler(),bc:GetSequence(),bc:GetLocation())
		g:AddCard(bc)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
