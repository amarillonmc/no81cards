local m=15005369
local cm=_G["c"..m]
cm.name="迷忆渊裔288-镜中的真我"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xfc)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DETACH_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.ctcon)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
	--attach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.xcost)
	e4:SetTarget(cm.xtg)
	e4:SetOperation(cm.xop)
	c:RegisterEffect(e4)
end
function cm.tgrfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.mnfilter1(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsRank(3)
end
function cm.mnfilter2(c)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xcf3c)
end
function cm.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(cm.mnfilter1,1,nil) and g:IsExists(cm.mnfilter2,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2,tp,c)
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,cm.fselect,true,2,2,tp,c)
	if tg and tg:GetCount()==2 then
		tg:KeepAlive()
		e:SetLabelObject(tg)
		return true
		else return false
	end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.SendtoGrave(tg,REASON_COST)
	local og=Duel.GetOperatedGroup()
	local og2=og:Filter(Card.IsType,nil,TYPE_MONSTER)
	if og2:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		og2=og2:Select(tp,1,1,nil)
	end
	local tc=og2:GetFirst()
	if tc then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+0xff0000,1)
		end
	end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0xfc,1)
end
function cm.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.xfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local b1=(c:IsCanRemoveCounter(tp,0xfc,2,REASON_COST) and Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,c))
		local b2=(c:IsCanRemoveCounter(tp,0xfc,3,REASON_COST) and Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,c))
		return b1 or b2
	end
	local b1=(c:IsCanRemoveCounter(tp,0xfc,2,REASON_COST) and Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,c))
	local b2=(c:IsCanRemoveCounter(tp,0xfc,3,REASON_COST) and Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,c))
	local min=2
	if not Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,c) then min=3 end
	local max=c:GetCounter(0xfc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	local ct=Duel.AnnounceLevel(tp,min,max)
	c:RemoveCounter(tp,0xfc,ct,REASON_COST)
	e:SetLabel(ct)
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local loc=0
	if ct>=3 then loc=LOCATION_GRAVE+LOCATION_MZONE end
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.xfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,loc,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		if not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,tg)
		end
	end
end