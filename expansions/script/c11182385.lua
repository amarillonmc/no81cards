--至高主宰·沃茨·地之君王
function c11182385.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c11182385.AddXyzProcedureLevelFree(c,c11182385.mfilter,nil,2,2)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6454))
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_ONFIELD,0)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6454))
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e12)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,11182385)
	e2:SetTarget(c11182385.settg)
	e2:SetOperation(c11182385.setop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c11182385.immunefilter)
	c:RegisterEffect(e3)
end
function c11182385.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
		and (te:GetHandler():IsAttribute(ATTRIBUTE_EARTH) or te:GetHandler():IsType(TYPE_XYZ))
		or te:IsActiveType(0x6)
end
function c11182385.setfilter(c)
	return c:IsSetCard(0x6454) and c:IsType(0x6) and c:IsFaceupEx() and c:IsSSetable()
end
function c11182385.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182385.setfilter,tp,0x30,0,2,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
end
function c11182385.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c11182385.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ch=Duel.GetCurrentChain()
	local ck=false
	if ch>1 then
		local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
		if code==11182330 then ck=true end
	end
	local b1=Duel.IsExistingMatchingCard(c11182385.setfilter,tp,LOCATION_DECK,0,2,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	local b2=Duel.GetMatchingGroupCount(c11182385.posfilter,tp,0,LOCATION_MZONE,nil)>0 and ck
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(11182385,1)},{b2,aux.Stringid(11182385,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182385.setfilter),tp,0x30,0,2,2,nil)
		if g:GetCount()>1 then
			Duel.SSet(tp,g)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c11182385.posfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
			local og=Duel.GetOperatedGroup()
			for tc in aux.Next(og) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c11182385.mfilter(c,xyzc)
	return c:IsSetCard(0x6454) and c:IsFaceup()
		and (c:IsXyzLevel(xyzc,4) or c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+0x6))
end
function c11182385.AddXyzProcedureLevelFree(c,f,gf,minc,maxc,alterf,alterdesc,alterop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11182385.XyzLevelFreeCondition(f,gf,minc,maxc,alterf,alterdesc,alterop))
	e1:SetTarget(c11182385.XyzLevelFreeTarget(f,gf,minc,maxc,alterf,alterdesc,alterop))
	e1:SetOperation(c11182385.XyzLevelFreeOperation(f,gf,minc,maxc,alterf,alterdesc,alterop))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function c11182385.XyzLevelFreeCondition(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
				end
				if alterf and (not min or min<=1) then
					if mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop) then
						return true
					end
				end
				mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function c11182385.XyzLevelFreeTarget(f,gf,minct,maxct,alterf,alterdesc,alterop)
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
					mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
				end
				local b1=true
				local b2=false
				local altg=nil
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if alterf and (not min or min<=1) then
					altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
					mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
					Duel.SetSelectedCard(sg)
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					b1=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
					b2=#altg>0
				else
					mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				end
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
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c11182385.XyzLevelFreeOperation(f,gf,minct,maxct,alterf,alterdesc,alterop)
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