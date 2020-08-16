local m=31480005
local cm=_G["c"..m]
cm.name="邪道的神欲"
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
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.tga)
	e5:SetOperation(cm.opa)
	c:RegisterEffect(e5)
	local e6=Effect.Clone(e5)
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetTarget(cm.tgb)
	e6:SetOperation(cm.opb)
	c:RegisterEffect(e6)
end
function cm.lkfilter(c,lc,tp)
	if not (c:IsFaceup() and c:IsSetCard(0x1313)) then
		return false
	else
		if c:IsType(TYPE_MONSTER) then
			return c:IsCanBeLinkMaterial(lc)
		else
			return true
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
	local minc=2
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
	local minc=2
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
function cm.filtera(c,e,tp)
	return c:IsSetCard(0x3313) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filtera,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filtera,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.filterb(c)
	return (c:IsSetCard(0x3313) or c:IsCode(31480012)) and c:IsAbleToHand()
end
function cm.tgb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filterb,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.opb(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filterb,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end