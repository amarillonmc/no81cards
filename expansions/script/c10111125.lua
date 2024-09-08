function c10111125.initial_effect(c)
	--xyz summon
	c10111125.AddXyzProcedure(c,c10111125.mfilter,4,2,c10111125.ovfilter,aux.Stringid(10111125,0),2,c10111125.xyzop)
	c:EnableReviveLimit()
    	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c10111125.exatkcon)
	e1:SetTarget(c10111125.exatktg)
	e1:SetValue(c10111125.exatkval)
	c:RegisterEffect(e1)
    	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c10111125.atkcon)
	e2:SetTarget(c10111125.atktg)
	c:RegisterEffect(e2)
    	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c10111125.checkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
    	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10111125,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10111125)
	e4:SetTarget(c10111125.mttg)
	e4:SetOperation(c10111125.mtop)
	c:RegisterEffect(e4)
    	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10111125,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,101111250)
	e5:SetCondition(c10111125.discon)
	e5:SetCost(c10111125.discost)
	e5:SetTarget(c10111125.distg)
	e5:SetOperation(c10111125.disop)
	c:RegisterEffect(e5)
end
function c10111125.mfilter(c)
	return c:IsRace(RACE_DINOSAUR)
end
function c10111125.ovfilter(c)
	return c:IsFaceup() and c:IsCode(90173539)
end
function c10111125.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10111125)==0 end
	Duel.RegisterFlagEffect(tp,10111125,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c10111125.deffilter(c)
	return c:IsAttackPos() and c:IsRace(RACE_DINOSAUR) and c:IsFaceup()
end
function c10111125.exatkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c10111125.deffilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10111125.exatktg(e,c)
	return c:IsSetCard(0x11a) and c:GetSequence()>=5
end
function c10111125.exatkval(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c10111125.deffilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)
end
function c10111125.atkcon(e)
	return e:GetHandler():GetFlagEffect(10111125)~=0
end
function c10111125.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c10111125.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(10111125)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(10111125,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c10111125.mtfilter(c)
	return c:IsSetCard(0x11a) and c:IsCanOverlay() and c:IsType(TYPE_MONSTER)
end
function c10111125.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c10111125.mtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c10111125.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c10111125.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c10111125.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainNegatable(ev)
end
function c10111125.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c10111125.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10111125.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(10111125,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end



--Xyz Summon
function c10111125.XyzAlterFilter(c,alterf,xyzc,e,tp,alterop)
    return alterf(c,e,tp,xyzc) and (c:IsCanBeXyzMaterial(xyzc) or c:IsLocation(LOCATION_FZONE)) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not alterop or alterop(e,tp,0,c))
end
function c10111125.AddXyzProcedure(c,f,lv,ct,alterf,alterdesc,maxct,alterop)
	if not maxct then maxct=ct end
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	if alterf then
		e0:SetCondition(c10111125.XyzConditionAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
		e0:SetTarget(c10111125.XyzTargetAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
		e0:SetOperation(c10111125.XyzOperationAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
	else
		e0:SetCondition(c10111125.XyzCondition(f,lv,ct,maxct))
		e0:SetTarget(c10111125.XyzTarget(f,lv,ct,maxct))
		e0:SetOperation(c10111125.XyzOperation(f,lv,ct,maxct))
	end
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
end
function c10111125.XyzConditionAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local mg2=Duel.GetMatchingGroup(c10111125.XyzAlterFilter,tp,LOCATION_FZONE,0,nil,alterf,c,e,tp,alterop)
                mg:Merge(mg2)
				if (not min or min<=1) and mg:IsExists(c10111125.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop) then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function c10111125.XyzTargetAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local altg=mg:Filter(c10111125.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				local altg2=Duel.GetMatchingGroup(c10111125.XyzAlterFilter,tp,LOCATION_FZONE,0,nil,alterf,c,e,tp,alterop)
                altg:Merge(altg2)
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and #altg>0
				local g=nil
				local cancel=Duel.IsSummonCancelable()
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c10111125.XyzOperationAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end