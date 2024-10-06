--芳青之梦 白烨鹿
function c21113830.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21113830.linkcon())
	e0:SetTarget(c21113830.linktg())
	e0:SetOperation(aux.LinkOperation())
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e1:SetCondition(c21113830.discon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21113830,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,21113830)
	e2:SetCost(c21113830.cost)
	e2:SetTarget(c21113830.tg)
	e2:SetOperation(c21113830.op)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21113830,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,21113831)
	e3:SetCost(c21113830.cost3)
	e3:SetTarget(c21113830.tg3)
	e3:SetOperation(c21113830.op3)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113830.cost5)
	e5:SetOperation(c21113830.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113830,ACTIVITY_SPSUMMON,c21113830.counter)	
end
function c21113830.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113830.GetLinkCount(c)
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
function c21113830.LCheckGoal(sg,tp,lc,lmat)
	return #sg==1 and sg:IsExists(Card.IsDisabled,1,nil) 
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and sg:GetFirst():IsLink(2) or #sg>=2 
		and sg:CheckWithSumEqual(c21113830.GetLinkCount,4,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat)) or #sg>=2 
		and sg:CheckWithSumEqual(aux.GetLinkCount,4,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c21113830.linkcon()
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
				return mg:CheckSubGroup(c21113830.LCheckGoal,minc,maxc,tp,c,lmat)
			end
end
function c21113830.linktg()
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
				local sg=mg:SelectSubGroup(tp,c21113830.LCheckGoal,cancel,minc,maxc,tp,c,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21113830.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113830.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113830.opq)
	Duel.RegisterEffect(e1,tp)
end
function c21113830.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113830)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113830,5)) then
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
		if #g1>0 and (#g3==0 or Duel.SelectYesNo(tp,aux.Stringid(21113830,3))) then
			Duel.Hint(3,tp,HINTMSG_REMOVE)
			local sg1=g1:RandomSelect(tp,1)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
		end
		if #g3>0 and (#sg==0 or Duel.SelectYesNo(tp,aux.Stringid(21113830,4))) then
			Duel.Hint(3,tp,HINTMSG_REMOVE)
			local sg3=g3:RandomSelect(tp,1)
			sg:Merge(sg3)
		end
		Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	end
	Duel.ResetFlagEffect(tp,21113830)
	e:Reset()
end
function c21113830.q(c,e,tp)
	return c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and c:IsSetCard(0xc914) and not c:IsCode(21113830)
end
function c21113830.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113830.q,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21113830.q,tp,0x30,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0x30)
end
function c21113830.o(c)
	local seq=c:GetSequence()
	local tp=c:GetControler()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c21113830.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113830,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(tp,4)>0 and Duel.GetMatchingGroupCount(c21113830.o,tp,4,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(21113830,2)) then
	Duel.BreakEffect()
	Duel.Hint(3,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c21113830.o,tp,4,0,1,1,nil):GetFirst()
	local seq=tc:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
	flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
	flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	end
end
function c21113830.w(c)
	return c:IsFaceup() and c:IsReleasable() and c:IsSetCard(0xc914)
end
function c21113830.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c21113830.w,tp,4,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21113830.w,tp,4,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113830.opw)
	Duel.RegisterEffect(e1,tp)
end
function c21113830.e(c)
	return c:IsSetCard(0xc914) and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function c21113830.e1(c)
	return c:IsSetCard(0xc914) and c:IsAbleToGrave()
end
function c21113830.e2(c)
	return c:IsSetCard(0xc914) and c:IsAbleToHand()
end
function c21113830.opw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113830+1)==0 and Duel.IsExistingMatchingCard(c21113830.e,tp,1,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113830,7)) then
	local g1=Duel.GetMatchingGroup(c21113830.e1,tp,1,0,nil)
	local g2=Duel.GetMatchingGroup(c21113830.e2,tp,1,0,nil)
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(21113830,8),0},{#g2>0,aux.Stringid(21113830,9),1})
		if op==0 then 
			Duel.Hint(3,tp,HINTMSG_TOGRAVE)
			local g=g1:Select(tp,1,1,nil)
			Duel.SendtoGrave(g,REASON_RULE)
		elseif op==1 then
			Duel.Hint(3,tp,HINTMSG_ATOHAND)
			local g=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ResetFlagEffect(tp,21113830+1)
	e:Reset()
end
function c21113830.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end
function c21113830.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113830+1,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	if Duel.Damage(1-tp,1500,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,12,12,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113830,6)) then
	Duel.BreakEffect()
	Duel.Hint(3,tp,HINTMSG_DISABLE)
	local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,12,12,1,1,nil):GetFirst()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	end
end
function c21113830.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113830,tp,ACTIVITY_SPSUMMON)==0
end
function c21113830.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113830.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113830.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end