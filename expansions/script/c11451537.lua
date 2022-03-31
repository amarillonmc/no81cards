--无前之斗争军势
--21.05.21
local m=11451537
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,nil,nil,99)
	c:EnableReviveLimit()
	--xyz in battle
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.xyzcon)
	e0:SetOperation(cm.xyzop)
	c:RegisterEffect(e0)
	--advance
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.adcost)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCondition(cm.adcon)
	c:RegisterEffect(e4)
	--summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.otcon)
	e2:SetOperation(cm.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(m)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and e:GetHandler():IsSpecialSummonable(SUMMON_TYPE_XYZ)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummonRule(tp,e:GetHandler(),SUMMON_TYPE_XYZ)
end
function cm.filter(c,tp,ec)
	return c:IsCanOverlay(tp) and Duel.IsExistingMatchingCard(cm.adfilter,tp,LOCATION_HAND,0,1,c,c,ec)
end
function cm.adfilter(c,tc,ec)
	if c:IsSummonable(true,nil,1) then
		return true
	elseif tc:GetOriginalType()&TYPE_MONSTER==0 then
		return false
	end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabelObject(tc)
	e1:SetTarget(function(e,c) return c==e:GetLabelObject() end)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
	e1:Reset()
	return res
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=e:GetHandlerPlayer()
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp,c)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=g:Select(tp,1,1,nil)
	Duel.Overlay(c,sg)
end
function cm.smfilter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function cm.tcfilter(c)
	return c:IsHasEffect(m)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local xg=Duel.GetMatchingGroup(cm.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #xg==0 then return false end
	local og=Group.CreateGroup()
	for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
	local ct=og:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ct==0 then return false end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	return minc<=ma and ((math.max(mi,minc)<=ct and Duel.GetMZoneCount(tp)>0) or Duel.CheckTribute(c,math.max(1,math.max(mi,minc)-ct)))
end
function cm.fselect(g)
	return Duel.GetMZoneCount(tp,g)>0
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local ec=e:GetHandler()
	local mi,ma=c:GetTributeRequirement()
	local g=Duel.GetTributeGroup(c)
	local xg=Duel.GetMatchingGroup(cm.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #xg==0 then return end
	local og=Group.CreateGroup()
	for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
	og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
	g:Merge(og)
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TRIBUTE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,mi,ma)
	c:SetMaterial(sg)
	local sg2=Group.__band(og,sg)
	sg:Sub(sg2)
	local ct=Duel.SendtoGrave(sg2,REASON_SUMMON+REASON_COST+REASON_MATERIAL)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	if ct>0 then
		local e1=Effect.CreateEffect(ec)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1050)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		ec:RegisterEffect(e1)
	end
end