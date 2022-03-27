--链路虚网控制者
local m=33300306
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e7:SetCost(aux.bfgcost)
	e7:SetTarget(cm.sptg)
	e7:SetOperation(cm.spop)
	c:RegisterEffect(e7)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.lcon)
	e1:SetTarget(cm.ltg)
	e1:SetOperation(cm.LinkOperation(nil,2,3,cm.gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				if g:IsExists(cm.extracheck,1,nil) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
					e3:SetValue(1)
					e3:SetReset(RESET_EVENT+0x7e0000)
					c:RegisterEffect(e3,true)
				end
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.lcheck(c)
	return c:IsSetCard(0x562) or c:GetOriginalCode()==33300308
end
function cm.extracheck(c)
	return c:IsFaceup() and c:GetOriginalCode()==33300308
end
function cm.exc(c)
	return not c:IsType(TYPE_EFFECT) and not c:GetOriginalCode()==33300308 
end
function cm.gf(g)
	return g:IsExists(cm.lcheck,1,nil) and not g:IsExists(cm.exc,1,nil)
end
function cm.lcon(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkCondition(nil,2,3,cm.gf)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.ltg(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkTarget(nil,2,3,cm.gf)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	local mg3=Duel.GetMatchingGroup(cm.extracheck,tp,LOCATION_SZONE,0,nil)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function cm.ctcheck(c,tp)
	return c:IsControler(1-tp)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetLinkedGroup()
	if not tg:IsExists(cm.ctcheck,1,nil,tp,zone) then
	  return false 
	end
	local tc=tg:Filter(cm.ctcheck,nil,tp):GetFirst()
	if chk==0 then
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		return tc:IsControlerCanBeChanged(false,zone) --tg:IsExists(cm.ctcheck,1,nil,tp,zone) 
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		if Duel.GetControl(tc,tp,0,0,zone)~=0 then
			Duel.BreakEffect()
			--Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end
function cm.IsLinkZoneOver(count)
	local flag=0
	for i=0,4 do
		if (Duel.GetLinkedZone(0)&((2^i)<<0))~=0 then
			flag=flag+1
		elseif (Duel.GetLinkedZone(1)&((2^i)<<0))~=0 then
			flag=flag+1
		end
	end
	return flag>=count
end 
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x562) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or aux.NegateMonsterFilter(c))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
			if cm.IsLinkZoneOver(3)and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
				local tc=sg:GetFirst()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetValue(0)
				tc:RegisterEffect(e3)
			end
		end
	end
end