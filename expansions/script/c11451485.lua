--魔人★双子兵装 神塔劫火
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.imcon)
	e2:SetCost(cm.imcost)
	e2:SetTarget(cm.imtg)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
end
if not Duel.GetMustMaterial then
	function Duel.GetMustMaterial(tp,code)
		local g=Group.CreateGroup()
		local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if tc then g:AddCard(tc) end
		end
		return g
	end
end
function cm.spfilter(c,sc)
	return c:IsCanBeXyzMaterial(sc) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsXyzLevel(sc,8) or c:IsRank(8) or (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FAIRY)))) or (c:IsLocation(LOCATION_HAND) and (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FAIRY))) or (not c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsXyzLevel(sc,8) or c:IsRank(8)))
end
function cm.hand(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
end
function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local minc=2
	local maxc=2
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	if maxc<minc then return false end
	local mg=nil
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,c)
	local exchk=cm.hand
	if og then
		mg=og:Filter(cm.spfilter2,c,c)
		exchk=aux.TRUE
	else
		mg=g
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(aux.XyzLevelFreeGoal,minc,maxc,tp,c,exchk)
	aux.GCheckAdditional=nil
	return res
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,c)
	local exchk=cm.hand
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c)
		exchk=aux.TRUE
	else
		mg=g
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local g=mg:SelectSubGroup(tp,aux.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,exchk)
	aux.GCheckAdditional=nil
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		local sg=Group.CreateGroup()
		for tc in aux.Next(og) do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local g=e:GetLabelObject()
		local sg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
		if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(tp) end
		g:DeleteGroup()
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x97b) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return (e:GetHandler():IsType(TYPE_XYZ) and g:GetClassCount(Card.GetCode)>=2) or (#g>0 and Duel.IsPlayerAffectedByEffect(tp,11451481)) end
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451481) then
		if g:GetClassCount(Card.GetCode)>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451481,0,0,1)
				Duel.ResetFlagEffect(tp,11451482)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451481,0,0,1)
			Duel.ResetFlagEffect(tp,11451482)
		end
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local op=e:GetLabel()
	if g:GetClassCount(Card.GetCode)>=2 and op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(1-tp,1,1,nil)
		sg:Sub(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		if e:GetHandler():IsRelateToEffect(e) then Duel.Overlay(e:GetHandler(),sg) end
		Duel.ConfirmCards(1-tp,tg)
	elseif #g>0 and op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) or (c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsPlayerAffectedByEffect(tp,11451481)) end
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451481) then
		if c:CheckRemoveOverlayCard(tp,2,REASON_COST) then
			op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451481,0,0,1)
				Duel.ResetFlagEffect(tp,11451482)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451481,0,0,1)
			Duel.ResetFlagEffect(tp,11451482)
		end
	end
	c:RemoveOverlayCard(tp,2-op,2-op,REASON_COST)
end
function cm.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),0,0)
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoGrave(eg,REASON_EFFECT)
end