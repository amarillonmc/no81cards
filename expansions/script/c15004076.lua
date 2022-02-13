local m=15004076
local cm=_G["c"..m]
cm.name="翠绿之镰的荒仙·洛芙卡勒"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15004076+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.hspcon)
	e1:SetValue(cm.hspval)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,15004077)
	e2:SetCost(cm.mocost)
	e2:SetTarget(cm.motg)
	e2:SetOperation(cm.moop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsSetCard(0x9f3e)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function cm.mocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.mvfilter(c,tp,chk,sc,e)
	if sc:IsLocation(LOCATION_MZONE) and chk==0 then
		return c:GetSequence()<5 and ((c:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_SZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)>0)) and not (c:IsLocation(LOCATION_FZONE) or c:IsLocation(LOCATION_PZONE)) and not c:IsImmuneToEffect(e)
	end
	return c:GetSequence()<5 and ((c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0) or (c:IsLocation(LOCATION_SZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)>0)) and not (c:IsLocation(LOCATION_FZONE) or c:IsLocation(LOCATION_PZONE)) and not c:IsImmuneToEffect(e)
end
function cm.motg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp,chk,e:GetHandler(),e) end
end
function cm.moop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local tc=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,1,e:GetHandler(),e):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	local loc=0
	if tc:IsLocation(LOCATION_MZONE) then loc=LOCATION_MZONE end
	if tc:IsLocation(LOCATION_SZONE) then loc=LOCATION_SZONE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,loc,0,0)
	local nseq=math.log(s,2)
	if loc==LOCATION_SZONE then nseq=nseq-8 end
	Duel.MoveSequence(tc,nseq)
end