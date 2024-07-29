--云魔物-巨大喷流
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetCondition(cm.adcon)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--Remove counter replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_RCOUNTER_REPLACE+0x1019)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.rcon)
	e3:SetOperation(cm.rop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(m)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	if not GIGANTIC_JET then
		GIGANTIC_JET=true
		local _CGetCounter=Card.GetCounter
		local _CRemoveCounter=Card.RemoveCounter
		local _DIsCanRemoveCounter=Duel.IsCanRemoveCounter
		local _DRemoveCounter=Duel.RemoveCounter
		function Card.GetCounter(c,typ)
			local ct=_CGetCounter(c,typ)
			if typ~=0x1019 then return ct end
			if c:IsHasEffect(m) then
				local og=c:GetOverlayGroup()
				if og and #og>0 then ct=ct+og:FilterCount(cm.filter,nil) end
			end
			return ct
		end
		function Card.RemoveCounter(c,p,typ,ct,r)
			if c:IsHasEffect(m) and typ==0x1019 and ct==c:GetCounter(typ) then
				local og=c:GetOverlayGroup():Filter(cm.filter,nil)
				local ct0=_CGetCounter(c,typ)
				if og and #og>0 and c:CheckRemoveOverlayCard(p,#og,r) then c:RemoveOverlayCard(p,#og,#og,r) end
				if ct0>0 then _CRemoveCounter(c,p,typ,ct0,r) end
				return true
			end
			return _CRemoveCounter(c,p,typ,ct,r)
		end
		function Duel.IsCanRemoveCounter(p,s,o,typ,ct,r)
			if typ~=0x1019 then return _DIsCanRemoveCounter(p,s,o,typ,ct,r) end
			local s1,o1=s,o
			if s==1 then s1=0xff end
			if o==1 then o1=0xff end
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,p,s1,o1,nil,m)
			for tc in aux.Next(g) do
				local og=tc:GetOverlayGroup():Filter(cm.filter,nil)
				if og and #og>0 and tc:CheckRemoveOverlayCard(p,#og,r) then ct=ct-#og end
			end
			if ct<=0 then return true end
			return _DIsCanRemoveCounter(p,s,o,typ,ct,r)
		end
		function Duel.RemoveCounter(p,s,o,typ,ct,r)
			if typ~=0x1019 then return _DRemoveCounter(p,s,o,typ,ct,r) end
			local ct0=Duel.GetCounter(p,s,o,typ)
			local s1,o1=s,o
			if s==1 then s1=0xff end
			if o==1 then o1=0xff end
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,p,s1,o1,nil,m)
			local rg=Group.CreateGroup()
			for tc in aux.Next(g) do
				local og=tc:GetOverlayGroup():Filter(cm.filter,nil)
				if og and #og>0 and tc:CheckRemoveOverlayCard(p,#og,r) then rg:Merge(og) end
			end
			if rg and #rg>0 and (ct>ct0 or Duel.SelectYesNo(p,aux.Stringid(m,2))) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVEXYZ)
				local tg=rg:Select(p,math.max(1,ct-ct0),ct,nil)
				if #tg>0 then
					local ct1=Duel.SendtoGrave(tg,r)
					ct=ct-ct1
				end
			end
			if ct<=0 then return true end
			return _DRemoveCounter(p,s,o,typ,ct,r)
		end
	end
end
function cm.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,2) or c:IsSetCard(0x18)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsLevel(2)
end
function cm.adcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.filter,1,nil)
end
function cm.atkval(e,c)
	return c:GetBaseAttack()*2
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x18) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	local code=re:GetOwner():GetOriginalCode()
	--continuously updating
	local tab={11451697,79703905,90557975,99913710}
	for _,code0 in pairs(tab) do
		if code==code0 then return false end
	end
	return ep==e:GetOwnerPlayer() and og and og:FilterCount(cm.filter,nil)>=ev and e:GetHandler():CheckRemoveOverlayCard(ep,ev,r)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup():Filter(cm.filter,nil)
	Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_REMOVEXYZ)
	local tg=og:Select(ep,ev,ev,nil)
	if #tg>0 then Duel.SendtoGrave(tg,r) end
end