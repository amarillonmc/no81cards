--幻影
local m=16670010
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetSPSummonOnce(m)
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
    --
    local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.lkcon)
	e0:SetTarget(cm.lkop)
	e0:SetOperation(cm.lkop2)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
    --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(cm.target)
	e1:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e1)
    --[[
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
    ]]--
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
    --
end
function cm.target(e,c)
	return c:GetReasonCard()==e:GetHandler() and c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.spcost(e,c,tp,st)
	local b=0
	if bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK then
		e:SetLabel(1)
		b=Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_WATER)
	else e:SetLabel(0) end
	return b
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_HAND,0,1,1,nil,ATTRIBUTE_WATER)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.lkcon(e,c)
	if c==nil then return true end
	--if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c,tp)
    local mv=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=2
	local maxc=2
	if ct>maxc then return false end
	return cm.lcheck(tp,sg,c,minc,ct) or (mg:IsExists(cm.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc) and mv:IsExists(cm.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc))
end
function cm.lkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if tp==nil then return true end
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c,tp)
		local mv=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
		local sg=Group.CreateGroup()
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
			local pc=pe:GetHandler()
			if not mg:IsContains(pc) then return false end
			sg:AddCard(pc)
		end
		local ct=sg:GetCount()
		local minc=2
		local maxc=2
		if ct>maxc then return false end
		return cm.lcheck(tp,sg,c,minc,ct) or (mg:IsExists(cm.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc) and mv:IsExists(cm.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc))
	end
	local mg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c,tp)
    local mv=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=2
	local maxc=2
    local num=0
    local cg=true
	local cancel=Duel.IsSummonCancelable()
	for i=ct,maxc-1 do
		if num==0 then cg=mg:Filter(cm.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
            else cg=mv:Filter(cm.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
            end
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:SelectSubGroup(tp,aux.TRUE,cancel,minct,1)
		if not g then return false end
        if g:GetFirst():IsLocation(LOCATION_HAND) then
            num=num+1
        end
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
	return true
end
function cm.lkop2(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.lkfilter(c,lc,tp)
	local flag=c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag
	elseif c:IsLocation(LOCATION_HAND) then
		return true
	end
end
function cm.lkfilter2(c,lc,tp)
	local flag=c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag
	else
		return false
	end
end
function cm.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(cm.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function cm.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
function cm.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(cm.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
