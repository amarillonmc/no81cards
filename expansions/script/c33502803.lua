--幻蓝花海 魔女之旅
function c33502803.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddCodeList(c,33502800)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33502803,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33502803)
	e1:SetCost(c33502803.cost1)
	e1:SetTarget(c33502803.tg1)
	e1:SetOperation(c33502803.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33502803,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c33502803.con2)
	e2:SetTarget(c33502803.tg2)
	e2:SetOperation(c33502803.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_GRAVE)
	e3:SetCondition(c33502803.con3)
	c:RegisterEffect(e3)
--
end
--
function c33502803.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not c:IsForbidden() end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1_1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e1_1)
end
--
function c33502803.tfilter1(c)
	return aux.IsCodeListed(c,33502800) and c:IsAbleToHand()
end
function c33502803.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33502803.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
--
function c33502803.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local lg=Duel.SelectMatchingCard(tp,c33502803.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if lg:GetCount()>0 and Duel.SendtoHand(lg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,lg)
		Duel.ShuffleHand(tp)
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
--
function c33502803.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
--
function c33502803.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33502803.ofilter2,tp,0,LOCATION_EXTRA,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
--
function c33502803.ofilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33502803.ofilter2_1(c)
	return c:IsType(TYPE_LINK) or (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c33502803.ofilter2_4(c)
	return c:IsAbleToExtra() and c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION+TYPE_LINK)
end
function c33502803.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--
	local ft=Duel.GetUsableMZoneCount(1-tp)
	local ft1=Duel.GetLocationCountFromEx(1-tp,1-tp,nil,TYPE_PENDULUM)
--
	local mg=Duel.GetMatchingGroup(c33502803.ofilter2,1-tp,LOCATION_EXTRA,0,nil,e,tp)
	if mg:GetCount()<1 then return end
--
	local ng=Group.CreateGroup()
	ng:Merge(mg)
	local cg=mg:Filter(c33502803.ofilter2_1,nil)
	if cg:GetCount()>0 then
		ng:Sub(cg)
		ft1=math.min(ft1,cg:GetCount())
		if ng and ng:GetCount()>0 then
			ft=math.min(ft,ng:GetCount()+ft1)
		else
			ft=math.min(ft,ft1)
		end
	else
		ft=math.min(ft,mg:GetCount())
	end
--
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(1-tp,29724053) and c29724053[1-tp]
	if ect and ect<ft then ft=ect end
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then
		if ft1>0 then ft1=1 end
		ft=1
	end
--
	local sg=mg:SelectSubGroup(1-tp,c33502803.SPCheck,false,ft,ft,ft,ft1)
	if sg:GetCount()<0 then return end
--
	local fid=c:GetFieldID()
	local lg=Group.CreateGroup()
	local ag=sg:Filter(c33502803.ofilter2_1,nil)
	if ag:GetCount()>0 then
		lg:Merge(sg)
		lg:Sub(ag)
		local ac=ag:GetFirst()
		while ac do
			Duel.SpecialSummonStep(ac,0,1-tp,1-tp,false,false,POS_FACEUP)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_DISABLE)
			e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ac:RegisterEffect(e2_1,true)
			local e2_2=e2_1:Clone()
			e2_2:SetCode(EFFECT_DISABLE_EFFECT)
			ac:RegisterEffect(e2_2,true)
			ac:RegisterFlagEffect(33502803,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			ac=ag:GetNext()
		end
	end
	local sc=lg:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_DISABLE)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2_1,true)
		local e2_2=e2_1:Clone()
		e2_2:SetCode(EFFECT_DISABLE_EFFECT)
		sc:RegisterEffect(e2_2,true)
		sc:RegisterFlagEffect(33502803,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		sc=lg:GetNext()
	end
	Duel.SpecialSummonComplete()
--
	sg:KeepAlive()
	local e2_3=Effect.CreateEffect(c)
	e2_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_3:SetCode(EVENT_PHASE+PHASE_END)
	e2_3:SetCountLimit(1)
	e2_3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2_3:SetLabel(fid)
	e2_3:SetLabelObject(sg)
	e2_3:SetCondition(c33502803.con2_3)
	e2_3:SetOperation(c33502803.op2_3)
	Duel.RegisterEffect(e2_3,tp)
--
	if Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 then
		local og=Duel.GetMatchingGroup(Card,IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
		if og:GetCount()<1 then return end
		Duel.BreakEffect()
		if Duel.Remove(og,POS_FACEUP,REASON_EFFECT)>0 then
			local fg=Duel.GetOperatedGroup()
			local vg=fg:Filter(c33502803.ofilter2_4,nil)
			if vg:GetCount()<1 then return end
			Duel.DisableShuffleCheck()
			Duel.SendtoDeck(vg,tp,2,REASON_EFFECT)
		end
	end
--
end
--
function c33502803.SPCheckFilter(c)
	return c:IsType(TYPE_LINK) or (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c33502803.SPCheck(sg,ft,ft1)
	return sg:FilterCount(c33502803.SPCheckFilter,nil)<=ft1 and sg:GetCount()==ft
end
--
function c33502803.cfilter2_3(c,fid)
	return c:GetFlagEffectLabel(33502803)==fid
end
function c33502803.con2_3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c33502803.cfilter2_3,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c33502803.op2_3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c33502803.cfilter2_3,nil,e:GetLabel())
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
--
function c33502803.con3(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
--
