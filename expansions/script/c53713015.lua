local m=53713015
local cm=_G["c"..m]
cm.name="狄余思"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.LinkCondition(cm.matfilter,1,2,nil))
	e0:SetTarget(cm.LinkTarget(cm.matfilter,1,2,nil))
	e0:SetOperation(cm.LinkOperation(cm.matfilter,1,2,nil))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK)) or c:IsType(TYPE_TRAP)
end
function cm.LConditionFilter(c,f,lc)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and (c:IsCanBeLinkMaterial(lc) or c:IsType(TYPE_TRAP)) and (not f or f(c))
end
function cm.LExtraFilter(c,f,lc,tp)
	if c:IsLocation(LOCATION_MZONE) and not c:IsFaceup() then return false end
	return c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp) and (c:IsCanBeLinkMaterial(lc) or c:IsType(TYPE_TRAP)) and (not f or f(c))
end
function cm.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter,tp,LOCATION_ONFIELD,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(cm.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and not f(te,lc,mg) then return false end
	end
	return true
end
function cm.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not cm.LCheckOtherMaterial(c,mg,lc,tp)
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(cm.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(cm.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function cm.LExtraMaterialCount(mg,lc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			if not f or f(te,lc,sg) then
				te:UseCountLimit(tp)
			end
		end
	end
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
				local cancel=Duel.GetCurrentChain()==0
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				cm.LExtraMaterialCount(g,c,tp)
				local cg=g:Filter(Card.IsFacedown,1,nil)
				if #cg>0 then Duel.ConfirmCards(tp,cg) end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)return not c:IsSetCard(0x535)end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,c:GetSummonPlayer())
	if not c:IsSummonType(SUMMON_TYPE_LINK) or e:GetLabel()~=1 then return end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.setfilter(c)
	return c:IsSetCard(0x535) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	if #mg>0 and not mg:IsExists(function(c)return c:GetType()&0x20004~=0x20004 end,1,nil) then e:GetLabelObject():SetLabel(1) else e:GetLabelObject():SetLabel(0) end
end
