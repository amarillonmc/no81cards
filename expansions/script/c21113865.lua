--芳青之梦 喵殿下
function c21113865.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21113865.linkcon())
	e0:SetTarget(c21113865.linktg())
	e0:SetOperation(aux.LinkOperation())
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e1:SetCondition(c21113865.discon)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21113865)
	e2:SetCost(c21113865.cost)
	e2:SetTarget(c21113865.tg)
	e2:SetOperation(c21113865.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_DEFCHANGE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,21113866)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c21113865.tg3)
	e3:SetOperation(c21113865.op3)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113865.cost5)
	e5:SetOperation(c21113865.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113865,ACTIVITY_SPSUMMON,c21113865.counter)	
end
function c21113865.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113865.LCheckGoal(sg,tp,lc,lmat)
	return #sg==2 and sg:IsExists(Card.IsDisabled,1,nil) 
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat)) or #sg>=2 
		and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,3,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function c21113865.linkcon()
	return	function(e,c,og,lmat)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=2
				local maxc=3
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
				return mg:CheckSubGroup(c21113865.LCheckGoal,minc,maxc,tp,c,lmat)
			end
end
function c21113865.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=2
				local maxc=3
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
				local sg=mg:SelectSubGroup(tp,c21113865.LCheckGoal,cancel,minc,maxc,tp,c,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21113865.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113865.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113865.opq)
	Duel.RegisterEffect(e1,tp)
end
function c21113865.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113865)==0 and Duel.SelectYesNo(tp,aux.Stringid(21113865,2)) then
	Duel.Damage(1-tp,1500,REASON_RULE)
	end
	Duel.ResetFlagEffect(tp,21113865)
	e:Reset()
end
function c21113865.q(c)
	return c:IsFaceup() and c:IsSetCard(0xc914)
end
function c21113865.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113865.q,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,4)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(11,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1,tp)
end
function c21113865.move(c,seq)
	if not c21113865.q(c) then return end
	if c:IsFacedown() then return end
	if c:GetSequence()~=seq then 
		return true
	else return end
end
function c21113865.seq(c,seq)
	if c:GetSequence()==seq then 
		return true
	else return end
end
function c21113865.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113865,RESET_PHASE+PHASE_END,0,1)
	local seq=e:GetLabel()
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c21113865.move,tp,LOCATION_MZONE,0,1,1,nil,seq):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
	local oc=Duel.GetMatchingGroup(c21113865.seq,tp,LOCATION_MZONE,0,nil,seq):GetFirst()
	if oc then Duel.Destroy(oc,REASON_RULE) end
	Duel.MoveSequence(tc,seq)
	Duel.Draw(tp,1,REASON_EFFECT)
	end	
end
function c21113865.w(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0))
end
function c21113865.e(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc914) and c:IsLevelAbove(1) and c:IsType(1)
end
function c21113865.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113865.w,tp,4,4,1,nil) and Duel.IsExistingMatchingCard(c21113865.e,tp,3,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21113865.w,tp,4,4,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c21113865.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,c21113865.e,tp,3,0,1,1,nil):GetFirst()
	if sc and Duel.SendtoGrave(sc,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
	local lv=sc:GetLevel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-lv*500)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(-lv*500)
	tc:RegisterEffect(e2)
		if not tc:IsHasEffect(108) then
		Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
function c21113865.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113865,tp,ACTIVITY_SPSUMMON)==0
end
function c21113865.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113865.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113865.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end