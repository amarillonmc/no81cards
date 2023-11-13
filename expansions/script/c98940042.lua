--光芒使者 土星
function c98940042.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),2,4)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940042,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,98940042)
	e1:SetCondition(c98940042.hspcon)
	e1:SetTarget(c98940042.LinkTarget)
	e1:SetOperation(c98940042.LinkOperation)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c98940042.desreptg)
	e2:SetOperation(c98940042.desrepop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98940042,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c98940042.rcon)
	e3:SetTarget(c98940042.rtg)
	e3:SetOperation(c98940042.rop)
	c:RegisterEffect(e3)
end
function c98940042.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c98940042.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,2800)
end
function c98940042.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2800,REASON_EFFECT)
	Duel.Recover(1-tp,2800,REASON_EFFECT)
end
function c98940042.hctfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function c98940042.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(c98940042.hctfil,tp,LOCATION_REMOVED,0,1,nil)
end
function c98940042.issetcard(c,lc)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeLinkMaterial(lc) and c:IsFaceup()
end
function c98940042.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function c98940042.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(c98940042.cfilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	local mg3=Duel.GetMatchingGroup(c98940042.issetcard,tp,LOCATION_REMOVED,0,nil,lc)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c98940042.hspcon(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=2
				local maxc=4
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,nil,c,e)
				else
					mg=c98940042.GetLinkMaterials(tp,nil,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,nil,c,e) then return false end
					mg:AddCard(lmat)
				end
				--local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				--if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				--Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,nil,lmat)
end
function c98940042.LinkTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=2
				local maxc=4
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,nil,c,e)
				else
					mg=c98940042.GetLinkMaterials(tp,nil,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,nil,c,e) then return false end
					mg:AddCard(lmat)
				end
				--local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				--Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,nil,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
end
function c98940042.LinkOperation(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Auxiliary.LExtraMaterialCount(g,c,tp)
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	g=g-sg
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoDeck(sg,nil,2,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
	sg:DeleteGroup()
end
function c98940042.repfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c98940042.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetLinkedGroup()
		return c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and g:IsExists(c98940042.repfilter,1,nil,e,tp)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetLinkedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,c98940042.repfilter,1,1,nil,e,tp)
		e:SetLabelObject(sg:GetFirst())
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c98940042.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	if not tc:IsControler(tp) then
	   Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end