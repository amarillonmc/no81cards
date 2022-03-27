--多线程虚网操作员
local m=33300305
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,33300300+EFFECT_COUNT_CODE_OATH)
	e7:SetCost(aux.bfgcost)
	e7:SetTarget(cm.sptg)
	e7:SetOperation(cm.spop)
	c:RegisterEffect(e7)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.lcon)
	e1:SetTarget(cm.ltg)
	e1:SetOperation(cm.LinkOperation(nil,2,2,cm.gf))
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
function cm.gf(g)
	return g:IsExists(cm.lcheck,1,nil)
end
function cm.lcon(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkCondition(nil,2,2,cm.gf)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.ltg(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkTarget(nil,2,2,cm.gf)(...)
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
function cm.thfilter(c)
	return c:IsSetCard(0x562) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			if e:GetHandler():IsRelateToEffect(e) then
				Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
			end
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
function cm.tgcheck(c)
	return c:IsLocation(LOCATION_SZONE) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup())
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x562) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
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
			if cm.IsLinkZoneOver(3)and Duel.IsExistingMatchingCard(cm.tgcheck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=Duel.SelectMatchingCard(tp,cm.tgcheck,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end