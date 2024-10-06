--芳青之梦 幻天使
function c21113835.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21113835.linkcon())
	e0:SetTarget(c21113835.linktg())
	e0:SetOperation(aux.LinkOperation())
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e1:SetCondition(c21113835.discon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c21113835.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21113835)
	e3:SetCost(c21113835.cost)
	e3:SetTarget(c21113835.tg)
	e3:SetOperation(c21113835.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,21113836)
	e4:SetCondition(c21113835.con4)
	e4:SetCost(c21113835.cost4)
	e4:SetOperation(c21113835.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113835.cost5)
	e5:SetOperation(c21113835.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113835,ACTIVITY_SPSUMMON,c21113835.counter)	
end
function c21113835.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113835.GetLinkCount(c)
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
function c21113835.LCheckGoal(sg,tp,lc,lmat)
	return #sg==1 and sg:IsExists(Card.IsDisabled,1,nil) 
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and sg:GetFirst():IsLink(3) or #sg>=2 
		and sg:CheckWithSumEqual(c21113835.GetLinkCount,6,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat)) or #sg>=2 
		and sg:CheckWithSumEqual(aux.GetLinkCount,6,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c21113835.linkcon()
	return	function(e,c,og,lmat)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=1
				local maxc=6
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
				return mg:CheckSubGroup(c21113835.LCheckGoal,minc,maxc,tp,c,lmat)
			end
end
function c21113835.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=1
				local maxc=6
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
				local sg=mg:SelectSubGroup(tp,c21113835.LCheckGoal,cancel,minc,maxc,tp,c,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21113835.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113835.disable(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:IsFaceup()
end
function c21113835.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113835.opq)
	Duel.RegisterEffect(e1,tp)
end
function c21113835.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113835)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113835,1)) then
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,2,nil)	
	Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	end
	Duel.ResetFlagEffect(tp,21113835)
	e:Reset()
end
function c21113835.q(c)
	return c:IsFaceup() and c:IsSetCard(0xc914)
end
function c21113835.w(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0xc914) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and not c:IsCode(21113835)
end
function c21113835.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113835.q,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,4)>0 end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(11,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
end
function c21113835.move(c,seq)
	if not c21113835.q(c) then return end
	if c:IsFacedown() then return end
	if c:GetSequence()~=seq then 
		return true
	else return end
end
function c21113835.seq(c,seq)
	if c:GetSequence()==seq then 
		return true
	else return end
end
function c21113835.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113835,RESET_PHASE+PHASE_END,0,1)
	local seq=e:GetLabel()
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c21113835.move,tp,LOCATION_MZONE,0,1,1,nil,seq):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
	local oc=Duel.GetMatchingGroup(c21113835.seq,tp,LOCATION_MZONE,0,nil,seq):GetFirst()
	if oc then Duel.Destroy(oc,REASON_RULE) end
	Duel.MoveSequence(tc,seq)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c21113835.w),tp,0x30,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(21113835,0)) then
		Duel.Hint(3,tp,HINTMSG_SPSUMMON)	
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21113835.w),tp,0x30,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end	
end
function c21113835.con4(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c21113835.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113835.opw)
	Duel.RegisterEffect(e1,tp)
end
function c21113835.r(c)
	return c:IsType(6) and c:IsSetCard(0xc914) and c:IsSSetable()
end
function c21113835.opw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113835+1)==0 and Duel.IsExistingMatchingCard(c21113835.r,tp,1,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113835,2)) then
	Duel.Hint(3,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21113835.r,tp,1,0,1,1,nil)
		if #g>0 then		
		Duel.SSet(tp,g:GetFirst())
		end
	end
	Duel.ResetFlagEffect(tp,21113835+1)
	e:Reset()
end
function c21113835.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113835+1,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(12,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc914))
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(12,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc914))
	e2:SetValue(aux.indoval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c21113835.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113835,tp,ACTIVITY_SPSUMMON)==0
end
function c21113835.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113835.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113835.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end