--碧落
local cm,m,o=GetID()
function cm.initial_effect(c)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0x1ff)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
cm.nocheck={}
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnCount()~=1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0x1ff,0,nil,TYPE_MONSTER)
	for tc in aux.Next(g) do	
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_DECK)
		e1:SetCondition(cm.spcon)
		e1:SetTarget(cm.sptg)
		e1:SetOperation(cm.spop)
		tc:RegisterEffect(e1)
	end
end
function cm.spfil1(c,code)
	return c:IsCode(code) and c:IsFaceup() and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.spfil2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
	and cm.nocheck[c:GetCode()]~=42
end
function cm.spfil2(c)
	return c:IsCode(m) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())) and c:IsReleasable()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfil1,tp,LOCATION_MZONE,0,nil,c:GetCode())
	return g:CheckSubGroup(aux.mzctcheckrel,1,1,tp,REASON_SPSUMMON)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(cm.spfil1,tp,LOCATION_MZONE,0,nil,c:GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:SelectUnselect(nil,tp,false,true,1,1)
	local g2=Duel.GetMatchingGroup(cm.spfil2,tp,LOCATION_HAND+LOCATION_MZONE,0,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local hc=g2:SelectUnselect(nil,tp,false,true,1,1)
	local g=Group.FromCards(tc,hc)
	if #g==2 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	cm.nocheck[c:GetCode()]=42
	Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_RELEASE)
end


