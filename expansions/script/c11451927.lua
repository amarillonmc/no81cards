--悠远之扉：因果
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.LinkCondition(nil,2,2))
	e0:SetTarget(cm.LinkTarget(nil,2,2))
	e0:SetOperation(cm.LinkOperation(nil,2,2))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
end
function cm.fdfilter(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE) and c:IsSetCard(0x97d) and c:GetActivateEffect()
end
function cm.LConditionFilter(c,f,lc)
	return (((c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc)) or (Duel.GetFlagEffect(lc:GetControler(),m)<=Duel.GetTurnCount() and cm.fdfilter(c))) and (not f or f(c))
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter,tp,LOCATION_ONFIELD,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	Debug.Message("")
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg)) and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp) and (not lmat or sg:IsContains(lmat)) and sg:FilterCount(cm.fdfilter,nil)<=Duel.GetTurnCount()-Duel.GetFlagEffect(tp,m)+1
end
function cm.LinkCondition(f,minc,maxc,gf)
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
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
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
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					if sg:IsExists(cm.fdfilter,1,nil) then
						for i=1,#sg do Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1) end
					end
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				aux.LExtraMaterialCount(g,c,tp)
				g1=g:Filter(cm.fdfilter,nil)
				g:Sub(g1)
				--Duel.SendtoDeck(g1,nil,2,REASON_MATERIAL+REASON_LINK)
				for oc in aux.Next(g1) do
					oc:RegisterFlagEffect(m,0,0,1)
					local te=oc:GetActivateEffect()
					local con=te:GetCondition()
					local tg=te:GetTarget()
					local op=te:GetOperation()
					local e1=Effect.CreateEffect(oc)
					e1:SetDescription(aux.Stringid(m,0))
					e1:SetCategory(te:GetCategory())
					e1:SetType(EFFECT_TYPE_QUICK_F)
					e1:SetCode(EVENT_SPSUMMON_SUCCESS)
					e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
					e1:SetLabelObject(c)
					--if con then e1:SetCondition(con) end
					e1:SetCost(cm.addcost)
					if tg then e1:SetTarget(cm.btg(tg)) end
					if op then e1:SetOperation(op) end
					Duel.RegisterEffect(e1,tp)
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if chk==0 then
		return eg:IsContains(c)
	end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
end
function cm.btg(tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return true end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end