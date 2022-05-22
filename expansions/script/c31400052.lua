local m=31400052
local cm=_G["c"..m]
cm.name="一灵神"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.linkcon)
	e1:SetTarget(cm.linktg)
	e1:SetOperation(cm.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.actcon)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.matcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.link_mat_filter(c,lc)
	local con=c:IsSetCard(0x113) and c:IsCanBeLinkMaterial(lc)
	local con_mzone=c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
	local con_remove=c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()
	local con_extra=false
	local tp=lc:GetControler()
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then con_extra=true end
	end
	local con_extra=con_extra and (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD))
	return con and (con_mzone or con_remove or con_extra)
end
function cm.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(cm.link_mat_filter,nil,c)
	else
		mg=Duel.GetMatchingGroup(cm.link_mat_filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD,nil,c)
	end
	if lmat~=nil then
		if not cm.link_mat_filter(lmat,c) then return false end
		mg:AddCard(lmat)
	end
	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(fg)
	return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,Auxiliary.dabcheck,lmat)
end
function cm.linktg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local mg=nil
	if og then
		mg=og:Filter(cm.link_mat_filter,nil,c)
	else
		mg=Duel.GetMatchingGroup(cm.link_mat_filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD,nil,c)
	end
	if lmat~=nil then
		if not cm.link_mat_filter(lmat,c) then return false end
		mg:AddCard(lmat)
	end
	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	Duel.SetSelectedCard(fg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,Auxiliary.dabcheck,lmat)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Auxiliary.LExtraMaterialCount(g,c,tp)
	local removeg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
	Duel.Remove(removeg,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
	g:Sub(removeg)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.actfilter(c,tp)
	return c:IsCode(61557074,11167052) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.GetMatchingGroup(cm.actfilter,tp,LOCATION_DECK,0,nil,tp):SelectSubGroup(tp,Auxiliary.dncheck,false,0,2)
	tc=g:GetFirst()
	while tc do
		if tc:IsCode(61557074) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		tc=g:GetNext()
	end
end
function cm.matcheck(e,c)
	local g=c:GetMaterial()
	local attr=0
	tc=g:GetFirst()
	while tc do
		c:CopyEffect(tc:GetCode(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
		attr=attr+tc:GetAttribute()
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(attr)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_RELEASE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2800)
end
function cm.spfilter(c)
	return c:IsCode(m) and c:IsLinkSummonable(nil,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,nil)
	end
end