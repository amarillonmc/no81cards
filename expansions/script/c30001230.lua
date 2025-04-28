--3929 场地
local m=30001230
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.sumcon)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
	--Effect 3 
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,0))
	e21:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION+CATEGORY_ATKCHANGE)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e21:SetRange(LOCATION_FZONE)
	e21:SetCountLimit(1)
	e21:SetCondition(cm.reccon)
	e21:SetTarget(cm.rectg)
	e21:SetOperation(cm.recop)
	c:RegisterEffect(e21)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--Effect 1
function cm.rsf(c,tp)
	if not c:IsSetCard(0x3929) then return false end
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	local tge=nil
	if re then
		val=re:GetValue()
		tge=re:GetTarget()
	end
	return val==nil and (tae==nil or tae(re,c))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_EXTRA,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)
	end
end
--Effect 2
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_ADVANCE) 
end
function cm.zcf(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp)
end 
function cm.pf(c,tp)
	local b1=c:IsType(TYPE_CONTINUOUS)
	local b2=c:IsType(TYPE_FIELD)
	return cm.zcf(c) and (b1 or b2)
end
function cm.af(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end 
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct1=c:GetFlagEffect(m+100)
	local ct2=c:GetFlagEffect(m+300)
	local ct3=c:GetFlagEffect(m+500)
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local xge=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	local xgp=Duel.GetMatchingGroup(cm.zcf,tp,LOCATION_EXTRA,0,nil,tp)
	local amp=Duel.GetMatchingGroup(cm.af,tp,LOCATION_MZONE,0,nil)
	local hg=Duel.GetMatchingGroup(cm.pf,tp,LOCATION_HAND,0,nil,tp)
	local b1=#xge>0 and ct1==0
	local b2=zt>0 and #hg>0 and ct2==0
	local b3=zt>0 and #xgp>0 and #amp>0 and ct3==0
	if chk==0 then return b1 or b2 or b3 end   
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=c:GetFlagEffect(m+100)
	local ct2=c:GetFlagEffect(m+300)
	local ct3=c:GetFlagEffect(m+500)
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local xge=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	local xgp=Duel.GetMatchingGroup(cm.zcf,tp,LOCATION_EXTRA,0,nil,tp)
	local amp=Duel.GetMatchingGroup(cm.af,tp,LOCATION_MZONE,0,nil)
	local hg=Duel.GetMatchingGroup(cm.pf,tp,LOCATION_HAND,0,nil,tp)
	local b1=#xge>0 and ct1==0
	local b2=zt>0 and #hg>0 and ct2==0
	local b3=zt>0 and #xgp>0 and #amp>0 and ct3==0
	if (not b1) and (not b2) and (not b3) then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)},{b3,aux.Stringid(m,2)})
	if op==1 then
		cm.te(e,tp,eg,ep,ev,re,r,rp)   
	end   
	if op==2 then
		cm.pz(e,tp,eg,ep,ev,re,r,rp)
	end
	if op==3 then   
		cm.eq(e,tp,eg,ep,ev,re,r,rp) 
	end
end
function cm.te(e,tp,eg,ep,ev,re,r,rp)
	local xgp=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if #xgp==0 then return false end
	Duel.ConfirmCards(tp,xgp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=xgp:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.ShuffleExtra(1-tp)
	e:GetHandler():RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil,1)
end
function cm.pz(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.pf,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if not tc or tc==nil then return false end
	if tc:IsType(TYPE_FIELD) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	end
	if tc:IsLocation(LOCATION_SZONE) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end
	e:GetHandler():RegisterFlagEffect(m+300,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.eq(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,cm.zcf,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local tc=Duel.SelectMatchingCard(tp,cm.af,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			if not Duel.Equip(tp,ec,tc) then return false end
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(tc)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(500)
			ec:RegisterEffect(e2)
		end
	end
	e:GetHandler():RegisterFlagEffect(m+500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
--Effect 3 
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(tp)
	return tc and tc:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.xf(c) 
	return c:IsAbleToExtra()  
end   
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.xf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetBattleMonster(tp)
	if not tc:IsRelateToBattle() then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.xf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Select(tp,1,3,nil)
	if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return false end
	local vg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	local val=vg:GetSum(Card.GetLevel)+vg:GetSum(Card.GetRank)+vg:GetSum(Card.GetLink)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(val*100)
	tc:RegisterEffect(e1)
end