--放课后五座流星群
function c28362118.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c28362118.LinkCondition(nil,3,5,aux.dabcheck))
	e0:SetTarget(c28362118.LinkTarget(nil,3,5,aux.dabcheck))
	e0:SetOperation(Auxiliary.LinkOperation(nil,3,5,aux.dabcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c28362118.matcheck)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(28362118,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	--e2:SetCondition(c28362118.spcon)
	e2:SetTarget(c28362118.sptg)
	e2:SetOperation(c28362118.spop)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28362118,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCondition(c28362118.ctcon)
	e3:SetTarget(c28362118.cttg)
	e3:SetOperation(c28362118.ctop)
	c:RegisterEffect(e3)
end
function c28362118.GetLinkCount(c)
	if c:IsSetCard(0x286) then
		return 1+0x10000*2
	elseif c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function c28362118.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(c28362118.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c28362118.LinkCondition(f,minc,maxc,gf)
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
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(c28362118.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function c28362118.LinkTarget(f,minc,maxc,gf)
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
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,c28362118.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c28362118.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(ct*600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c28362118.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28362118.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c28362118.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c28362118.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 and e:GetHandler():GetBaseAttack()>=1000 end
	local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	ft=math.min(ft,(math.floor(e:GetHandler():GetBaseAttack()/1000)))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c28362118.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c28362118.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c28362118.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c28362118.ctfilter(c,e)
	local p=c:GetControler()
	return Duel.GetMZoneCount(p,c,p,LOCATION_REASON_CONTROL)>0 and c:IsCanBeEffectTarget(e) and c:IsFaceup() and c:IsAbleToChangeControler()
end
function c28362118.gcheck(g)
	return aux.gfcheck(g,Card.IsControler,0,1) and g:GetClassCount(Card.GetAttribute)==1
end
function c28362118.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c28362118.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return g:CheckSubGroup(c28362118.gcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=g:SelectSubGroup(tp,c28362118.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,sg,2,0,0)
end
function c28362118.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g~=2 then return end
	Duel.SwapControl(g:GetFirst(),g:GetNext())
end
