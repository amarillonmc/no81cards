--百夫骑士皇·牵绊
local m=11513086
local cm=_G["c"..m]
function c11513086.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,11513086)
	e1:SetTarget(c11513086.target)
	e1:SetOperation(c11513086.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11514086)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(11513086)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c11513086.efcon)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--synchro custom  
	--effect gain
	if not c11513086.global_check then
		c11513086.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(c11513086.adjustop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c11513086.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c11513086.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end


function c11513086.adjustopfilter(c)
	return c:IsSetCard(0x1a2) and not c:IsCode(11513086) and c:IsType(TYPE_SYNCHRO) and not c:GetFlagEffectLabel(11513086)
end
function c11513086.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Duel.GetMatchingGroup(c11513086.adjustopfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=sg:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(tc)
		e0:SetDescription(aux.Stringid(11514086,2))
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_SPSUMMON_PROC)
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetRange(LOCATION_EXTRA)
		e0:SetCondition(c11513086.syncon)
		e0:SetTarget(c11513086.syntg)
		e0:SetOperation(c11513086.synop)
		e0:SetValue(SUMMON_TYPE_SYNCHRO)
		tc:RegisterEffect(e0)
		tc:RegisterFlagEffect(11513086,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		tc=sg:GetNext()
	end
end

function c11513086.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c11513086.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c11513086.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(c11513086.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function c11513086.val(c,syncard)
	local slv=c:GetSynchroLevel(syncard)
	if c:IsSynchroType(TYPE_MONSTER) and c:IsLocation(LOCATION_SZONE) then
		slv=c:GetSynchroLevel(syncard)
	end
	return slv
end
function c11513086.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(c11513086.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,11513086))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,c11513086.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		if tg:GetCount()==0 then error("Incorrect Group Filter",2) end
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function c11513086.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsControler(tp) and (c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_MZONE)) then return true end 
	return c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syncard) and c:IsFaceup() and( c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_SZONE) )
end
function c11513086.matfilter2(c,syncard)
	if c:IsSynchroType(TYPE_MONSTER) and c:IsControler(tp) and (c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_MZONE)  ) and (not c:IsSynchroType(TYPE_TUNER) or (c:IsCode(11513086) and not c:IsDisabled())) then return true end 
	return c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syncard) and c:IsFaceup() and( c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_SZONE) ) and (not c:IsSynchroType(TYPE_TUNER) or (c:IsCode(11513086) and not c:IsDisabled()))
end
function c11513086.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return c11513086.CheckGroup(tsg,c11513086.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function c11513086.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c11513086.val,lv,ct,ct,syncard)
end
function c11513086.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsFaceup() then return false end
	local tp=c:GetControler()
	if not Duel.IsPlayerAffectedByEffect(tp,11513086) then return false end
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c11513086.matfilter1,nil,c,tp)
		g2=mg:Filter(c11513086.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c11513086.matfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c11513086.matfilter2,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c11513086.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return c11513086.matfilter1(c,tp) and c11513086.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(c11513086.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function c11513086.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c11513086.matfilter1,nil,c,tp)
		g2=mg:Filter(c11513086.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c11513086.matfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c11513086.matfilter2,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c11513086.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,c11513086.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
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
	local g=c11513086.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,c11513086.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c11513086.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c11513086.tgrfilter(c)
	return c:IsFaceupEx() and c:IsLevelAbove(1)
end
function c11513086.mnfilter(c,g)
	return g:IsExists(c11513086.mnfilter2,1,c,c)
end
function c11513086.mnfilter2(c,mc)
	return math.abs(c:GetLevel()-mc:GetLevel())==4
end
function c11513086.fselect(g,tp,sc)
	return g:GetCount()==2 and g:IsExists(Card.IsSetCard,1,nil,0x1a2) and g:IsExists(c11513086.mnfilter,1,nil,g) 
end
function c11513086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11513086.tgrfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(c11513086.fselect,2,2,tp,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c11513086.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11513086.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=e:GetLabelObject()
	tg:AddCard(c)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<tg:GetCount() then return end
	for tc in aux.Next(tg) do
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1)
		end
	end
	tg:DeleteGroup()
end
