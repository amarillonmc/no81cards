local m=31480001
local cm=_G["c"..m]
cm.name="不灭的神欲下仆"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.lkcon)
	e1:SetOperation(cm.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	--c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_MOVE)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.thcon)
	e5:SetCost(cm.cost)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
end
function cm.lkfilter(c,lc,tp)
	if not c:IsFaceup() then
		return false
	else
		if c:IsType(TYPE_MONSTER) then
			return c:IsCanBeLinkMaterial(lc) and not c:IsCode(31480001)
		else
			return c:IsFaceup() and c:IsSetCard(0x1313)
		end
	end
end
function cm.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1
	end
end
function cm.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(cm.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function cm.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(cm.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=99
	if ct>maxc then return false end
	return cm.lcheck(tp,sg,c,minc,ct) or mg:IsExists(cm.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
function cm.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=1
	local maxc=99
	for i=ct,maxc-1 do
		local cg=mg:Filter(cm.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	return c:GetLinkedZone()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE) and c~=re:GetHandler() end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
	return true
end
function cm.repval(e,c)
	return false
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsSetCard(0x1313) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end