--贯通的封缄英杰 苏特拉斯
function c67200299.initial_effect(c)
	--link summon

	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c67200299.linkcon)
	e1:SetTarget(c67200299.linktg)
	e1:SetOperation(c67200299.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)	
end
---
function c67200299.link_mat_filter(c,lc)
	local con=c:IsSetCard(0x674) and c:IsCanBeLinkMaterial(lc)
	local con_mzone=c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
	local con_remove=c:IsLocation(LOCATION_SZONE) and c:IsReleasable() and c:IsType(TYPE_PENDULUM)
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
function c67200299.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	if c:IsFaceup() then return false end
	local minc=2
	local maxc=3
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c67200299.link_mat_filter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c67200299.link_mat_filter,tp,LOCATION_ONFIELD,0,nil,c)
	end
	if lmat~=nil then
		if not c67200299.link_mat_filter(lmat,c) then return false end
		mg:AddCard(lmat)
	end
	local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
	if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(fg)
	return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
end
function c67200299.linktg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
	local minc=2
	local maxc=3
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local mg=nil
	if og then
		mg=og:Filter(c67200299.link_mat_filter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c67200299.link_mat_filter,tp,LOCATION_ONFIELD,0,nil,c)
	end
	if lmat~=nil then
		if not c67200299.link_mat_filter(lmat,c) then return false end
		mg:AddCard(lmat)
	end
	local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
	Duel.SetSelectedCard(fg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c67200299.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Auxiliary.LExtraMaterialCount(g,c,tp)
	local removeg=g:Filter(Card.IsLocation,nil,LOCATION_SZONE)
	Duel.Release(removeg,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
	g:Sub(removeg)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
end

