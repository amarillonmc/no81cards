--洛天依「日面」
function c21185825.initial_effect(c)
	c:SetSPSummonOnce(21185825)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c21185825.linkcon())
	e1:SetTarget(c21185825.linktg())
	e1:SetOperation(aux.LinkOperation())
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c21185825.con)
	e2:SetTarget(c21185825.tg)
	e2:SetOperation(c21185825.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c21185825.con3)
	e3:SetOperation(c21185825.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+0x200+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,21185825)
	e4:SetCondition(c21185825.con4)
	e4:SetTarget(c21185825.tg4)
	e4:SetOperation(c21185825.op4)
	c:RegisterEffect(e4)
end
function c21185825.LConditionFilter(c,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE)) and c:IsCanBeLinkMaterial(lc)
end
function c21185825.LExtraFilter(c,lc,tp)
	if not c:IsLinkType(TYPE_EFFECT) or not (c:IsLinkType(TYPE_LINK) and c:IsLink(5)) then return end
	if c:IsOnField() and c:IsFacedown() then return end
	if not c:IsCanBeLinkMaterial(lc) then return end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function c21185825.GetLinkMaterials(tp,lc,e)
	local mg=Duel.GetMatchingGroup(c21185825.LConditionFilter,tp,LOCATION_MZONE,0,nil,lc,e)
	local mg2=Duel.GetMatchingGroup(c21185825.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,lc,tp)
	return mg
end
function c21185825.onlycheck(c,lc,mg)
	return mg and c:IsCanBeLinkMaterial(lc) and mg:IsContains(c) and c:IsLink(5) and c:GetSequence()>=5
end
function c21185825.gf(c,lc,sg)
	return sg and c:IsCanBeLinkMaterial(lc) and c:IsLinkType(TYPE_LINK) and c:GetSequence()>=5
end
function c21185825.LCheckGoal(sg,tp,lc,lmat)
	return #sg>=4
		and sg:IsExists(c21185825.gf,1,nil,cl,sg)
		and sg:CheckWithSumEqual(aux.GetLinkCount,5,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
		and not sg:IsExists(aux.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c21185825.LCheckGoal2(sg,tp,lc,lmat)
	return #sg==1 
		and sg:IsExists(c21185825.onlycheck,1,nil,lc,sg)
		or #sg>=4 
		and sg:IsExists(c21185825.gf,1,nil,cl,sg)
		and sg:CheckWithSumEqual(aux.GetLinkCount,5,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
		and not sg:IsExists(aux.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
		and #sg==sg:Filter(Card.IsLinkType,nil)
end
function c21185825.linkcon()
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=1
				local maxc=5
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg
				if og then
					mg=og:Filter(c21185825.LConditionFilter,nil,c,e)
				else
					mg=c21185825.GetLinkMaterials(tp,c,e)
				end				
				if lmat~=nil then
					if not c21185825.LConditionFilter(lmat,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(c21185825.LCheckGoal,minc,maxc,tp,c,lmat) or mg:IsExists(c21185825.onlycheck,1,nil,c,mg)
			end
end
function c21185825.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=1
				local maxc=5
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg
				if og then
					mg=og:Filter(c21185825.LConditionFilter,nil,c,e)
				else
					mg=c21185825.GetLinkMaterials(tp,c,e)
				end
				if lmat~=nil then
					if not c21185825.LConditionFilter(lmat,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,c21185825.LCheckGoal2,cancel,minc,maxc,tp,c,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21185825.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21185825.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c21185825.q(c,tp)
	return c:IsType(TYPE_LINK) and c:GetBaseAttack()>0 and c:IsLocation(0x30) and c:IsFaceupEx() and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c21185825.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(aux.NecroValleyFilter(c21185825.q),nil,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if #mg<=0 then return end
	Duel.Hint(3,tp,HINTMSG_EQUIP)
	local g=mg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c21185825.eqlimit)
		tc:RegisterEffect(e1,true)
		local atk=tc:GetBaseAttack()
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(-math.ceil(atk/2))
			tc:RegisterEffect(e2,true)
		end
	end
end
function c21185825.eqlimit(e,c)
	return c==e:GetOwner()
end
function c21185825.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and c:GetSequence()>=5
end
function c21185825.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil)
	if #g>0 then
		for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		end	
	end		
end
function c21185825.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>=3100
end
function c21185825.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,0,0)	
end
function c21185825.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	c:SetEntityCode(21185828,true)
	c:ReplaceEffect(21185828,0,0)
	Duel.Hint(10,1,21185828)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(12,0)
	e1:SetLabel(tp)
	e1:SetCondition(c21185825.con4_1)
	e1:SetValue(c21185825.val4_1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetLabel(tp)
	e2:SetOperation(c21185825.op4_2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(1000)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil) 
		if #g>0 then
			for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			end
		end
	end
end
function c21185825.con4_1(e)
	return Duel.GetFlagEffect(e:GetLabel(),21185825)>0
end
function c21185825.val4_1(e,te)
	return e:GetLabel() and te:GetOwnerPlayer()~=e:GetLabel()
end
function c21185825.op4_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(e:GetLabel(),21185825)
	e:Reset()
end