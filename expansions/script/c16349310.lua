--中坚骑士 骑士兽
function c16349310.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_SPSUMMON_SUCCESS)
	e00:SetCondition(c16349310.regcon)
	e00:SetOperation(c16349310.regop)
	c:RegisterEffect(e00)
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c16349310.LinkCondition(c16349310.matfilter,2,3,c16349310.lcheck))
	e0:SetTarget(c16349310.LinkTarget(c16349310.matfilter,2,3,c16349310.lcheck))
	e0:SetOperation(c16349310.LinkOperation(c16349310.matfilter,2,3,c16349310.lcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c16349310.val)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(0,LOCATION_MZONE)
	e11:SetValue(c16349310.bttg)
	c:RegisterEffect(e11)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16349310)
	e2:SetTarget(c16349310.sptg)
	e2:SetOperation(c16349310.spop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1,16349310+1)
	e3:SetTarget(c16349310.destg)
	e3:SetOperation(c16349310.desop)
	c:RegisterEffect(e3)
end
function c16349310.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c16349310.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c16349310.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16349310.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(16349310) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c16349310.val(e,c)
	return e:GetHandler():GetLinkedGroupCount()*(-500)
end
function c16349310.bttg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c16349310.spfilter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
		and c:IsFaceupEx()
end
function c16349310.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c16349310.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c16349310.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16349310.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16349310.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c16349310.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsAttackBelow,Card.IsFaceup),tp,0,LOCATION_MZONE,nil,atk)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16349310.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.AND(Card.IsAttackBelow,Card.IsFaceup),tp,0,LOCATION_ONFIELD,1,1,nil,atk)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c16349310.matfilter(c)
	return c:IsType(0x1) or c:IsSetCard(0x3dc2) and c:IsType(TYPE_CONTINUOUS)
end
function c16349310.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_WARRIOR)
end
function c16349310.LConditionFilter(c,f,lc)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and (c:IsCanBeLinkMaterial(lc) or c:IsSetCard(0x3dc2) and c:IsType(TYPE_CONTINUOUS)) and (not f or f(c))
end
function c16349310.LExtraFilter(c,f,lc,tp)
	if c:IsLocation(LOCATION_MZONE) and not c:IsFaceup() then return false end
	return c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp) and (c:IsCanBeLinkMaterial(lc) or c:IsSetCard(0x3dc2) and c:IsType(TYPE_CONTINUOUS)) and (not f or f(c))
end
function c16349310.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function c16349310.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(c16349310.LConditionFilter,tp,LOCATION_ONFIELD,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(c16349310.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function c16349310.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and not f(te,lc,mg) then return false end
	end
	return true
end
function c16349310.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not c16349310.LCheckOtherMaterial(c,mg,lc,tp)
end
function c16349310.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(c16349310.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(c16349310.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c16349310.LExtraMaterialCount(mg,lc,tp)
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
function c16349310.LinkCondition(f,minc,maxc,gf)
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
					mg=og:Filter(c16349310.LConditionFilter,nil,f,c)
				else
					mg=c16349310.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not c16349310.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(c16349310.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function c16349310.LinkTarget(f,minc,maxc,gf)
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
					mg=og:Filter(c16349310.LConditionFilter,nil,f,c)
				else
					mg=c16349310.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not c16349310.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.GetCurrentChain()==0
				local sg=mg:SelectSubGroup(tp,c16349310.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c16349310.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				c16349310.LExtraMaterialCount(g,c,tp)
				local cg=g:Filter(Card.IsFacedown,1,nil)
				if #cg>0 then Duel.ConfirmCards(tp,cg) end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end