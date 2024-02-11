local m=15005322
local cm=_G["c"..m]
cm.name="廷达魔三角之跃迁原点"
function cm.initial_effect(c)
	--link summon
	local e0=aux.AddLinkProcedure(c,cm.matfilter,1,1)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCost(cm.retcost)
	e2:SetTarget(cm.rettg)
	e2:SetOperation(cm.retop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return (c:IsLinkSetCard(0x10b) and c:IsType(TYPE_FLIP) and c:IsFacedown()) or (c:IsType(TYPE_FLIP) and c:IsFaceup())
end
function cm.eftg(e,c)
	return c:IsType(TYPE_FLIP) and c:IsFacedown()
end
function cm.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,15005322)<3 end
	local b=true
	if e:GetHandler():IsSetCard(0x10b) then b=false end
	local pos=Duel.SelectPosition(tp,e:GetHandler(),POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	Duel.ChangePosition(e:GetHandler(),pos,pos,pos,pos,b)
	Duel.RegisterFlagEffect(tp,15005322,RESET_PHASE+PHASE_END,0,1)
end
function cm.get_zone(c,seq)
	local zone=0
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) then zone=bit.replace(zone,0x1,seq+1) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) then zone=bit.replace(zone,0x1,seq-1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,2) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,0) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,4) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,3) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,2) end
	return zone
end
function cm.movefilter(c,tp,seq)
	if not (c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsCode(15005322)) then return false end
	local zone=cm.get_zone(c,seq)
	return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0
end
function cm.desfilter(c,e)
	return c:IsFaceup() and c:IsCode(15005322) and c:IsDestructable(e)
end
function cm.desormovefilter(c,e,tp,seq)
	return cm.desfilter(c,e) or cm.movefilter(c,tp,seq)
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desormovefilter,tp,LOCATION_MZONE,0,1,nil,e,tp,seq) end
	local g=Duel.GetMatchingGroup(cm.desormovefilter,tp,LOCATION_MZONE,0,nil,e,tp,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local g=Duel.GetMatchingGroup(cm.desormovefilter,tp,LOCATION_MZONE,0,nil,e,tp,seq)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local ag=g:Select(tp,1,1,nil)
	if ag:GetCount()>0 then
		local tc=ag:GetFirst()
		if tc and cm.desfilter(tc,e) and (not cm.movefilter(tc,tp,seq) or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			local zone=cm.get_zone(tc,seq)
			local flag=bit.bxor(zone,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(tc,nseq)
		end
	end
end