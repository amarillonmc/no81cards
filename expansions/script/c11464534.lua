--欧内的手
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.con)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.activate)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.xyzfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and ((c:IsCode(95929069,68535320) and c:GetFlagEffect(m)~=0) or not c:IsLocation(LOCATION_GRAVE))
end
function cm.con(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	return Duel.CheckXyzMaterial(c,cm.xyzfilter,4,minc,maxc,zone)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	local minc=2
	local maxc=2
	if min then
		 if min>minc then minc=min end
		 if max<maxc then maxc=max end
	end
	local g=Duel.SelectXyzMaterial(tp,c,cm.xyzfilter,4,minc,maxc,zone)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function cm.spcfilter(c,tp)
	return c:GetReasonPlayer()==tp
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.handfilter(c)
	return c:GetReasonPlayer()~=c:GetControler() and c:IsLocation(LOCATION_GRAVE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
	local sg=eg:Filter(cm.handfilter,nil)
	sg:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.spfilter(c,e,tp)
	return c:GetOriginalType()&0x1~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(95929069,68535320)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return c:GetOverlayGroup():IsExists(cm.spfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function cm.efilter(e,te)
	return te==e:GetLabelObject()
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e1:SetValue(cm.efilter)
		e1:SetLabelObject(re)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=c:GetOverlayGroup():FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
			local sg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
			if #sg==1 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and g:GetFirst():IsLocation(LOCATION_MZONE) then Duel.ChangeTargetCard(ev,g) end
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL
end
function cm.tgfilter(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.xyzfilter1(c,g,tp)
	local all=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)-g
	--not fully implemented
	return c:IsXyzSummonable(all)
end
function cm.fselect(g,tp)
	return Duel.IsExistingMatchingCard(cm.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,g,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return #g>=3 and g:CheckSubGroup(cm.fselect,3,3,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,3,3,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzfilter2(c)
	return c:IsXyzSummonable(nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.xyzfilter2,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end