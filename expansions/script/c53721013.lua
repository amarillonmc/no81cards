local m=53721013
local cm=_G["c"..m]
cm.name="悚牢之坚壁"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTarget(cm.syntg)
	e0:SetValue(1)
	e0:SetOperation(cm.synop)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_HAND_SYNCHRO)
	e01:SetTarget(cm.hsyntg)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetRange(LOCATION_HAND)
	e02:SetTargetRange(LOCATION_MZONE,0)
	e02:SetCondition(cm.hscon)
	e02:SetTarget(cm.hstg)
	e02:SetLabelObject(e0)
	c:RegisterEffect(e02)
	local e03=e02:Clone()
	e03:SetLabelObject(e01)
	c:RegisterEffect(e03)
	local e04=Effect.CreateEffect(c)
	e04:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e04:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e04:SetCode(EVENT_ADJUST)
	e04:SetRange(LOCATION_HAND)
	e04:SetOperation(cm.adjustop)
	c:RegisterEffect(e04)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.synfilter2(c,syncard,tuner,f)
	return c:IsOriginalSetCard(0xa531) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=cm.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function cm.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function cm.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(cm.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_AQUA) then
		local exg=Duel.GetMatchingGroup(cm.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		mg:Merge(exg)
	end
	return mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(cm.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_AQUA) then
		local exg=Duel.GetMatchingGroup(cm.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		mg:Merge(exg)
	end
	for i=1,maxc do
		local cg=mg:Filter(cm.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then
		for tc in aux.Next(hg) do
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SetSynchroMaterial(g)
end
function cm.hsyntg(e,c)
	return c:IsOriginalSetCard(0xa531) and c:IsNotTuner(syncard)
end
function cm.hscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53721049)>0
end
function cm.hstg(e,c)
	return c:IsType(TYPE_TUNER)
end
function cm.hsfilter(c)
	return c:IsOriginalSetCard(0xa531) and not c:IsType(TYPE_TUNER) and c:GetFlagEffect(53721049)>0
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.hsfilter,tp,LOCATION_HAND,0,c)
	if #g==0 then
		c:RegisterFlagEffect(53721049,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and c:GetFlagEffect(m)>0
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,3,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,3,3,c)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e) or #g~=3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,2,nil)
	g:Sub(sg)
	sg:AddCard(c)
	Duel.DisableShuffleCheck()
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end
