--混合咖啡·多彩调制
function c9910582.initial_effect(c)
	--link summon
	local e0=c9910582.AddLinkProcedure(c,nil,2,99,c9910582.lcheck)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	--active limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c9910582.accon1)
	e1:SetValue(c9910582.aclimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(1,1)
	e2:SetCondition(c9910582.accon2)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9910582.discon)
	e3:SetCost(c9910582.discost)
	e3:SetTarget(c9910582.distg)
	e3:SetOperation(c9910582.disop)
	c:RegisterEffect(e3)
end
function c9910582.AddLinkProcedure(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(c9910582.LinkCondition(f,min,max,gf))
	e1:SetTarget(c9910582.LinkTarget(f,min,max,gf))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end
function c9910582.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function c9910582.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(c9910582.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function c9910582.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(c9910582.LConditionFilter,nil,f,c,e)
				else
					mg=c9910582.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not c9910582.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function c9910582.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(c9910582.LConditionFilter,nil,f,c,e)
				else
					mg=c9910582.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not c9910582.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
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
end
function c9910582.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc951)
end
function c9910582.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and not rc:IsSummonableCard()
end
function c9910582.accon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910582)==0
end
function c9910582.accon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910582)~=0
end
function c9910582.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainDisablable(ev)
end
function c9910582.costfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsDiscardable()
end
function c9910582.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910582.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c9910582.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	if tc:IsSetCard(0xc951) then
		e:GetHandler():RegisterFlagEffect(9910582,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910582,0))
	end
end
function c9910582.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910582.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
