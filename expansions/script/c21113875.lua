--芳青之梦 天桃环
function c21113875.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21113875.linkcon())
	e0:SetTarget(c21113875.linktg())
	e0:SetOperation(aux.LinkOperation())
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e1:SetCondition(c21113875.discon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21113875)
	e2:SetCondition(c21113875.con)
	e2:SetCost(c21113875.cost)
	e2:SetTarget(c21113875.tg)
	e2:SetOperation(c21113875.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetDescription(1,21113876)
	e3:SetCost(c21113875.cost3)
	e3:SetTarget(c21113875.tg3)
	e3:SetOperation(c21113875.op3)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113875.cost5)
	e5:SetOperation(c21113875.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113875,ACTIVITY_SPSUMMON,c21113875.counter)	
end
function c21113875.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113875.GetLinkCount(c)
	if c:IsType(TYPE_LINK) then
		if c:IsSetCard(0xc914) and c:IsDisabled() then
			return 1+0x10000*c:GetLink()*2
		else 
			return 1+0x10000*c:GetLink()
		end	
	else
		if c:IsSetCard(0xc914) and c:IsDisabled() then
			return 2
		else			
			return 1 
		end
	end
end
function c21113875.LCheckGoal(sg,tp,lc,lmat)
	return #sg==1 and sg:IsExists(Card.IsDisabled,1,nil) 
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and sg:GetFirst():IsLink(2) or #sg>=2 
		and sg:CheckWithSumEqual(c21113875.GetLinkCount,4,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat)) or #sg>=2 
		and sg:CheckWithSumEqual(aux.GetLinkCount,4,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c21113875.linkcon()
	return	function(e,c,og,lmat)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=1
				local maxc=4
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local f = function(c) return c:IsFaceup() and c:IsLinkSetCard(0xc914) end
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
				return mg:CheckSubGroup(c21113875.LCheckGoal,minc,maxc,tp,c,lmat)
			end
end
function c21113875.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=1
				local maxc=4
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local f = function(c) return c:IsFaceup() and c:IsLinkSetCard(0xc914) end
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
				local sg=mg:SelectSubGroup(tp,c21113875.LCheckGoal,cancel,minc,maxc,tp,c,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21113875.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113875.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21113875.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113875.opq)
	Duel.RegisterEffect(e1,tp)
end
function c21113875.opq(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,21113875)==0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21113875,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc914))
	Duel.RegisterEffect(e1,tp)
	end
	Duel.ResetFlagEffect(tp,21113875)
	e:Reset()
end
function c21113875.q(c,e,tp)
	return c:IsSetCard(0xc914) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(21113875) and Duel.GetLocationCount(tp,4)>0
end
function c21113875.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113875.q,tp,0x10,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21113875.q,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,0x10)
end
function c21113875.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113875,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21113875.w(c)
	return c:IsFaceup() and c:IsSetCard(0xc914) and c:IsAbleToRemoveAsCost()
end
function c21113875.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c21113875.w,tp,4,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21113875.w,tp,4,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113875.opw)
	Duel.RegisterEffect(e1,tp)
end
function c21113875.opw(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,12,12)
	if Duel.GetFlagEffect(tp,21113875+1)==0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(21113875,0)) then 
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,2,nil)
		if #dg>0 then
		Duel.Destroy(dg,REASON_RULE)
		end	
	end
	Duel.ResetFlagEffect(tp,21113875+1)
	e:Reset()
end
function c21113875.e(c)
	return c:IsType(1) and c:IsSetCard(0xc914) and c:IsAbleToDeck()
end
function c21113875.r(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c) and c:IsSetCard(0xc914) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:IsLink(3)
end
function c21113875.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.IsExistingMatchingCard(c21113875.e,tp,0x10,0,1,nil) and Duel.IsExistingMatchingCard(c21113875.r,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x10)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21113875.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113875+1,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c21113875.e,tp,0x10,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c21113875.r,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c21113875.r,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg>0 then
		sg:GetFirst():SetMaterial(nil)
			if Duel.SpecialSummon(sg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
			sg:GetFirst():CompleteProcedure()
			end
		end
	end	
end
function c21113875.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113875,tp,ACTIVITY_SPSUMMON)==0
end
function c21113875.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113875.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113875.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end