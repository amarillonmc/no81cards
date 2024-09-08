--义侠 翎飒
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.syncon)
	e0:SetTarget(s.syntg)
	e0:SetOperation(s.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function s.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function s.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return s.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function s.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if (c:IsSynchroType(TYPE_TUNER) and c:IsLocation(LOCATION_SZONE) and bit.band(c:GetRace(),RACE_WINDBEAST)==RACE_WINDBEAST) and c:IsControler(tp) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard)
end
function s.matfilter2(c,syncard)
	return not c:IsSynchroType(TYPE_TUNER) and (c:IsRace(RACE_WINDBEAST) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) or c:IsLocation(LOCATION_SZONE) and bit.band(c:GetRace(),RACE_WINDBEAST)==RACE_WINDBEAST) and c:IsCanBeSynchroMaterial(syncard)
end
function s.val(c,syncard)
	if c:IsLocation(LOCATION_SZONE) then
		return c:GetOriginalLevel()
	else
		return c:GetSynchroLevel(syncard)
	end
end
function s.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(s.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function s.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return s.CheckGroup(tsg,s.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function s.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(s.val,lv,ct,ct,syncard) and g:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)
end
function s.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(s.matfilter1,nil,c,tp)
		g2=mg:Filter(s.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_ONFIELD,0,nil,c,tp)
		g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_ONFIELD,0,nil,c)
		g3=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return s.matfilter1(c,tp) and s.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return s.matfilter1(pe:GetOwner(),tp) and s.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(s.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(s.matfilter1,nil,c,tp)
		g2=mg:Filter(s.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_ONFIELD,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_ONFIELD,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,s.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=tuc.tuner_filter
	if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=s.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,s.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function s.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE)
		and c:IsRace(RACE_WINDBEAST)
		and c:IsLevel(1)
		or c:IsLocation(LOCATION_SZONE)
		and c:GetOriginalType()&TYPE_MONSTER>0
		and bit.band(c:GetRace(),RACE_WINDBEAST)==RACE_WINDBEAST
		and c:GetOriginalLevel()==1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.eqfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and Duel.IsExistingMatchingCard(s.eqfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.eqfilter2(c)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.thfilter(c)
	return c:IsSetCard(0x38c0) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
		e:SetCategory(CATEGORY_EQUIP)
		e:SetLabel(1)
	elseif opval[op]==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetLabel(2)
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			local ec=g:GetFirst()
			if not ec or not Duel.Equip(tp,ec,tc) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			e1:SetLabelObject(tc)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(ec)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e2)
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end