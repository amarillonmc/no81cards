local m=53799104
local cm=_G["c"..m]
cm.name="合凰神-奈芙提斯"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.descon2)
	e3:SetTarget(cm.destg2)
	e3:SetOperation(cm.desop2)
	c:RegisterEffect(e3)
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.val(c,syncard)
	return c:GetSynchroLevel(syncard)
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,210))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,cm.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		if tg:GetCount()==0 then error("Incorrect Group Filter",2) end
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function cm.matfilter1(c,syncard,e,tp)
	return c:IsDestructable(e) and (c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x11f)) and c:IsCanBeSynchroMaterial(syncard) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
end
function cm.matfilter2(c,syncard,e)
	return c:IsDestructable(e) and c:IsRace(RACE_WINDBEAST) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsCanBeSynchroMaterial(syncard)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
end
function cm.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return cm.CheckGroup(tsg,cm.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function cm.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(cm.val,lv,ct,ct,syncard)
end
function cm.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c,e,tp)
		g2=mg:Filter(cm.matfilter2,nil,c,e)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,e,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,e)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,e)
	end
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return cm.matfilter1(c,e,tp) and cm.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(cm.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c,e,tp)
		g2=mg:Filter(cm.matfilter2,nil,c,e)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,e,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,e)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,e)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,cm.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
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
	local g=cm.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,cm.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Destroy(g,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.filter(c,e,tp,code)
	return c:IsSetCard(0x11f) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,code)
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsSetCard(0x11f) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	Duel.Destroy(eg,REASON_EFFECT)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE)) or (e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x11f))) or e:GetHandler():IsReason(REASON_RELEASE)
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,1)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
