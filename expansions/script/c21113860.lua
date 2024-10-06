--芳青之梦 音长阶
function c21113860.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21113860.linkcon())
	e0:SetTarget(c21113860.linktg())
	e0:SetOperation(aux.LinkOperation())
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e1:SetCondition(c21113860.discon)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21113860)
	e2:SetCondition(c21113860.con)
	e2:SetCost(c21113860.cost)
	e2:SetTarget(c21113860.tg)
	e2:SetOperation(c21113860.op)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113860.cost5)
	e5:SetOperation(c21113860.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113860,ACTIVITY_SPSUMMON,c21113860.counter)	
end
function c21113860.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113860.LCheckGoal(sg,tp,lc,lmat)
	return #sg==1 and sg:IsExists(Card.IsDisabled,1,nil) 
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 or #sg==2 
		and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,2,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c21113860.linkcon()
	return	function(e,c,og,lmat)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=1
				local maxc=2
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
				return mg:CheckSubGroup(c21113860.LCheckGoal,minc,maxc,tp,c,lmat)
			end
end
function c21113860.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=1
				local maxc=2
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
				local sg=mg:SelectSubGroup(tp,c21113860.LCheckGoal,cancel,minc,maxc,tp,c,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21113860.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113860.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21113860.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113860.opq)
	Duel.RegisterEffect(e1,tp)
end
function c21113860.q(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc914) and Duel.GetLocationCount(tp,4)>0
end
function c21113860.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113860)==0 and Duel.IsExistingMatchingCard(c21113860.q,tp,0x10,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(21113860,0)) then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21113860.q,tp,0x10,0,1,1,nil,e,tp)
		if #g>0 then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.ResetFlagEffect(tp,21113860)
	e:Reset()
end
function c21113860.w(c)
	return c:IsSetCard(0xc914) and c:IsType(6) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c21113860.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113860.w,tp,0x11,0,1,nil) end
end
function c21113860.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113860,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(3,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21113860.w),tp,0x11,0,1,1,nil)
	if #g>0 then
	Duel.SSet(tp,g:GetFirst())
	end	
end
function c21113860.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113860,tp,ACTIVITY_SPSUMMON)==0
end
function c21113860.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113860.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113860.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end