--终墟戮途
local m=30015110
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.sumcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.alldrawflag(c)
end
c30015110.isoveruins=true
--
function cm.excon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	return ec:GetFlagEffect(m)==0
end
--Activate
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sumchk(c) 
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end  
function cm.smf(c,e,tp,ph)
	local ec=e:GetHandler()
	if c:GetOriginalLevel()<5 then return false end
	local e11=Effect.CreateEffect(ec)
	e11:SetDescription(aux.Stringid(m,0))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(cm.otcontwo)
	e11:SetOperation(cm.otoptwo)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph)
	c:RegisterEffect(e11,true)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_SET_PROC)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph)
	c:RegisterEffect(e12,true)
	e11:Reset()
	e12:Reset()
	local rct
	local dmct
	local ct=c:GetLevel()
	if ct==5 or ct==6 then
		rct=1
		dmct=2
	elseif ct>=7 and ct<10 then
		rct=2
		dmct=4
	elseif ct>=10 then
		rct=3
		dmct=6
	end
	local mg=Duel.GetMatchingGroup(ors.srm,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local reg=Duel.GetMatchingGroup(ors.ref,tp,LOCATION_ONFIELD,0,e:GetHandler(),tp)
	return c:IsLevelAbove(5) and (#mg>=dmct or #reg>=rct) or cm.sumchk(c)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smf,tp,LOCATION_HAND,0,1,nil,e,tp,ph) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.smf,tp,LOCATION_HAND,0,1,1,nil,e,tp,ph):GetFirst()
	if tc then
		local e11=Effect.CreateEffect(c)
		e11:SetDescription(aux.Stringid(m,0))
		e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_SUMMON_PROC)
		e11:SetCondition(cm.otcontwo)
		e11:SetOperation(cm.otoptwo)
		e11:SetValue(SUMMON_TYPE_ADVANCE)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph)
		tc:RegisterEffect(e11)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_SET_PROC)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph)
		tc:RegisterEffect(e12)
		--limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+ph)
		e1:SetOperation(cm.limitop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(cm.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+ph)
		Duel.RegisterEffect(e2,tp)
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousControler(1-tp)
end
function cm.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial()
	if tc==e:GetLabelObject() and #mg>0 then
		local res=1
		Duel.BreakEffect()
		mg:AddCard(c)
		cm.exrmop(e,tp,res,mg)
	end
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
---exremove Check
function cm.exrmop(e,tp,res,exg)
	if res==0 then return false end
	local ec=e:GetHandler()
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(ors.rf),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,0,exg,1-tp) 
	if #rg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(30015500,4)) and Duel.IsPlayerCanRemove(1-tp) then
		Duel.Hint(HINT_CARD,0,ec:GetOriginalCodeRule())
		Duel.ConfirmCards(1-tp,rg)
		local sg=Group.CreateGroup()
		local g1=rg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		local g2=rg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local g3=rg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		local g4=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		local ct=3
		if #g1>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,0))
			local sg1=g1:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,exg,1-tp)
			ct=ct-#sg1
			sg:Merge(sg1)
		end
		if #g2>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,1))
			local sg2=g2:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,exg,1-tp)
			ct=ct-#sg2
			sg:Merge(sg2)
		end 
		if #g3>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,2))
			local sg3=g3:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,exg,1-tp)
			ct=ct-#sg3
			sg:Merge(sg3)
		end
		if #g4>0 and ct>0 then
			local nt=0
			if ct==3 then nt=1 end
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,3))
			local sg4=g4:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),nt,ct,exg,1-tp)
			ct=ct-#sg4
			sg:Merge(sg4)
		end
		if #sg==0 then return false end
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_DECK)>0 then
			Duel.ShuffleDeck(tp)
		end
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_EXTRA)>0 then
			Duel.ShuffleExtra(tp)
		end
	end
end
--proc or overuins II
function cm.procII(c,lv,rmval,reval)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(30015500,8))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(cm.otcontwo)
	e11:SetOperation(cm.otoptwo)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_SET_PROC)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e12)
end
function cm.otcontwo(e,c,minc)
	if c==nil then return true end
	if c:GetLevel()<5 then return false end
	local nc=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(ors.srm,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nc)
	local reg=Duel.GetMatchingGroup(ors.ref,tp,LOCATION_ONFIELD,0,nc,tp)
	local lv
	local rct
	local dmct
	local ct=c:GetLevel()
	if ct==5 or ct==6 then
		lv=5
		rct=1
		dmct=2
	elseif ct>=7 and ct<10 then
		lv=7
		rct=2
		dmct=4
	elseif ct>=10 then
		lv=7
		rct=3
		dmct=6
	end
	local exct=math.floor(dmct/2)
	local b1=mg:CheckSubGroup(ors.fck,dmct,dmct,tp,exct) and minc<=dmct
	local b2=#reg>=rct and minc<=rct
	return c:IsLevelAbove(lv) and (b1 or b2)
end
function cm.otoptwo(e,tp,eg,ep,ev,re,r,rp,c)
	local code=30015085
	local rct
	local dmct
	local ct=c:GetOriginalLevel()
	if ct==5 or ct==6 then
		rct=1
		dmct=2
	elseif ct>=7 and ct<10 then
		rct=2
		dmct=4
	elseif ct>=10 then
		rct=3
		dmct=6
	end
	local nc=e:GetHandler()
	tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(ors.srm,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nc)
	local reg=Duel.GetMatchingGroup(ors.ref,tp,LOCATION_ONFIELD,0,nc,tp)
	local exct=math.floor(dmct/2)
	local b1=mg:CheckSubGroup(ors.fck,dmct,dmct,tp,exct)
	local b2=#reg>=rct
	if b1 or b2 then
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(code,1),aux.Stringid(code,2))==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=mg:SelectSubGroup(tp,ors.fck,false,dmct,dmct,tp,exct)
			c:SetMaterial(sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
			if sg:FilterCount(Card.IsControler,nil,1-tp)>0 then
				local te=Duel.IsPlayerAffectedByEffect(tp,30015035)
				if te~=nil then te:UseCountLimit(tp) end
			end
		else
			local ssg
			if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
				ssg=reg:SelectSubGroup(tp,ors.tfck,false,bval,bval,tp)
			else
				ssg=reg:Select(tp,bval,bval,nil)
			end
			c:SetMaterial(ssg)
			Duel.Release(ssg,REASON_SUMMON+REASON_MATERIAL)
		end
	end
end