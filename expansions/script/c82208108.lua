local m=82208108
local cm=_G["c"..m]
cm.name="电子湮灭龙"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()  
	aux.AddXyzProcedure(c,nil,10,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzLevelFreeCondition(cm.matfilter,nil,1,99))
	e1:SetTarget(cm.XyzLevelFreeTarget(cm.matfilter,nil,1,99))
	e1:SetOperation(cm.XyzLevelFreeOperation(cm.matfilter,nil,1,99))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetHintTiming(0,TIMING_DAMAGE_STEP+TIMING_END_PHASE)  
	e2:SetCountLimit(1)  
	e2:SetCondition(aux.dscon)  
	e2:SetTarget(cm.atktg)  
	e2:SetOperation(cm.atkop)  
	c:RegisterEffect(e2)  
	--copy effect  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)  
	e3:SetCountLimit(1)  
	e3:SetCost(cm.copycost)  
	e3:SetTarget(cm.copytg)  
	e3:SetOperation(cm.copyop)  
	c:RegisterEffect(e3)  
end
function cm.matfilter(c)
	return c:IsCode(70095154)
end
function cm.XyzLevelFreeFilter(c,xyzc,f)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function cm.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function cm.XyzLevelFreeCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(cm.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(cm.XyzLevelFreeFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c,f)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(cm.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function cm.XyzLevelFreeTarget(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
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
					mg=og:Filter(cm.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(cm.XyzLevelFreeFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c,f)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.GetCurrentChain()==0
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,cm.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.XyzLevelFreeOperation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function cm.atkfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end  
function cm.tgfilter(c)  
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.atkfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)  
	local gc=g:GetFirst()  
	if gc and Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then   
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e1:SetValue(1000)  
		tc:RegisterEffect(e1)  
		local e3=Effect.CreateEffect(e:GetHandler())  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_IMMUNE_EFFECT)  
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
		e3:SetRange(LOCATION_MZONE)  
		e3:SetValue(cm.efilter)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e3:SetOwnerPlayer(tp)  
		tc:RegisterEffect(e3)  
	end  
end  
function cm.efilter(e,re)  
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()  
end  
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():GetFlagEffect(41209827)==0 end  
	e:GetHandler():RegisterFlagEffect(41209827,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
end  
function cm.copyfilter(c)  
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsRace(RACE_MACHINE)
end  
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()  
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and cm.copyfilter(chkc) and chkc~=c end  
	if chk==0 then return Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)  
end  
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) then  
		local code=tc:GetOriginalCodeRule()  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_CHANGE_CODE)  
		e1:SetValue(code)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e1)  
		if not tc:IsType(TYPE_TRAPMONSTER) then  
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)  
		end   
	end  
end  